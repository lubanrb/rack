module Luban
  module Deployment
    module Applications
      class Rack
        module WebServers
          module Thin
            module Common
              def default_web_server_options
                @default_web_server_options ||= {
                  # Server options
                  address: "0.0.0.0",
                  port: port + 1,
                  socket: socket_file_path.to_s,
                  chdir: release_path.to_s,
                  # Adapter options
                  environment: stage,
                  # Daemon options
                  daemonize: true,
                  log: log_file_path.to_s,
                  pid: pid_file_path.to_s,
                  tag: "#{env_name}:#{release_tag}",
                  # Cluster options
                  servers: 4,
                  wait: 30,
                  # Tuning options
                  timeout: 30,
                  max_conns: 1024,
                  max_persistent_conns: 100,
                  # Common options
                  trace: true
                }
              end

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

              protected

              def set_default_web_server_options
                super.tap do |opts|
                  if opts.delete(:unix_socket)
                    opts.delete(:address)
                    opts.delete(:port)
                  else
                    opts.delete(:socket)
                  end
                end
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
