#require_relative 'provider_riyic_app.rb'

class Chef
  class Provider
    class FcgiApp < Chef::Provider::RiyicApp

      def install_dependencies

        # modulos que non estan no requirements
        Array(new_resource.extra_modules).each do |p|
          (name,version) = p.split('#')

          php_pear name do
            version version if(version)
            action :install
          end
        end
      end


      def configure_backend

        additional_config = {

          "php_value[max_execution_time]" => new_resource.timeout,

          "request_terminate_timeout" =>  new_resource.timeout.to_i,

          "clear_env" => 'no', # para ter acceso a todo o entorno

        }.merge(

          Hash[new_resource.php_ini_admin_values.map{|k,v| ["php_admin_value[#{k}]", v]}]

          ).merge(
            # mergeamos as variables de entorno, para que vaian dentro da config do pool

          Hash[new_resource.env_vars.map{|k,v| ["env[#{k}]", "'#{v}'"]}]
        )


        php_fpm_pool new_resource.domain do

          listen            '127.0.0.1:9000'
          user              new_resource.owner
          group             new_resource.group
          process_manager   'ondemand'
          additional_config additional_config

        end

        new_resource.internal_socket('127.0.0.1:9000')

      end


      def configure_frontend

        # configuramos o frontend
        nginx_fpm_site new_resource.domain do

          server_alias        new_resource.server_alias
          document_root       new_resource.document_root || new_resource.target_path

          static_files_path   "#{new_resource.target_path}/#{new_resource.static_files_path}" if new_resource.static_files_path
          fpm_socket          new_resource.internal_socket
          fastcgi_read_timeout  new_resource.timeout

          cookbook        new_resource.cookbook if new_resource.cookbook
          template        new_resource.frontend_template if new_resource.frontend_template

        end

      end
    end

  end

end
