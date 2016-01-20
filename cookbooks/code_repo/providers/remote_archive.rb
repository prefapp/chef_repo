action :pull do
    target_path = new_resource.target_path
    remote_url = new_resource.url
    remote_file = new_resource.revision
    owner = new_resource.owner
    group = new_resource.group

    purgar_target_path if new_resource.purge_target_path && new_resource.purge_target_path == 'yes'
    
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

    #
    # descargamos o paquete da app
    #
    tmp_file = "#{Chef::Config[:file_cache_path] || '/tmp'}/#{remote_file}"
    Chef::Log.info("Remote file pull #{remote_url}/#{remote_file}")

    remote_file tmp_file do
      source      "#{remote_url}/#{remote_file}"
      backup      false
      user        owner
      group       group
      action      :create_if_missing
    end


    # hai que descomprimilo
    # as novas versions de tar detectan o tipo de compresion
    #tmp_dir = "#{::File.dirname(tmp_file)}/tmpdir_#{Time.now.to_i}"

    bash 'unarchive_source' do
      cwd  ::File.dirname(tmp_file)
      #code <<-EOH
      #  mkdir #{tmp_dir}
      #  tar xf #{::File.basename(tmp_file)} -C #{tmp_dir}
      #  mv -f #{tmp_dir}/* #{target_path}
      #  rm -rf #{tmp_dir}
      #EOH
      code <<-EOH
        tar xC #{target_path} --strip-components=1 -f #{::File.basename(tmp_file)}
        chown -R #{owner}:#{group} #{target_path}
      EOH
    end

    new_resource.updated_by_last_action(true)

end

def purgar_target_path
    Chef::Log.info("Removing #{new_resource.target_path} to clone again repo")

    directory new_resource.target_path do
        recursive true
        action  :nothing
    end.run_action(:delete)
end

