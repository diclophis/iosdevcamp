ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

class Server < Sinatra::Application
  
  set :root, ROOT
  
  get '/' do
    session[:id] ||= srand
    haml :index
  end
  
  get '/loading' do
    haml :loading
  end
  
  post '/player' do
    $grid.add(Player.new(session[:id], params[:lat], params[:lon]))
    return
  end
  
end


