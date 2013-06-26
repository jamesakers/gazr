require 'observer'

module Gazr
  module EventHandler
    class AbstractMethod < Exception; end
    module Base
      include Observable

      def notify(path, event_type = nil)
        changed(true)
        notify_observers(path, event_type)
      end

      def listen(monitored_paths)
        raise AbstractMethod
      end

      def refresh(monitored_paths)
        raise AbstractMethod
      end
    end
  end
end

