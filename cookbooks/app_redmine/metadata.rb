name             "app_redmine"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
version          "0.0.1"

%w{debian ubuntu}.each do |os|
  supports os
end

depends "dbsystem_mysql"
depends "appserver_nginx"
depends "lang_ruby"
depends "build-essential"

recipe "default",
    description: "Install redmine with default options",
    attributes: [/.+/],
    dependencies: ["dbsystem_mysql::server", "appserver_nginx::with_passenger", "lang_ruby::install"]


## atributos
=begin
  "redmine": {
      "source": {
          "repository": "git://github.com/redmine/redmine.git",
          "reference": "2.2.3"
      },
      "domain" : "proxectos.riyic.com",
      "deploy_to" : "/home/redmine/deploy",
      "dir" : "/home/redmine/proxectos",
      "database": {
          "type": "mysql",
          "hostname": "localhost",
          "name" : "redmine",
          "username": "redmine",
          "password": "redmine"
      }
=end

attribute "redmine/domain",
    :display_name => 'Redmine domain',
    :description => 'Domain associated to redmine virtual host',
    :default => 'test.com',
    :advanced => false,
    :validations => {predefined: "domain"}

attribute "redmine/dir",
    :display_name => "Redmine root directory",
    :description => 'Document_root directory to where point virtualhost',
    :default => '/home/redmine/doc_root',
    :advanced => false,
    :validations => {predefined: "unix_path"}

attribute "redmine/database/name",
    :display_name => "Redmine database name",
    :description => 'Redmine database name (only to mysql or postgresql)',
    :default => 'redmine',
    :validations => {predefined: "mysql_dbname"},
    :advanced => false

attribute "redmine/database/username",
    :display_name => "Redmine database username",
    :description => 'Redmine database username (only to mysql or postgresql)',
    :default => 'redmine',
    :validations => {predefined: "mysql_dbuser"},
    :advanced => false

attribute "redmine/database/password",
    :display_name => "Redmine Database Password" ,
    :description => "Database password for this Redmine installation",
    :calculated => true,
    :validations => {predefined: "db_password"}

## advanced attributes
attribute "redmine/database/type",
    :display_name => "Redmine database type",
    :description => 'Redmine database type ( sqlite, mysql or postgresql)',
    :default => 'mysql',
    :choice => ["sqlite", "mysql"]

attribute "redmine/database/hostname",
    :display_name => "Redmine database hostname",
    :description => 'Redmine database hostname (only to mysql or postgresql)',
    :default => 'localhost',
    :validations => {predefined: "host"}

attribute "redmine/source/repository",
    :display_name => 'Redmine repository',
    :description => 'Redmine repository from which to download source code',
    :default => 'git://github.com/redmine/redmine.git',
    :validations => {predefined: "url"}

attribute "redmine/source/reference",
    :display_name => 'Redmine repository reference',
    :description => 'Redmine repository tag/branch/commit to download',
    :default => '2.2.3',
    :choice => ["2.2.3", "2.3-stable", "2.2-stable"]

attribute "redmine/deploy_to",
    :display_name => "Redmine deploy_to directory",
    :description => 'Directory to where deploy redmine source code',
    :default => '/home/redmine/deploy',
    :validations => {predefined: "unix_path"}







