# Linkage connects the clients to the server

class Linkage < EventMachine::Connection
  include EventMachine::Protocols::LineText2

  def receive_binary_data(data)
    raise data.inspect
  end

  def receive_line(line)
    puts line.inspect
  end

  def send_line(line)
    send_data(line)
  end

  def post_init
    puts "client connected"
    $connections[self] = Player.new 
  end

  def unbind
    puts "client disconnected"
    $connections.delete(self)
  end

  def disconnect
    puts "tell client to disconnect"
    close_connection_after_writing
  end

end
