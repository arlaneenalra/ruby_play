#!/usr/bin/env ruby

# Establish a library directory for the script
# $LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'rubygems'
require 'bundler/setup'
require 'sinatra'


get '/' do
  "Hello World testing Pushing 5"
end


