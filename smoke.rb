#!/usr/bin/env ruby

# Establish a library directory for the script
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'haml'
require 'sequel'

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
require 'tiny/helpers'

# display list of comments
get '/' do
    @comment_list = Comment.moderated
    
    haml :index
end

# Comment form
get '/comment' do
    @comment = Comment.new
    haml :comment_form
end

# process posted comment form
post '/comment' do
    @comment = Comment.new

    # construct a new comment object, naively
    @comment.name = params[:name].strip
    @comment.email = params[:email].strip
    @comment.url = params[:website].strip
    @comment.comment = params[:comment]
    @comment.ip_address = request.ip

    # attempt to save the new comment
    begin
        # save and redirect
        @comment.save
        redirect '/'

    rescue Sequel::ValidationFailed
        # something went wrong with data validation
        haml :comment_form
    end
end

####
## Remove these latter
####

# reset the database
get '/reset' do
    Sequel::Migrator.apply(DB, 'schema', 0)
    Sequel::Migrator.apply(DB, 'schema')

    redirect '/'
end

# moderate all comments
get '/mod' do
    @comment_list = Comment.unmoderated

    @comment_list.each do |comment|
        comment.moderated = true
        comment.save
    end
    
    redirect '/'
end

