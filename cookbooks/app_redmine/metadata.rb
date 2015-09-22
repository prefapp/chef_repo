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

attribute "app/redmine/alias",
    :display_name => 'Application domain alias',
    :description => 'Other domains associated to app virtual host',
    :default => [],
    :type => "array",
    :validations => {predefined: "domain"}


attribute "app/redmine/dbname",
    :display_name => "Redmine database name",
    :description => 'Redmine database name (only to mysql or postgresql)',
    :default => 'redmine',
    :validations => {predefined: "mysql_dbname"},
    :advanced => false

attribute "app/redmine/dbuser",
    :display_name => "Redmine database username",
    :description => 'Redmine database username (only to mysql or postgresql)',
    :default => 'redmine',
    :validations => {predefined: "mysql_dbuser"},
    :advanced => false

attribute "app/redmine/dbpassword",
    :display_name => "Redmine Database Password" ,
    :description => "Database password for this Redmine installation",
    :calculated => true,
    :validations => {predefined: "db_password"},
    :advanced => false
 

## advanced attributes
attribute "app/redmine/dbtype",
    :display_name => "Redmine database type",
    :description => 'Redmine database type ( sqlite, mysql or postgresql)',
    :default => 'mysql',
    :choice => ["sqlite", "mysql"]

attribute "app/redmine/dbhost",
    :display_name => "Redmine database hostname",
    :description => 'Redmine database hostname (only to mysql or postgresql)',
    :default => 'localhost',
    :validations => {predefined: "host"}

attribute "app/redmine/repo_url",
    :display_name => 'Redmine repository',
    :description => 'Redmine repository from which to download source code',
    :default => 'http://www.redmine.org/releases',
    :validations => {predefined: "url"}

attribute "app/redmine/revision",
    :display_name => 'Redmine version',
    :description => 'Redmine file version to download ',
    :default => 'redmine-3.1.0.tar.gz',
    :validations => {predefined: "revision"}

attribute "app/redmine/repo_type",
    :display_name => 'Repo Type',
    :description => 'Repository type from which to download application code',
    :default => 'remote_archive',

attribute "app/redmine/target_path",
    :display_name => "Redmine deploy_to directory",
    :description => 'Directory to where deploy redmine source code',
    :default => '/home/redmine/deploy',
    :validations => {predefined: "unix_path"}
