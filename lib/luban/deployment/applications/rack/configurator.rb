module Luban
  module Deployment
    module Applications
      class Rack
        class Configurator < Luban::Deployment::Application::Configurator
          include Paths
          include Parameters
          include WebServer

          protected

          def init
            super
            set_default_web_server_options unless task.opts.release.nil?
          end

          def web_server_module(path)
            @web_server_module ||= super.const_get('Common')
          end
        end
      end
    end
  end
end
