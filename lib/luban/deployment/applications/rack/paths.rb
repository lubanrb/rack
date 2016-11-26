module Luban
  module Deployment
    module Applications
      class Rack
        module Paths
          def log_file_name
            @log_file_name ||= "#{current_web_server}.log"
          end

          def pid_file_name
            @pid_file_name ||= "#{current_web_server}.pid"
          end

          def control_file_dir; @control_file_dir ||= "config"; end

          def control_file_name
            @control_file_name ||= "#{current_web_server}.#{control_file_extname}"
          end

          def control_file_extname
            @control_file_extname ||= "rb"
          end

          def socket_file_path
            @socket_file_path ||= sockets_path.join(socket_file_name)
          end

          def sockets_path
            @sockets_path ||= shared_path.join('sockets')
          end

          def socket_file_name
            @socket_file_name ||= "#{current_web_server}.sock"
          end

          def public_files_path
            @public_files_path ||= release_path.join('public')
          end
        end
      end
    end
  end
end
