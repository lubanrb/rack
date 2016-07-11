module Luban
  module Deployment
    module Applications
      class Rack
        module WebServer
          using Luban::CLI::CoreRefinements

          def default_web_server_options
            raise NotImplementedError, "#{self.class.name}##{__method__} is an abstract method."
          end

          protected

          def init
            load_web_server
          end

          def load_web_server
            require web_server_require_path
            singleton_class.send(:prepend, web_server_module(web_server_require_path))
            set_default_web_server_options
          rescue LoadError => e
            abort "Aborted! Failed to load web server #{web_server[:name].inspect}."
          end

          def web_server_require_path
            @web_server_require_path ||= web_server_require_root.join(web_server[:name].to_s)
          end

          def web_server_require_root
            @web_server_require_root ||= Pathname.new("luban/deployment/applications/rack/web_servers")
          end

          def web_server_module(path)
            @web_server_module ||= Object.const_get(path.to_s.camelcase, false)
          end

          def set_default_web_server_options
            web_server[:opts] = default_web_server_options.merge(web_server[:opts])
          end
        end
      end
    end
  end
end
