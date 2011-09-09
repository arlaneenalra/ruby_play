#!/usr/bin/env ruby

# Establish a library directory for the script
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'haml'
require 'sequel'
require 'pp'
#require 'sequel/extensions/migration'

# load the current configuration
require 'config/config.rb'

Sequel.extension :migration

# setup the database
DB = Sequel.connect(settings.db_config)

# automatically migrate the database to the most
# recent version
Sequel::Migrator.apply(DB, 'schema')

# load our database classes
require 'tiny/db'

get '/' do
    @comment_list = Comment.filter(:moderated => true, :deleted => false)
    
    haml :index
end

get '/comment' do
    @comment = Comment.new
    haml :comment_form
end

post '/comment' do
    @comment = Comment.new

    # construct a new comment object, naively
    @comment.name = params[:name]
    @comment.email = params[:email]
    @comment.url = params[:website]
    @comment.comment = params[:comment]
    @comment.ip_address = request.ip

    begin
        @comment.save
        #haml :posted
        redirect '/'

    rescue Sequel::ValidationFailed
        # something went wrong with data validation
        haml :comment_form
    end
end


# reset the database
get '/reset' do
    Sequel::Migrator.apply(DB, 'schema', 0)
    Sequel::Migrator.apply(DB, 'schema')

    redirect '/'
end

def render_errors(obj, sym)
    @error = obj.errors.on(sym)
    @error ||= []
    pp @error

    haml :error_partial
end


