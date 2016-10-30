module Luban
  module Deployment
    module Applications
      class Rack < Luban::Deployment::Application
        DefaultPort = 3000
        DefaultVirtualHost = 'localhost'
        DefaultWebServer = :puma

        parameter :port, default: DefaultPort
        parameter :virtual_host, default: DefaultVirtualHost
        parameter :web_server, default: ->{ { name: DefaultWebServer, opts: {} } }

        def power_by(server, **opts)
          web_server name: server, opts: opts
        end

        application_action "phased_restart_process", dispatch_to: :controller

        protected

        def include_default_templates_path
          default_templates_paths.unshift(base_templates_path(__FILE__).join(web_server[:name].to_s))
        end

        def setup_control_tasks
          super

          commands[:control].alter do
            task :phased_restart do
              desc "Phased restart process"
              action! :phased_restart_process
            end
          end
        end
      end
    end
  end
end
