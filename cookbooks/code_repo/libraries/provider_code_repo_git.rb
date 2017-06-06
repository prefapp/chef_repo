require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class CodeRepoGit < Chef::Provider::LWRPBase

      action :pull do

        target_path = new_resource.target_path
        repo_url = new_resource.url
        revision = new_resource.revision
        owner = new_resource.owner
        group = new_resource.group

        homedir = (owner == 'root')? '/root': "/home/#{owner}"

        # Validamos que target_path sexa distinto do home do usuario
        if target_path == homedir
          raise Chef::Exceptions::UnsupportedAction, "Target path can't be equal to user owner homedir (#{homedir})"
        end


        # preparamos o entorno
        group group do
        end.run_action(:create)

        user owner do
          group group
          home homedir
        end.run_action(:create)


        directory target_path do
          owner owner
          group group
          recursive true
        end

        keyfile = "/tmp/sshkey"
        ssh_wrapper = "/tmp/ssh_wrapper.sh"

        # seteamos os parametros necesarios para descargar desde un repo ssh con key
        if new_resource.credential

          Chef::Log.info "Creating keyfile #{keyfile} and ssh wrapper #{ssh_wrapper}"
          file keyfile do
            backup false
            owner owner
            group group
            mode "0600"
            content new_resource.credential
          end.run_action(:create)

          template ssh_wrapper do
            cookbook "code_repo"
            source "ssh_wrapper.sh.erb"
            owner owner
            group group
            mode 00700
            variables(
              :keyfile => keyfile
            )
          end.run_action(:create)

          ruby_block "before pull" do
            block do
              ENV["GIT_SSH"] = ssh_wrapper
            end
          end.run_action(:run)
        end

        # purgamos o target_path si e necesario
        purgar_target_path if new_resource.purge_target_path && new_resource.purge_target_path == 'yes'

        #
        # descargamos o codigo da app, ou actualizamos o existente
        #
        Chef::Log.info("Git pull from #{repo_url} to #{target_path}")
        git target_path do
          repository  repo_url
          reference   revision
          action      :sync
          user        owner
          group       group
          timeout     1200
          depth       new_resource.depth if(new_resource.depth && new_resource.depth > 0)
        end

        if new_resource.credential
          Chef::Log.info("Cleaning keyfile and environment")
          # borramos as keys ssh do repo e a variable de entorno
          ruby_block "After pull" do
            block do
              ::File.delete(keyfile)
              ::File.delete(ssh_wrapper)
              ENV.delete("GIT_SSH")
            end
          end
        end

        new_resource.updated_by_last_action(true)

      end

      def purgar_target_path

        #
        # vamos a evaluar si hai que purgar
        # para eso instanciamos o git provider e usamos un metodo que ten
        # para determinar se hai que descargar unha nova revision
        #
        recurso = git new_resource.target_path do
          repository  new_resource.url
          reference   new_resource.revision
          action      :nothing
        end

        provider = Chef::Provider::Git.new(recurso, nil)
        provider.load_current_resource

        unless provider.current_revision_matches_target_revision?
          Chef::Log.info("Removing #{new_resource.target_path} to clone again repo")

          directory new_resource.target_path do
            recursive true
            action  :nothing
          end.run_action(:delete)
        end
      end
    end
  end
end
