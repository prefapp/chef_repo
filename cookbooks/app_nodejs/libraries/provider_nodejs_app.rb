class Chef
  class Provider
    class NodejsApp < Chef::Provider::RiyicApp

      def install_dependencies

        # 
        # dependicias do package.json
        # 
        command = 'npm install'

        bash "npm install" do
          user        new_resource.owner
          group       new_resource.group
          cwd         new_resource.target_path

          #environment env_hash
          code        command
        end


        # 
        # modulos que non estan no package.json
        #
        Array(new_resource.extra_modules).each do |p|
          (name,version) = p.split('#')

          command = "npm install -g #{name}"
          command << "@#{version}" if version

          execute command

        end
      end


      def configure_backend
        # para arrancar o servicio co runit dentro dun container
        dirname = new_resource.target_path.split('/').last

        node.set['container_service']["nodejs_#{dirname}"]['command'] = 
          "bash -c 'cd #{new_resource.target_path} && node #{new_resource.entry_point}'"
        
        service "nodejs_#{dirname}" do
          action :enable
        end 
      end


      def configure_frontend
      end
    end

  end

end
