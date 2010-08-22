require File.join(File.dirname(__FILE__), 'lib', 'server.rb')
require File.join(File.dirname(__FILE__), 'lib', 'grid.rb')

enable :sessions

$grid = Grid.new

Server.run!