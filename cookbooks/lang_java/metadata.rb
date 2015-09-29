name             "lang_java"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      " This cookbook installs a Java JDK/JRE. "
#long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

## Imprescindible en chef 11!!!
depends "lang_java"

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "install", description: "Installs Java"

attribute "lang/java/install_flavor",
    :display_name => 'Flavor of JVM',
    :description => 'Flavor of JVM you would like installed',
    :default => ['openjdk'],
    :choice => %w{openjdk oracle}
   
attribute "lang/java/jdk_version",
    :display_name => 'JDK version',
    :description => 'JDK version to install'
    
    
