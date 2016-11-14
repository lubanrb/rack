module Luban
  module Deployment
    module Applications
      class Rack
        module WebServer
          using Luban::CLI::CoreRefinements

          def default_web_server_options
            raise NotImplementedError, "#{self.class.name}##{__method__} is an abstract method."
          end

          def web_servers_available
            @web_servers ||= [:thin, :puma]
          end

          def web_servers_unused
            @web_servers_unused ||= web_servers_available.select { |s| s != current_web_server }
          end

          def current_web_server; web_server[:name]; end

          def publish_web_server; end

          protected

          def init
            super
            load_web_server
          end

          def load_web_server
            require web_server_require_path
            singleton_class.send(:prepend, web_server_module(web_server_require_path))
          rescue LoadError => e
            abort "Aborted! Failed to load web server #{current_web_server.inspect}."
          end

          def web_server_require_path
            @web_server_require_path ||= web_server_require_root.join(current_web_server.to_s)
          end

          def web_server_require_root
            @web_server_require_root ||= Pathname.new("luban/deployment/applications/rack/web_servers")
          end

          def web_server_module(path)
            @web_server_module ||= Object.const_get(path.to_s.camelcase, false)
          end

          def set_web_server_options
            web_server[:opts] = default_web_server_options.merge(web_server[:opts])
          end
        end
      end
    end
  end
end
