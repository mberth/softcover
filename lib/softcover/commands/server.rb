require 'listen'

module Softcover::Commands::Server
  include Softcover::Output
  include Softcover::Utils
  attr_accessor :no_listener
  extend self

  # Listens for changes to the book's source files.
  def listen_for_changes
    return if defined?(@no_listener) && @no_listener
    server_pid = Process.pid
    directories = ['.', 'chapters']
    @listener = Listen.to(*directories)
    @listener.filter(/(\.tex|\.md|custom\.sty)$/)
    @listener.change do |modified|
      rebuild modified.try(:first)
      Process.kill("HUP", server_pid)
    end
    @listener.start
  end

  def rebuild(modified=nil)
    printf modified ? "=> #{File.basename modified} changed, rebuilding... " :
                      'Building...'
    t = Time.now
    Softcover::Builders::Html.new.build
    puts "Done. (#{(Time.now - t).round(2)}s)"

  rescue Softcover::BookManifest::NotFound => e
    puts e.message
  end

  def start_server(port)
    require 'softcover/server/app'
    rebuild
    puts "Running Softcover server on http://localhost:#{port}"
    Softcover::App.set :port, port
    Softcover::App.run!
  end

  def run(port)
    listen_for_changes
    start_server port
  end
end
