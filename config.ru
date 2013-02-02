require 'sinatra'

set :env, :production
set :root, File.dirname(__FILE__)
set :gyazo_server, "localhost:4567"
disable :run

require './app.rb'

run Sinatra::Application

