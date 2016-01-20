# instalamos os paquetes necesarios
include_recipe "build-essential::default"

case node['platform_family']
when 'debian'
    packages = %w{
        libtool 
        autoconf
        automake
        uuid-dev}
end

packages.each do |p|

    package p do
        action :install
    end

end

download_dir = node["mq"]["zeromq"]["download_dir"]
install_dir = node["mq"]["zeromq"]["install_dir"]

# descargamos o tar co source
code_repo download_dir do
    provider Chef::Provider::CodeRepoRemoteArchive
    url node["mq"]["zeromq"]["download_url"]
    revision "zeromq-#{node["mq"]["zeromq"]["version"]}.tar.gz"
end

# compilamos zeromq
bash 'compile_zeromq' do
    cwd  download_dir
    code <<-EOH
        ./configure
        make && make install
        ldconfig
    EOH

    only_if do
        # recompilamos solo si non existe a libreria na ruta de instalacion
        # ou a version non coincide ca instalada
        # ou si o flag de recompile esta a "yes"
        (not ::File::exists?("#{install_dir}/lib/libzmq.so")
        ) or 
        (not Mixlib::ShellOut.new(
            "cd #{install_dir} && bash #{download_dir}/version.sh"
            ).run_command.stdout.include?(node["mq"]["zeromq"]["version"])
        ) or 
        (node["mq"]["zeromq"]["force_recompile"] == "yes")
    end

end





