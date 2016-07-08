module Luban
  module Deployment
    module Applications
      class Rack
        module WebServers
          module Thin
            module Common
              def control_file_extname
                @control_file_extname ||= "yml"
              end

              def thin_command
                @thin_command ||= "#{bundle_executable} exec thin -C #{control_file_path}"
              end

              def start_command
                @start_command ||= "cd #{release_path}; #{thin_command} start"
              end

              def stop_command
                @stop_command ||= "cd #{release_path}; #{thin_command} stop"
              end

              def process_pattern
                @process_pattern ||= "^thin server.+\\[#{Regexp.escape(env_name)}:#{Regexp.escape(application_version)}-[0-9a-f]+\\]"
              end
            end

            include Common

            def restart_command
              @restart_command ||= "cd #{release_path}; #{thin_command} restart"
            end

            def phased_restart_command
              @phased_restart_command ||= "cd #{release_path}; #{thin_command} restart --onebyone"
            end
          end
        end
      end
    end
  end
end
