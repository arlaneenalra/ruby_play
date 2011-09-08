#!/usr/bin/env ruby

# Establish a library directory for the script
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'haml'
require 'sequel'
require 'sequel/extensions/migration'

# load the current configuration
require 'config/config.rb'


# setup the database
DB = Sequel.connect(settings.db_config)

# automatically migrate the database to the most
# recent version
Sequel::Migrator.apply(DB, 'schema')

# load our database classes
require 'tiny/db'

get '/' do
    @comment_list = Comment.all
    
    haml :index
end

get '/comment' do
    haml :comment_form
end

post '/comment' do
    @comment = Comment.new

    @comment.name = params[:name]
    @comment.email = params[:email]
    @comment.url = params[:website]
    @comment.comment = params[:comment]

    @comment.save

    #haml :posted
    redirect '/'
end


# reset the database
get '/reset' do
    Sequel::Migrator.apply(DB, 'schema', 0)
    Sequel::Migrator.apply(DB, 'schema')
end


