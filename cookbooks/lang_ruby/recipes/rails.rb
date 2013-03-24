## instalamos ruby con rvm
include_recipe "lang_ruby::install"

## instalamos nodejs, necesario para servir rails
include_recipe "lang_nodejs::default"

## instalamos a gema de rails
gem_package "rails" do
    action :install

    if node["lang"]["ruby"]["rails"]["version"]
        unless node["lang"]["ruby"]["rails"]["version"].empty?
            version node["lang"]["ruby"]["rails"]["version"]
        end
    end

    provider Chef::Provider::Package::RVMRubygems
end


## instalamos todas as gemas que necesita unha app rails (ao facer rails new)
if node["lang"]["ruby"]["rails"]["full"]
    %w{
        sass
        sass-rails
        coffee-script
        coffee-script-source
        coffee-rails
        sqlite3
        execjs
        uglifier
        jquery-rails
    }.each do |gem|
        gem_package gem do
            action :install
            provider  Chef::Provider::Package::RVMRubygems
        end
    end
end
