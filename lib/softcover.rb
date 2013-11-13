require 'polytexnic-core'
require 'active_support/core_ext/string'

require_relative 'softcover/formats'
require_relative 'softcover/utils'
require_relative 'softcover/output'

profile = false
if profile
  Dir[File.join(File.dirname(__FILE__), '/softcover/**/*.rb')].each do |file|
    t1 = Time.now
    require file.chomp(File.extname(file))
    $stderr.puts "#{Time.now - t1} #{File.basename(file)}"
  end
end

require_relative 'softcover/book'
require_relative 'softcover/book_manifest'
require_relative 'softcover/builder'
require_relative 'softcover/builders/epub'
require_relative 'softcover/builders/html'
require_relative 'softcover/builders/mobi'
require_relative 'softcover/builders/pdf'
require_relative 'softcover/builders/preview'
require_relative 'softcover/cli'
require_relative 'softcover/commands/auth'
require_relative 'softcover/commands/build'
require_relative 'softcover/commands/deployment'
require_relative 'softcover/commands/epub_validator'
require_relative 'softcover/commands/generator'
require_relative 'softcover/commands/opener'
require_relative 'softcover/commands/server'
require_relative 'softcover/mathjax'
require_relative 'softcover/uploader'
require_relative 'softcover/version'

module Softcover
  extend self

  include Softcover::Utils

  # Return the custom styles, if any.
  def custom_styles
    custom_file = 'custom.sty'
    File.exist?(custom_file) ? File.read(custom_file) : ''
  end

  def set_test_mode!
    @test_mode = true
  end

  def test?
    @test_mode
  end

  def profiling?
    return false if test?
    false
  end
end

require 'softcover/rails/railtie' if defined?(Rails)
