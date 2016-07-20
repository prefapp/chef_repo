require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class CodeRepoGitBundle < Chef::Provider::LWRPBase
      action :pull do
          bundle = new_resource.bundle
          owner = new_resource.owner
          group = new_resource.group

          # preparamos o entorno
          group group

          user owner do
            group group
          end

          # seteamos os parametros necesarios para descargar desde un repo ssh con key
          if new_resource.credential
            keyfile = "/tmp/sshkey"
            ssh_wrapper = "/tmp/ssh_wrapper.sh"

            Chef::Log.info "Creating keyfile #{keyfile} and ssh wrapper #{ssh_wrapper}"
            file keyfile do
                backup false
                owner owner
                group group
                mode "0600"
                content new_resource.credential
            end

            template ssh_wrapper do
                cookbook "code_repo"
                source "ssh_wrapper.sh.erb"
                owner owner
                group group
                mode 00700
                variables(
                  :keyfile => keyfile
                )
            end

            ruby_block "before pull" do
              block do
                ENV["GIT_SSH"] = ssh_wrapper
              end
            end
          end

          # array de repos a descargar
          bundle.each do |b|
            (target_path, repo_url, revision) = b.split("|")

            directory target_path do
              owner owner
              group group
              recursive true
            end

            Chef::Log.info("Git pull #{target_path}")
            git target_path do
              repository  repo_url
              reference   revision
              action      :sync
              user        owner
              group       group
            end
          end

          # borramos as keys ssh do repo e a variable de entorno
          if new_resource.credential
            Chef::Log.info("Cleaning keyfile and environment")
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
    end
  end
end
