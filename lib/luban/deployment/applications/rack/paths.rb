module Luban
  module Deployment
    module Applications
      class Rack
        module Paths
          def log_file_name
            @log_file_name ||= "#{web_server[:name]}.log"
          end

          def pid_file_name
            @pid_file_name ||= "#{web_server[:name]}.pid"
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

          def socket_file_path
            @socket_file_path ||= sockets_path.join(socket_file_name)
          end

          def sockets_path
            @sockets_path ||= shared_path.join('sockets')
          end

          def socket_file_name
            @socket_file_name ||= "#{web_server[:name]}.sock"
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
