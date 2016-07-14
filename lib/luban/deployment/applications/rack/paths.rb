module Luban
  module Deployment
    module Applications
      class Rack
        module Paths
          def log_file_name
            @log_file_name ||= "#{web_server[:name]}.log"
          end

          def pid_file_path(n = nil)
            if n.nil?
              @pid_file_path ||= pids_path.join(pid_file_name)
            else
              pids_path.join(pid_file_name(n))
            end
          end

          def pid_file_name(n = nil)
            if n.nil?
              @pid_file_name ||= "#{web_server[:name]}.pid"
            else
              "#{web_server[:name]}.#{n + web_server[:opts][:port].to_i}.pid"
            end
          end

          def pid_file_pattern
            @pid_file_pattern ||= "#{web_server[:name]}.*.pid"
          end

          def control_file_name
            @control_file_name ||= "#{web_server[:name]}.#{control_file_extname}"
          end

          def control_file_extname
            @control_file_extname ||= "rb"
          end

          def logrotate_file_name
            @logrotate_file_name ||= "#{web_server[:name]}.logrotate"
          end

          def sockets_path
            @sockets_path ||= shared_path.join('sockets')
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
              @socket_file_name ||= "#{web_server[:name]}.sock"
            else
              "#{web_server[:name]}.#{n}.sock"
            end

          end

          def ruby_bin_path
            @ruby_bin_path ||= package_bin_path('ruby')
          end

          def bundle_executable
            @bundle_executable ||= ruby_bin_path.join('bundle')
          end
        end
      end
    end
  end
end
