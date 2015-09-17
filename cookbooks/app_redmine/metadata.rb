name             "app_redmine"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
version          "0.0.1"

depends "dbs_mysql"
depends "app_ruby"

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "deploy:",
    description: "Install redmine with default options",
    attributes: [/.+/]


attribute "app/redmine/domain",
    :display_name => 'Redmine domain',
    :description => 'Domain associated to redmine virtual host',
    :default => 'test.com',
    :advanced => false,
    :validations => {predefined: "domain"}

attribute "app/redmine/dir",
    :display_name => "Redmine root directory",
    :description => 'Document_root directory to where point virtualhost',
    :default => '/home/redmine/doc_root',
    :advanced => false,
    :validations => {predefined: "unix_path"}

attribute "app/redmine/database/name",
    :display_name => "Redmine database name",
    :description => 'Redmine database name (only to mysql or postgresql)',
    :default => 'redmine',
    :validations => {predefined: "mysql_dbname"},
    :advanced => false

attribute "app/redmine/database/username",
    :display_name => "Redmine database username",
    :description => 'Redmine database username (only to mysql or postgresql)',
    :default => 'redmine',
    :validations => {predefined: "mysql_dbuser"},
    :advanced => false

attribute "app/redmine/database/password",
    :display_name => "Redmine Database Password" ,
    :description => "Database password for this Redmine installation",
    :calculated => true,
    :validations => {predefined: "db_password"},
    :advanced => false
 

## advanced attributes
attribute "app/redmine/database/type",
    :display_name => "Redmine database type",
    :description => 'Redmine database type ( sqlite, mysql or postgresql)',
    :default => 'mysql',
    :choice => ["sqlite", "mysql"]

attribute "app/redmine/database/hostname",
    :display_name => "Redmine database hostname",
    :description => 'Redmine database hostname (only to mysql or postgresql)',
    :default => 'localhost',
    :validations => {predefined: "host"}

attribute "app/redmine/source/repository",
    :display_name => 'Redmine repository',
    :description => 'Redmine repository from which to download source code',
    :default => 'git://github.com/redmine/redmine.git',
    :validations => {predefined: "url"}

attribute "app/redmine/source/reference",
    :display_name => 'Redmine repository reference',
    :description => 'Redmine repository tag/branch/commit to download',
    :default => '2.3-stable',
    :validations => {predefined: "revision"}
    #:choice => ["2.3.1", "2.2.4","2.3-stable", "2.2-stable"]

attribute "app/redmine/deploy_to",
    :display_name => "Redmine deploy_to directory",
    :description => 'Directory to where deploy redmine source code',
    :default => '/home/redmine/deploy',
    :validations => {predefined: "unix_path"}
