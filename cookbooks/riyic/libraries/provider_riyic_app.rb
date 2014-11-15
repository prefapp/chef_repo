require 'chef/mixin/shell_out'
require 'chef/provider/lwrp_base'

include Chef::Mixin::ShellOut

class Chef
    class Provider
        class RiyicApp < Chef::Provider::LWRPBase

            use_inline_resources if defined?(:use_inline_resources)

            #def load_current_resource
            #end

            action :deploy do

                #instalar paquetes de sistema necesarios
                install_extra_packages

                #descargar o codigo da app
                download_code

                #instalar dependencias
                install_dependencies

                # aplicar migracions á base de datos si procede
                migrate_db

                # postdeploy_script
                run_postdeploy_script

                # configuramos o servidor de aplicacion
                configure_backend
            
                # configurar nginx
                configure_frontend

            end


            protected

            def install_extra_packages
                new_resource.extra_packages.each do |pkg|

                    package pkg do 
                        action :nothing
                    end.run_action(:install)

                end
            end

            def download_code

                # descargamos o codigo da app
                # en funcion do tipo de repositorio
                #include_recipe "code_repo::default"
                
                case new_resource.repo_type
                when "git" 
                  provider = Chef::Provider::CodeRepoGit
                
                when "subversion"
                  provider = Chef::Provider::CodeRepoSvn
                
                when "remote_archive"
                  provider = Chef::Provider::CodeRepoRemoteArchive
                else
                  provider = Chef::Provider::CodeRepoGit
                end
                
                code_repo new_resource.target_path do
                  provider          provider
                  action            "pull"
                  owner             new_resource.owner
                  group             new_resource.group
                  url               new_resource.repo_url
                  revision          new_resource.revision
                  credential        new_resource.credential
                  depth             1
                  purge_target_path new_resource.purge_target_path
                end

            end
            
            def run_postdeploy_script
            end

        end

    end

end
