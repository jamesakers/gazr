module Gazr
  module EventHandler
    class Portable
      include Base

      def initialize
        @reference_mtime = @reference_atime = @reference_ctime = Time.now
      end

      def listen(monitored_paths)
        @monitored_paths = monitored_paths
        loop { trigger; sleep(1) }
      end

      def trigger
        path, type = detect_event
        notify(path, type) unless path.nil?
      end

      def refresh(monitored_paths)
        @monitored_paths = monitored_paths
      end

      private

      def detect_event # OPTIMIZE, REFACTOR
        @monitored_paths.each do |path|
          return [path, :deleted] unless path.exist?
        end

        mtime_path = @monitored_paths.max {|a,b| a.mtime <=> b.mtime }
        atime_path = @monitored_paths.max {|a,b| a.atime <=> b.atime }
        ctime_path = @monitored_paths.max {|a,b| a.ctime <=> b.ctime }

        if    mtime_path.mtime > @reference_mtime then @reference_mtime = mtime_path.mtime; [mtime_path, :modified]
        elsif atime_path.atime > @reference_atime then @reference_atime = atime_path.atime; [atime_path, :accessed]
        elsif ctime_path.ctime > @reference_ctime then @reference_ctime = ctime_path.ctime; [ctime_path, :changed ]
        else; nil; end
      rescue Errno::ENOENT
        retry
      end
    end
  end
end

