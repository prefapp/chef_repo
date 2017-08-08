class Chef
  class Provider
    class NodejsApp < Chef::Provider::RiyicApp

      def install_dependencies

        # 
        # instalar dependencias dende package.json
        # 
        command = 'npm install'

        user = new_resource.owner

        env_hash = {
          'HOME'=> (user == 'root')? '/root' : "/home/#{user}" ,
          'USER'=> user
        }

        bash "npm install" do
          user        new_resource.owner
          group       new_resource.group
          cwd         new_resource.target_path

          environment env_hash
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

        environment = new_resource.env_vars.map{|k,v| "#{k}=#{v}"}.join(' ')

        node.set['container_service']["nodejs_#{dirname}"]['run_script_content'] = <<"EOF"
#!/bin/sh
exec 2>&1

cd #{new_resource.target_path} && \
#{environment} exec node #{new_resource.entry_point} 2>&1

EOF
        
        service "nodejs_#{dirname}" do
          action :enable
        end 
      end


      # de momento para as apps node non hai frontend!
      #
      def configure_frontend
      end
    end

  end

end
