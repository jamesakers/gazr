module Gazr
  class Controller
    def initialize(script, handler)
      @script, @handler = script, handler
      @handler.add_observer(self)
      Gazr.debug "using %s handler" % handler.class.name
    end

    def run
      @script.parse!
      @handler.listen(monitored_paths)
    rescue Interrupt
    end

    def update(path, event_type = nil)
      path = Pathname(path).expand_path

      Gazr.debug("received #{event_type.inspect} event for #{path.relative_path_from(Pathname(Dir.pwd))}")
      if path == @script.path && event_type != :accessed
        @script.parse!
        @handler.refresh(monitored_paths)
      else
        @script.action_for(path, event_type).call
      end
    end

    def monitored_paths
      paths = Dir['**/*'].select do |path|
        @script.patterns.any? {|p| path.match(p) }
      end
      paths.push(@script.path).compact!
      paths.map {|path| Pathname(path).expand_path }
    end
  end
end
