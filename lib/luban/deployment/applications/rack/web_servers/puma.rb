module Luban
  module Deployment
    module Applications
      class Rack
        module WebServers
          module Puma
            module Common
             def default_web_server_options
                @default_web_server_options ||= {
                  # Server options
                  address: "127.0.0.1",
                  port: port + 1,
                  socket: socket_file_path.to_s,
                  directory: release_path.to_s,
                  environment: stage,
                  rackup: release_path.join('config.ru').to_s,
                  # Daemon options
                  daemonize: !dockerized?,
                  pidfile: pid_file_path.to_s,
                  state_path: state_file_path.to_s,
                  redirect_stdout: log_file_path.to_s,
                  redirect_stderr: error_log_file_path.to_s,
                  redirect_append: true,
                  quiet: false,
                  tag: "#{env_name}:#{release_tag}",
                  # Cluster options
                  servers: 2,
                  threads: "1:1",
                  preload: false,
                  prune_bundler: true,
                  # Control app options
                  control_socket: control_socket_file_path.to_s,
                  control_opts: { auth_token: port.to_s }
                }
              end

              def tcp_socket?; @tcp_socket; end
              def unix_socket?; @unix_socket; end

              def state_file_path
                @state_file_path ||= pids_path.join(state_file_name)
              end

              def state_file_name
                @state_file_name ||= "#{current_web_server}.state"
              end

              def error_log_file_path
                @error_log_file_path ||= log_path.join("#{current_web_server}_error.log")
              end

              def control_socket_file_path
                @control_socket_file_path ||= sockets_path.join(control_socket_file_name)
              end

              def control_socket_file_name
                @control_socket_file_name ||= "#{current_web_server}ctl.sock"
              end

              def puma_command
                @puma_command ||= "pumactl -F #{control_file_path}"
              end

              def start_command
                @start_command ||= bundle_command("#{puma_command} start")
              end

              def stop_command
                @stop_command ||= bundle_command("#{puma_command} stop")
              end

              def process_pattern
                @process_pattern ||= "^puma .+\\[#{Regexp.escape(env_name)}:.*\\]"
              end

              def service_entry
                @serivce_entry ||= "#{super}.#{current_web_server}"
              end

              protected

              def init_docker_command
                docker_command ["bundle", "exec", "puma", "-C", control_file_path.to_s]
              end

              def set_web_server_options
                super.tap do |opts|
                  [:uri, :stdout_redirect, :workers, :threads, :control, :tuning].each do |param|
                    send("set_#{param}_options", opts)
                  end
                end
              end

              def set_uri_options(opts)
                socket = opts.delete(:socket)
                address = opts.delete(:address)
                port = opts.delete(:port)
                @unix_socket = !!opts.delete(:unix_socket)
                @tcp_socket = !@unix_socket
                if unix_socket?
                  opts[:bind] = "unix://#{socket}"
                else
                  opts[:bind] = "tcp://#{address}:#{port}"
                end
              end

              def set_stdout_redirect_options(opts)
                redirect_stdout = opts.delete(:redirect_stdout)
                redirect_stderr = opts.delete(:redirect_stderr)
                redirect_append = opts.delete(:redirect_append)
                opts[:stdout_redirect] = [ redirect_stdout, redirect_stderr, redirect_append ]
              end

              def set_workers_options(opts)
                if dockerized?
                  opts.delete(:servers)
                else
                  opts[:workers] = opts.delete(:servers)
                end
              end

              def set_threads_options(opts)
                if opts[:threads].is_a?(String)
                  opts[:threads] = opts[:threads].split(":").map(&:to_i)
                end
              end

              def set_control_options(opts)
                control_socket = opts.delete(:control_socket)
                control_socket = "unix://#{control_socket}" unless control_socket == 'auto'
                control_opts = opts.delete(:control_opts)
                opts[:activate_control_app] = [ control_socket, control_opts ]
              end

              def set_tuning_options(opts)
                if opts[:prune_bundler]
                  opts.delete(:preload)
                elsif opts[:preload]
                  opts.delete(:prune_bundler)
                  opts[:preload_app!] = opts.delete(:preload)
                else
                  opts.delete(:prune_bundler)
                  opts.delete(:preload)
                end
              end

              def parameterize(*args)
                args.map(&:inspect).join(", ")
              end
            end

            include Common

            def restart_command
              @restart_command ||= bundle_command("#{puma_command} restart")
            end

            def phased_restart_command
              @phased_restart_command ||= bundle_command("#{puma_command} phased-restart")
            end

            def publish_web_server
              install_puma_plugins if publish_app?
            end

            protected

            def install_puma_plugins
              src_plugin_path = Pathname.new(__FILE__).dirname.join('puma', 'plugin')
              dst_plugin_path = within(release_path) do
                                  Pathname.new(capture(bundle_executable, :show, 'puma'))
                                end.join('lib', 'puma', 'plugin')
              Pathname.glob(src_plugin_path.join('*.rb')).each do |src_plugin|
                dst_plugin = dst_plugin_path.join(src_plugin.basename)
                upload_by_template(file_to_upload: dst_plugin, template_file: src_plugin,
                                   auto_revision: true)
              end
            end
          end
        end
      end
    end
  end
end
