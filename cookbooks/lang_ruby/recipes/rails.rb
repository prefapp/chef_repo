## instalamos ruby con rvm
include_recipe "lang_ruby::install"

## instalamos nodejs, necesario para servir rails
include_recipe "lang_nodejs::default"

## instalamos a gema de rails
gem_package "rails" do
    action :install
    version node["lang"]["ruby"]["rails"]["version"]
    provider Chef::Provider::Package::RVMRubygems
end


