# Linkage connects the clients to the server

class Linkage < EventMachine::Connection
  include EventMachine::Protocols::LineText2

  def receive_line(line)
    puts line.inspect
    $last_command = line
  end

  def send_line(line)
    send_data(line + "\n")
  end

  def post_init
    puts "console connected"
  end

  def unbind
    puts "console disconnected"
  end

  def disconnect
    puts "tell client to disconnect"
    close_connection_after_writing
  end

end
