require 'pry'
require 'sinatra'

get '/' do
  erb :index
end


set :view, File.dirname(__FILE__) + '/views'
set :public_folder, File.dirname(__FILE__) + '/public'
