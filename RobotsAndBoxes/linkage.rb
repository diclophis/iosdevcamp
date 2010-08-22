# Linkage connects the clients to the server

class Linkage < EventMachine::Connection
  include EventMachine::Protocols::LineText2

  def receive_line(line)
    puts line.inspect
    begin
      if line.length > 0
        send_data(JSON.generate(eval(line)) + "\n")
      else
        $play = true
      end
    rescue => problem
      send_data("[]" + "\n")
      puts problem.inspect
      puts problem.backtrace.join("\n")
    end
    close_connection_after_writing
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
