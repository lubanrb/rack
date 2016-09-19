module Luban
  module Deployment
    module Applications
      class Rack
        module WebServers
          module Thin
            module Cluster
              def pid_file_pattern
                @pid_file_pattern ||= "#{current_web_server}.*.pid"
              end

              def pid_files_path
                pids_path.join(pid_file_pattern)
              end

              def pid_files
                capture(:ls, "-A #{pid_files_path} 2>/dev/null").split.map do |f|
                  Pathname.new(f)
                end
              end

              def pids
                pid_files.collect { |pid_file| capture(:cat, "#{pid_file} 2>/dev/null") }
              end

              def pid; pids; end

              def pid_file_exists?
                # Any pid file is NOT zero size
                pid_files.any? { |pid_file| file?(pid_file, "-s") }
              end

              def remove_orphaned_pid_file
                rm(pid_files_path) if pid_file_orphaned?
              end

              def monitor_command
                @monitor_command ||= "#{monitor_executable} monitor -g #{service_entry}"
              end

              def unmonitor_command
                @unmonitor_command ||= "#{monitor_executable} unmonitor -g #{service_entry}"
              end
            end

            module Paths
              def pid_file_path(n = nil)
                if n.nil?
                  @pid_file_path ||= pids_path.join(pid_file_name)
                else
                  pids_path.join(pid_file_name(n))
                end
              end

              def pid_file_name(n = nil)
                if n.nil?
                  @pid_file_name ||= "#{current_web_server}.pid"
                else
                  "#{current_web_server}.#{n + web_server[:opts][:port].to_i}.pid"
                end
              end

              def control_file_extname
                @control_file_extname ||= "yml"
              end

              def socket_file_path(n = nil)
                if n.nil?
                  @socket_file_path ||= sockets_path.join(socket_file_name)
                else
                  sockets_path.join(socket_file_name(n))
                end
              end

              def socket_file_name(n = nil)
                if n.nil?
                  @socket_file_name ||= "#{current_web_server}.sock"
                else
                  "#{current_web_server}.#{n}.sock"
                end
              end
            end

            module Common
              include Cluster
              include Paths

              def default_web_server_options
                @default_web_server_options ||= {
                  # Server options
                  address: "0.0.0.0",
                  port: port + 1,
                  socket: socket_file_path.to_s,
                  chdir: release_path.to_s,
                  environment: stage,
                  # Daemon options
                  daemonize: true,
                  log: log_file_path.to_s,
                  pid: pid_file_path.to_s,
                  tag: "#{env_name}:#{release_tag}",
                  # Cluster options
                  servers: 2,
                  wait: 30,
                  # Tuning options
                  timeout: 30,
                  max_conns: 1024,
                  max_persistent_conns: 100,
                  # Common options
                  trace: true
                }
              end

              def tcp_socket?; @tcp_socket; end
              def unix_socket?; @unix_socket; end

              def thin_command
                @thin_command ||= "thin -C #{control_file_path}"
              end

              def start_command
                @start_command ||= bundle_command("#{thin_command} start")
              end

              def stop_command
                @stop_command ||= bundle_command("#{thin_command} stop")
              end

              def process_pattern
                @process_pattern ||= "^thin server.+\\[#{Regexp.escape(env_name)}:.*\\]"
              end

              protected

              def set_web_server_options
                super.tap do |opts|
                  @unix_socket = !!opts.delete(:unix_socket)
                  @tcp_socket = !@unix_socket
                  if unix_socket?
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
              @restart_command ||= bundle_command("#{thin_command} restart")
            end

            def phased_restart_command
              @phased_restart_command ||= bundle_command("#{thin_command} restart --onebyone")
            end
          end
        end
      end
    end
  end
end
