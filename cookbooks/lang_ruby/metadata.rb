maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to install ruby language and gems through rvm"
#long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

## Imprescindible en chef 11!!!
depends "rvm"

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "default",
    description: "empty",
    attributes: []

recipe "install",
    description: "Installs ruby with the provided options",
    attributes: [/.+/],
    dependencies: []

recipe "install_gems",
    description: "Install globally the gems list provided",
    attributes: ['lang/ruby/gems'],
    dependencies: ["install"]

## Atributos
attribute "lang/ruby/version",
    :display_name => 'Ruby version',
    :description => 'Ruby version to install',
    :default => 'ruby-1.9.3',
    :choice => %w{ruby-1.8.6 ruby-1.8.7 ruby-1.9.1 ruby-1.9.2 ruby-1.9.3 system},
    :validations => {regex: /^\w+\d+\.\d+\.\d+/},
    :advanced => false


attribute "lang/ruby/gems",
    :display_name => 'Gems to install',
    :description => 'Gems to install globally',
    :default => ['bundler'],
    # podese especificar a version con <nome>#<version>
    :validations => {regex: /\A\w+\#\.+\z/}

attribute "lang/ruby/rvm/user",
    :display_name => 'Rvm user',
    :description => 'User to install ruby with',
    :default => ''
