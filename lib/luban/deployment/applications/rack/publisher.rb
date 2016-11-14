module Luban
  module Deployment
    module Applications
      class Rack
        class Publisher < Luban::Deployment::Application::Publisher
          include WebServer

          def after_publish
            super
            publish_web_server
          end

          protected

          def init
            super
            linked_dirs.push('sockets')
            linked_files.push('puma.rb', 'thin.yml')
          end
        end
      end
    end
  end
end




          