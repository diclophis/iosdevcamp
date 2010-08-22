ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

class Server < Sinatra::Application
  
  set :root, ROOT
  
  get '/' do
    session[:id] ||= srand
    haml :index, { :layout => :layout }
  end
  
  get '/loading' do
    haml :loading, { :layout => :layout }
  end

  get '/ipad' do
    haml :ipad, { :layout => :layout2 }
  end
  
  post '/player' do
    $grid.add(Player.new(session[:id], params[:lat], params[:lon]))
    return
  end
  
  post '/coordinates' do
    socket = TCPSocket.open('192.168.89.211', 10102)
    socket.write "$grid.at(#{params[:x]},#{params[:y]}).connection.play(#{params[:instrument] || (1..15).sort_by{rand}.first}); $grid\n"
    puts socket.read
    return
  end
  
end


