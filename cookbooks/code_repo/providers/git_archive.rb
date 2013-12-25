action :pull do
    target_path = new_resource.target_path
    repo_url = new_resource.url
    revision = new_resource.revision
    files = new_resource.files
    owner = new_resource.owner
    group = new_resource.group


    # preparamos o entorno
    group group

    user owner do
      group group
    end

    directory target_path do
      owner owner
      group group
      recursive true
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

    # descargamos os ficheiros indicados con git-archive
    Chef::Log.info("Git pull #{target_path}")

    #git archive --format=tar --remote tools@chorima.es:/opt/git/tatemono.git HEAD tatemono.js | tar xf -
    bash "git_archive" do
      cwd     target_path
      user    owner
      group   group
      code    <<-EOH
        git archive --format=tar --remote #{repo_url} #{revision} #{files.join(' ')} | tar xf -
      EOH
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
