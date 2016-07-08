module Luban
  module Deployment
    module Applications
      class Rack
        class Configurator < Luban::Deployment::Application::Configurator
          using Luban::CLI::CoreRefinements

          include Paths
          include Parameters

          protected

          def init
            load_web_server
          end

          def load_web_server
            require_relative "web_servers/#{web_server}"
            server_module = WebServers.const_get(web_server.camelcase).const_get('Common')
            singleton_class.send(:prepend, server_module)
          end
        end
      end
    end
  end
end
