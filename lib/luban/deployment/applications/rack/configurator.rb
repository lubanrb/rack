module Luban
  module Deployment
    module Applications
      class Rack
        class Configurator < Luban::Deployment::Application::Configurator
          include Paths
          include Parameters
          include WebServer

          def exclude_template?(template)
            super or web_servers_unused.any? { |w| template =~ /^#{w}\./ }
          end

          protected

          def init
            super
            set_web_server_options unless task.opts.release.nil?
          end

          def web_server_module(path)
            @web_server_module ||= super.const_get('Common')
          end
        end
      end
    end
  end
end
