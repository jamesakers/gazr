module Gazr
  class Script

    DEFAULT_EVENT_TYPE = :modified

    attr_reader :ec
    attr_reader :rules

    Rule = Struct.new(:pattern, :event_type, :action)

    class EvalContext

      def initialize(script)
        @__script = script
      end

      def default_action(&action)
        @__script.default_action(&action)
      end

      def watch(*args, &block)
        @__script.watch(*args, &block)
      end

      def reload
        @__script.parse!
      end
    end


    def initialize(path = nil)
      @path = path
      @rules = []
      @default_action = Proc.new {}
      @ec = EvalContext.new(self)
    end

    def watch(pattern, event_type = DEFAULT_EVENT_TYPE, &action)
      @rules << Rule.new(pattern, event_type, action || @default_action)
      @rules.last
    end

    def default_action(&action)
      @default_action = action if action
      @default_action
    end

    def reset
      @rules = []
      @default_action = Proc.new {}
    end

    def parse!
      return unless @path
      reset
      @ec.instance_eval(@path.read, @path.to_s)
    rescue Errno::ENOENT
      sleep(0.5)
      retry
    ensure
      Gazr.debug('loaded script file %s' % @path.to_s.inspect)
    end

    def action_for(path, event_type = DEFAULT_EVENT_TYPE)
      path = rel_path(path).to_s
      rule = rules_for(path).detect {|rule| rule.event_type.nil? || rule.event_type == event_type }
      if rule
        data = path.match(rule.pattern)
        lambda { rule.action.call(data) }
      else
        lambda {}
      end
    end

    def patterns
      @rules.map {|r| r.pattern }
    end

    def path
      @path && Pathname(@path.respond_to?(:to_path) ? @path.to_path : @path.to_s).expand_path
    end

    private

    def rules_for(path)
      @rules.reverse.select {|rule| path.match(rule.pattern) }
    end

    def rel_path(path)
      Pathname(path).expand_path.relative_path_from(Pathname(Dir.pwd))
    end
  end
end

