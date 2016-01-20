name             "lang_java"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      " This cookbook installs a Java JDK/JRE. It defaults install OpenJDK but can also install Oracle. "
#long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

## Imprescindible en chef 11!!!
depends "java"

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "install", 
    description: "Installs Java JDK",
    attributes: [/.+/]


attribute "lang/java/install_flavor",
    :display_name => 'JDK flavor',
    :description => 'Flavor of JDK you would like to install',
    :default => 'openjdk',
    :choice => %w{openjdk oracle}
   
attribute "lang/java/jdk_version",
    :display_name => 'JDK version',
    :description => 'JDK version to install',
    :default => '8',
    :choice => %w{6 7 8}
  
attribute "lang/java/java_home",
    :display_name => 'JVM install dir',
    :description => 'JVM install dir',
    :validations =>  {:predefined => 'unix_path'}
    
    
