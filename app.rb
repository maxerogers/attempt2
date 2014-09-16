
require 'rubygems'
require "sinatra"
require "./model.rb"

get "/" do
  erb :index
end
