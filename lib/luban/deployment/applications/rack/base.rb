module Luban
  module Deployment
    module Applications
      class Rack < Luban::Deployment::Application
        using Luban::CLI::CoreRefinements

        module Parameters
          extend Luban::Deployment::Parameters::Base  

          DefaultPort = 3000
          DefaultVirtualHost = 'localhost'
          DefaultWebServer = :thin

          parameter :port
          parameter :virtual_host
          parameter :web_server

          def power_by(server, **opts)
            web_server name: server, opts: opts
          end

          protected

          def set_default_rack_parameters
            set_default :port, DefaultPort
            set_default :virtual_host, DefaultVirtualHost
            set_default :web_server, name: DefaultWebServer, opts: {}
          end
        end

        include Parameters

        def default_templates_path
          @default_templates_path ||= base_templates_path(__FILE__).join(web_server[:name].to_s)
        end

        dispatch_task :phased_restart_process, to: :controller

        protected

        def set_default_application_parameters
          super
          linked_dirs.push('sockets')
          set_default_rack_parameters
        end

        def setup_control_tasks
          super

          task :phased_restart do
            desc "Phased restart process"
            action! :phased_restart_process
          end
        end
      end
    end
  end
end
