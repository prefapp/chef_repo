include_recipe "build-essential::default"

# a url da version estable e un pouco diferente 
# a de descarga das releases

url = (node["dbs"]["redis"]["version"] == "stable")?
    node["dbs"]["redis"]["stable_url"]:
    node["dbs"]["redis"]["releases_url"]

download_dir = node["dbs"]["redis"]["download_dir"]
install_dir = node["dbs"]["redis"]["install_dir"]

# descargamos o tar co source
code_repo download_dir do
    provider Chef::Provider::CodeRepoRemoteArchive
    url url
    revision "redis-#{node["dbs"]["redis"]["version"]}.tar.gz"
end

# compilamos redis
bash 'compile_redis' do
    cwd  download_dir
    code <<-EOH
        make && make install
    EOH

    not_if do
        # evitamos compilar si existe o redis-server, 
        # e a version coincide co atributo "version"
        # e o flag de force_recompile esta a "no"
        File.exists?("#{install_dir}/bin/redis-server") and
        Mixlib::ShellOut.new("redis-server --version").run_command.stdout.
            match(/v=#{node["dbs"]["redis"]["version"]}/) and
        node["dbs"]["redis"]["force_recompile"] == "no"
    end

end

