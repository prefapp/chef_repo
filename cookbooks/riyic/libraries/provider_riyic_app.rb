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

            def env_hash
                {}
            end

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

                  depth             new_resource.repo_depth.to_i #forzamos int

                  purge_target_path new_resource.purge_target_path
                  notifies          :create, "directory[#{new_resource.target_path}/tmp]"
                end

                # en principio esto so e necesario nas apps rack
                directory "#{new_resource.target_path}/tmp" do
                    owner   new_resource.owner
                    group   new_resource.group
                    action  :nothing
                    only_if {new_resource.resource_name == 'rack_app'}

                end

            end


            def migrate_db

                return unless new_resource.migration_command

                bash "migration_#{new_resource.domain}" do
                    user        new_resource.owner
                    group       new_resource.group
                    cwd         new_resource.target_path
                    environment env_hash
                    code        new_resource.migration_command
                end

            end

            
            def run_postdeploy_script

                return unless new_resource.postdeploy_script

                bash "postdeploy-#{new_resource.postdeploy_script}" do
                    user        new_resource.owner
                    group       new_resource.group
                    cwd         new_resource.target_path
                    environment env_hash
                    code        %{bash #{new_resource.target_path}/#{new_resource.postdeploy_script}}

                    only_if {
                                !node["riyic"]["inside_container"] &&
                                ::File.exists?("#{new_resource.target_path}/#{new_resource.postdeploy_script}")
                    }
                end
            end
 
        end

    end

end
