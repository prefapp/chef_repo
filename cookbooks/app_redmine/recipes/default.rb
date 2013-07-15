#######################
# User
#######################

group "redmine"

user "redmine" do
  shell "/bin/bash"
  group "redmine"
end

directory "/home/redmine" do
  owner "redmine"
  group "redmine"
end

#######################
# Packages
#######################

include_recipe "build-essential"

## libpq5, libpq-dev necesarios para a gema pg (cliente postgresql)
%w{
  subversion
  imagemagick
  libmagick++-dev
  libsqlite3-dev
}.each do |pgk|
  package pgk
end

# instalamos gemas imprescindibles para o deploy de redmine
gem_package "bundler"
gem_package "rake"


#######################
# Redmine
#######################

case node['redmine']['database']['type']
  when "sqlite"
    include_recipe "app_redmine::_sqlite"
  when "mysql"
    include_recipe "app_redmine::_mysql"
  #when "postgresql"
end


deploy_revision "redmine" do
  repository node['redmine']['source']['repository']
  revision node['redmine']['source']['reference']
  deploy_to node['redmine']['deploy_to']

  user "redmine"
  group "redmine"
  environment "RAILS_ENV" => "production"

  before_migrate do
    %w{config log system pids}.each do |dir|
      directory "#{node['redmine']['deploy_to']}/shared/#{dir}" do
        owner "redmine"
        group "redmine"
        mode '0755'
        recursive true
      end
    end
    
    template "#{node['redmine']['deploy_to']}/shared/config/configuration.yml" do
      source "redmine/configuration.yml"
      owner "redmine"
      group "redmine"
      mode "0664"
    end

    template "#{node['redmine']['deploy_to']}/shared/config/database.yml" do
      source "redmine/database.yml"
      owner "redmine"
      group "redmine"
      variables ({
                :database_type => node['redmine']['database']['type'],
                :database_host => node['redmine']['database']['hostname'],
                :database_name => node['redmine']['database']['name'],
                :database_user => node['redmine']['database']['username'],
                :database_password => node['redmine']['database']['password']
                })
      mode "0664"
    end

    #template "#{release_path}/Gemfile.lock" do
    #  source "redmine/Gemfile.lock"
    #  owner "redmine"
    #  group "redmine"
    #  mode "0664"
    #end

  end

  # facemos manualmente a migracion, xa que desde bash non funciona ben
  # o bundle install facemolo tamen o final, porque tenhen que estar creados os links
  # debido a que o Gemfile, a partir da version 2.3 chequea o database.yml para ver que gema usar (mysql, mysql2...)
  before_restart do

    ## calculamos que partes do bundle que non necesitamos
    bundle_excluir = ['development', 'test']

    case node['redmine']['database']['type']
      when "sqlite"
        bundle_excluir += %w{postgresql mysql}

        file "#{release_path}/db/production.db" do
          owner "redmine"
          group "redmine"
          mode "0644"
        end
      when "mysql"
          bundle_excluir << 'postgresql'
          bundle_excluir << 'sqlite'
      when "postgresql"
          bundle_excluir << "mysql"
          bundle_excluir << "sqlite"

    end

    rvm_shell "bundle install" do    
        user        "redmine"
        group       "redmine"
        cwd         release_path
        ## fundamental meter o --path dentro do propio deploy, senon trata de instalar no home do usuario que lance o sudo
        code        %{bundle install --path=vendor/bundle --binstubs --without #{bundle_excluir.join(' ')}}
    end


    rvm_shell "rake generate_secret_token" do
        code %{bundle exec rake generate_secret_token}
        user "redmine"
        cwd release_path
        creates "#{node['redmine']['deploy_to']}/shared/config/initializers/secret_token.rb"
        #only_if { node['redmine']['branch'] =~ /^2./ }
        not_if { ::File.exists?("#{release_path}/db/schema.rb") }
    end

    rvm_shell "rake db:migrate" do    
        user        "redmine"
        group       "redmine"
        cwd         "#{node["redmine"]["deploy_to"]}/current"
        code        %{bundle exec rake db:migrate}
    end
  end


  # migrate true
  # migration_command 'bundle exec rake db:migrate'
  #migrate false

  action :deploy
  #action :force_deploy
  
  notifies :restart, "service[nginx]"
end

## aplicamos as migracions da bbdd fora do deploy revision
# porque non sabemos como meter esta chamada o rvm_shell dentro da migracion
# rvm_shell "rake db:migrate" do    
#         user        "redmine"
#         group       "redmine"
#         cwd         "#{node["redmine"]["deploy_to"]}/current"
#         code        %{bundle exec rake db:migrate}
# end

## finalmente creamos un link
link node["redmine"]["dir"] do
  to "#{node["redmine"]["deploy_to"]}/current"
end

## NON FUNCIONA!!!
# O MELLOR E CREAR UN LWRP XENERICO QUE PERMITA CONFIGURAR VHOSTS 
# MOLARIA QUE VALERA TANTO PARA NGINX, COMO PARA APACHE
# E TANTO PARA RUBY, COMO PARA PHP, PYTHON ...
#
#
=begin

## creamos o vhost
redmine_site = {"domain" => node["redmine"]["domain"],
		        "document_root" => node["redmine"]["dir"]}

node.run_state['appserver_rails_sites'] = 
    node.run_state['appserver_rails_sites'] | [redmine_site]
end
=end

redmine_site = {"domain" => node["redmine"]["domain"],
		        "document_root" => node["redmine"]["dir"]}

node.set['lang']['ruby']['rails']['sites'] = 
    node['lang']['ruby']['rails']['sites'] | [redmine_site]
#node.run_state['appserver_rails_sites'] = 
#    node.run_state['appserver_rails_sites'] | [redmine_site]

include_recipe "appserver_nginx::add_passenger_site"
