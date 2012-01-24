require 'compass'
require 'sinatra'

set :haml, format: :html5
set :public_folder, 'static'

get '/' do
  haml :index
end

get '/stylesheets/templates/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass(:"stylesheets/templates/#{params[:name]}", Compass.sass_engine_options )
end

get '/stylesheets/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass(:"stylesheets/#{params[:name]}", Compass.sass_engine_options )
end

get '/coffeescripts/:name.js' do
  content_type 'text/application', :charset => 'utf-8'
  coffee :"coffeescripts/#{params[:name]}"
end



helpers do
  def render_partial(name)
    return haml "#{name}".to_sym, :layout => false
  end
end

