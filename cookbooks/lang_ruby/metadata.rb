name             "lang_ruby"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to install ruby language and gems"
#long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.4"

## Imprescindible en chef 11!!!
depends "rvm"
depends "lang_nodejs"
depends "brightbox-ruby"

# estos 2 son dependencias por culpa da receta deploy_rails_app
# o mellor as recetas de deploy de apps deberian ir nun cookbook propio
# depends "dbs_mysql"
# depends "appserver_nginx"

%w{debian ubuntu}.each do |os|
  supports os
end


recipe "install",
    description: "Installs ruby",
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
    :default => 'ruby-2.1',
    :choice => %w{ruby-2.2 ruby-2.1 ruby-2.0.0 ruby-1.9.3},
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




