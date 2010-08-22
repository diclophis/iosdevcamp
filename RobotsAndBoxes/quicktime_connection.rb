module EventMachine
  module HttpServer
  end
end

class QuicktimeConnection < EM::Connection
  include EventMachine::HttpServer

  attr_accessor :response
  attr_accessor :go
  attr_accessor :waiting_for_go
  attr_accessor :stream
  attr_accessor :file
  attr_accessor :sound

  def post_init
    @go = false
    @stream = false
    @primed = 0
    @response = nil
    @file = 1
    @sound = 1
    #puts "client connected"
    super
  end

  def unbind
    #puts "client disconnected"
    $connections.delete(self)
    super
  end

  def process_http_request
    # the http request details are available via the following instance variables:
    #   @http_protocol
    #   @http_request_method
    #   @http_cookie
    #   @http_if_none_match
    #   @http_content_type
    #   @http_path_info
    #   @http_request_uri
    #   @http_query_string
    #   @http_post_content
    #   @http_headers
    @response = EventMachine::DelegatedHttpResponse.new(self)
    @response.status = 200
    puts @http_request_uri.inspect
    case @http_request_uri
      when "/"
        @response.content = File.readlines('public/index.html').join
        @response.send_response
      when "/index.m3u8"
        duration = 1 
        m3u = "#EXTM3U\n#EXT-X-ALLOW-CACHE:NO\n#EXT-X-TARGETDURATION:#{duration}\n#EXT-X-MEDIA-SEQUENCE:0\n"
        100.times { |i|
          m3u += "#EXTINF:#{duration}, no desc\nfileSequence#{i}.ts\n"
        }
        m3u += "#EXT-X-ENDLIST\n"
        puts
        puts m3u

        #@response.content = m3u 
        @response.content = m3u #File.readlines('public/index.m3u8').join
        @response.send_response
    else
      @stream = true
      @response.keep_connection_open
      @response.content_type "video/MP2T"
      if @primed > 5
        @response.content = $audio[@sound]
        @timer = EventMachine.add_periodic_timer(WAIT_FPS) {
          if @go 
            @stream = false
            @go = false
            @timer.cancel
            @response.send_response
          end
        }
      else
        @primed += 1 
        @response.content = $audio[0]
        @response.send_response
      end
    end
  end

  def play(sound)
    @go = true
    @sound = sound
  end
end

=begin
      operation = proc do
        @response.content_type "video/MP2T"
        #@response.content = File.open('public/bipbop/gear1' + @http_request_uri).read
        @response.content = File.open('public/bipbop/drumbeat1.ts').read
        puts @response.content.length
        @waiting_for_go = true
        puts "waiting for go"
        until @go
        end
        EventMachine.add_periodic_timer(1.0 / 60.0)
      end
   
      # Callback block to execute once the request is fulfilled
      callback = proc do |res|
        @response.send_response
      end
      # Let the thread pool (20 Ruby threads) handle request
      EM.defer(operation, callback)
=end
