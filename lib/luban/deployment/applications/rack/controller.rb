module Luban
  module Deployment
    module Applications
      class Rack
        class Controller < Luban::Deployment::Application::Controller
          using Luban::CLI::CoreRefinements

          include Luban::Deployment::Service::Controller::Cluster
          include Paths
          include Parameters

          def release_matched?
            release_tag =~ /^#{Regexp.escape(application_version)}/
          end

          def release_tag
            @release_tag ||= release_path.basename
          end

          def release_path
            @release_path ||= Pathname.new(readlink(app_path.join('app')))
          end

          def restart_process(phased: false)
            if process_stopped?
              update_result "Skipped! Already stopped. Please start #{application_full_name} normally.", status: :skipped
              return
            end

            unmonitor_process
            output = (phased ? phased_restart_process! : restart_process!) || 'OK'

            if check_until { process_started? }
              update_result "Restart #{service_full_name}: [OK] #{output}"
              monitor_process
            else
              remove_orphaned_pid_file
              update_result "Restart #{service_full_name}: [FAILED] #{output}",
                            status: :failed, level: :error
            end
          end

          def phased_restart_process
            restart_process(phased: true)
          end

          protected

          def init
            load_web_server
          end

          def load_web_server
            require_relative "web_servers/#{web_server}"
            server_module = WebServers.const_get(web_server.camelcase)
            singleton_class.send(:prepend, server_module)
          end

          def restart_process!
            capture("#{restart_command} 2>&1")
          end

          def phased_restart_process!
            capture("#{phased_restart_command} 2>&1")
          end
        end
      end
    end
  end
end
