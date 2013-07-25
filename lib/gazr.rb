require "gazr/version"

module Gazr

  begin
    require 'fsevent'
    HAVE_FSE = true
  rescue LoadError, RuntimeError
    HAVE_FSE = false
  end
  
  begin
    require 'rev'
    HAVE_REV = true
  rescue LoadError, RuntimeError
    HAVE_REV = false
  end

  autoload :Script, 'gazr/script'
  autoload :Controller, 'gazr/controller'

  module EventHandler
    autoload :Base,     'gazr/event_handlers/base'
    autoload :Portable, 'gazr/event_handlers/portable'
    autoload :Unix,     'gazr/event_handlers/unix'      if ::Gazr::HAVE_REV
    autoload :Darwin,   'gazr/event_handlers/darwin'    if ::Gazr::HAVE_FSE
  end

  class << self
    attr_accessor :options
    attr_accessor :handler

    def options
      @options ||= Struct.new(:debug).new
      @options.debug ||= false
      @options
    end

    def debug(msg)
      puts "[gazr debug] #{msg}" if options.debug
    end

    def handler
      @handler ||=
        case ENV['HANDLER'] || RbConfig::CONFIG['host_os']
          when /darwin|mach|osx|fsevents?/i
            if Gazr::HAVE_FSE
              Gazr::EventHandler::Darwin
            else
              Gazr.debug "fsevent not found. `gem install ruby-fsevent` to get evented handler"
              Gazr::EventHandler::Portable
            end
          when /sunos|solaris|bsd|linux|unix/i
            if Gazr::HAVE_REV
              Gazr::EventHandler::Unix
            else
              Gazr.debug "rev not found. `gem install rev` to get evented handler"
              Gazr::EventHandler::Portable
            end
          when /mswin|windows|cygwin/i
            Gazr::EventHandler::Portable
          else
            Gazr::EventHandler::Portable
        end
    end
  end
end
