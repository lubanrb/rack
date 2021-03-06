module Luban
  module Deployment
    module Applications
      class Rack
        class Controller < Luban::Deployment::Application::Controller
          include Paths
          include WebServer

          def restart_process(phased: false)
            if process_stopped?
              update_result "Skipped! Already stopped. Please start #{application_full_name} normally.", status: :skipped
              return
            end

            unmonitor_process if monitorable?
            output = (phased ? phased_restart_process! : restart_process!) || 'OK'

            if check_until { process_started? }
              update_result "Restart #{service_full_name}: [OK] #{output}"
              monitor_process if monitorable?
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
            super
            set_web_server_options
          end

          def restart_process!; capture(restart_command); end
          def phased_restart_process!; capture(phased_restart_command); end
        end
      end
    end
  end
end
