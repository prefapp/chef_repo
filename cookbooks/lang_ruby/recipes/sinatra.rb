## instalamos ruby con rvm (de todas formas vai a ser unha dependencia da receta, asiqu a web xa se vai a encargar de metela no runlist)
include_recipe "lang_ruby::install"

## instalamos a gema de sinatra
gem_package "sinatra" do
    action :install

    if node["lang"]["ruby"]["sinatra"]["version"]
        unless node["lang"]["ruby"]["sinatra"]["version"].empty?
            version node["lang"]["ruby"]["sinatra"]["version"]
        end
    end

    provider Chef::Provider::Package::RVMRubygems
end


