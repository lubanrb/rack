module Luban
  module Deployment
    module Applications
      class Rack
        class Publisher < Luban::Deployment::Application::Publisher
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




          