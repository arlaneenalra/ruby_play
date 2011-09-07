#!/usr/bin/env ruby

# Establish a library directory for the script
# $LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'haml'


get '/' do
    haml :index
end

post '/' do
    @name = params[:name]
    @email = params[:email]
    @url = params[:website]
    @comment = params[:comment]

    haml :posted
end



