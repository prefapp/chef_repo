name             "lang_ruby"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to install ruby language and gems through rvm"
#long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

## Imprescindible en chef 11!!!
depends "rvm"
depends "lang_nodejs"

# estos 2 son dependencias por culpa da receta deploy_rails_app
# o mellor as recetas de deploy de apps deberian ir nun cookbook propio
# depends "dbs_mysql"
# depends "appserver_nginx"

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "default",
    description: "empty",
    attributes: []

recipe "install",
    description: "Installs ruby with rvm",
    attributes: [/^(?!.*\/(app|rails)\/).*$/],
    dependencies: []

recipe "rails",
    description: "Installs rails framework",
    attributes: [/rails/],
    dependencies: ["lang_ruby::install", "lang_nodejs"]

#recipe "sinatra",
#    description: "Installs sinatra framework",
#    attributes: [/sinatra/],
#    dependencies: ["install"]

recipe "install_gems",
    description: "Install globally the gems list provided",
    attributes: ['lang/ruby/gems'],
    dependencies: ["lang_ruby::install"]

## Atributos
attribute "lang/ruby/version",
    :display_name => 'Ruby version',
    :description => 'Ruby version to install',
    :default => 'ruby-1.9.3',
    :choice => %w{ruby-1.8.6 ruby-1.8.7 ruby-1.9.1 ruby-1.9.2 ruby-1.9.3 ruby-2.0.0 system},
    :advanced => false


attribute "lang/ruby/gems",
    :display_name => 'Gems to install',
    :description => 'Gems to install globally',
    :type => "array",
    :default => ['bundler'],
    # podese especificar a version con <nome>#<version>
    :validations => {predefined: "ruby_gem" }

attribute "lang/ruby/gemset",
    :display_name => "Gemset name",
    :description => "Gemset name where install gems, default 'nil'",
    :default => nil,
    :validations => {regex: /\A\w*\z/}

attribute "lang/ruby/rails/version",
    :display_name => "Rails version",
    :description => "Rails version to install, default 'nil' to install last version",
    :default => nil,
    :validations => {predefined: "version"}

attribute "lang/ruby/rails/full",
    :display_name => "Full rails installation",
    :description => "Install other gems usually needed by rails apps",
    :default => "false",
    :choice => ["true", "false"] 

#attribute "lang/ruby/rvm/user",
#    :display_name => 'Rvm user',
#    :description => 'User to install ruby with',
#    :default => ''




