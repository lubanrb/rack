module Luban
  module Deployment
    module Applications
      class Rack < Luban::Deployment::Application
        using Luban::CLI::CoreRefinements

        module Parameters
          extend Luban::Deployment::Parameters::Base

          DefaultWebServer = :thin

          parameter :web_server

          def power_by(server, **opts)
            web_server name: server, opts: opts
          end

          protected

          def set_default_rack_parameters
            set_default :web_server, name: DefaultWebServer, opts: {}
          end
        end

        include Parameters

        def default_templates_path
          @default_templates_path ||= super(__FILE__).join(web_server[:name].to_s)
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
