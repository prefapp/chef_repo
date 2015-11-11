name             "appserver_apache"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Installs/Configures apache2"
version          "0.0.1"


depends "apache2"
depends "build-essential"
depends "lang_ruby"

%w{debian ubuntu}.each do |os|
  supports os
end

# recetas
recipe  "default", 
    description: "Main Apache configuration",
    attributes: [/^(?!.*\/(passenger)\/).*$/],
    dependencies: []

recipe  "mod_ssl", 
    description: "Apache module 'ssl' with config file, adds port 443 to listen_ports",
    dependencies: ["appserver_apache"]

recipe  "mod_status", 
    description: "Apache module 'status' with config file",
    attributes: ['appserver/apache/ext_status'],
    dependencies: ["appserver_apache"]

recipe  "with_passenger", 
    description: "Install passenger for apache server",
    attributes: [/\/passenger\//],
    dependencies: ["lang_ruby::install"]

#recipe "mod_auth_openids",
#    description: "Apache module auth_openids",
#    attributes: ["appserver/apache/allowed_openids"]
    

#recipe "logrotate",
#    description: "Rotate apache logs. Requires logrotate cookbook",
#    dependencies: ["logrotate:default"]


### 
# ATRIBUTOS
### 

# atributos principales
attribute "appserver/apache/listen_ports",
  :display_name => "Apache Listen Ports",
  :description => "Ports that Apache should listen on",
  :advanced => false,
  :type => "array",
  :default => [ "80" ],
  :validations => {predefined: "tcp_port"}


attribute "appserver/apache/timeout",
  :display_name => "Apache Timeout",
  :description => "Connection timeout value",
  :advanced => false,
  :default => "300",
  :validations => {range: '1..5000'}

attribute "appserver/apache/default_modules",
  :display_name => "Apache Default Modules",
  :description => "Default modules to enable via recipes",
  :advanced => false,
  :type => "array",
  # non funciona dende chef 11.12, porque ahora se chequea cada elemento do :choice sexa do tipo :type especificado
  #:choice => [ 
  #    "alias", "apreq2", "auth_basic", "auth_digest", "authn_file", "authnz_ldap", 
  #    "auth_openid", "authz_default", "authz_groupfile", "authz_host", "authz_user", "autoindex", 
  #    "cgi", "dav_fs", "dav", "dav_svn", "deflate", "dir", "env", "expires", "fcgid", "headers", "ldap", 
  #    "log_config", "logio", "mime", "negotiation", "perl", "php5", "proxy_ajp", "proxy_balancer",
  #    "proxy_connect", "proxy_http", "proxy", "python", "rewrite", "setenvif", "ssl", "status", "wsgi", 
  #    "xsendfile" ],
  :validations => {predefined: "apache_module" },
  :default => %w(status alias auth_basic authn_file authz_default 
      authz_groupfile authz_host authz_user autoindex dir env mime 
      negotiation setenvif)

## para a receta de mod_openid
#attribute "appserver/apache/allowed_openids",
#  :display_name => "Apache Allowed OpenIDs",
#  :description => "Array of OpenIDs allowed to authenticate",
#  :type => 'array',
#  :advanced => false,
#  :default => [],
#  :validations => {predefined: "openid"}

## para a receta de mod_status
attribute "appserver/apache/ext_status",
  :display_name => "Apache Extended Status Enabled",
  :description => "Enable Extended Status for mod_status",
  :choice => ["true", "false"], 
  :default => "false"


#atributos avanzados
## O ServerAdmin a usar no default vhost
attribute "appserver/apache/contact",
  :display_name => "Apache Contact",
  :description => "Default site server admin email address",
  :default => "webmaster@example.com",
  :validations => {predefined: "email"}

# este teoricamente e dependente do so, pero pode ser interesante 
# que o setee o cliente
attribute "appserver/apache/default_site_enabled",
  :display_name => "Apache Default Site Enabled",
  :description => "Enable Default Site for Apache",
  :choice => ["true", "false"],
  :default => "false"

## Non o vexo nos atributos de apache2 ¿?¿?¿
#attribute "appserver/apache/server_name",
#  :display_name => "Apache Server Name",
#  :description => "Default Server Name for Apache",
#  :default => "localhost",
#  :validations => {regex: /\A[\w+\.\-]\z/}

# keepalive
attribute "appserver/apache/keepalive",
  :display_name => "Apache Keepalive",
  :description => "HTTP persistent connections",
  :choice => ["On","Off"],
  :default => "On"

attribute "appserver/apache/keepaliverequests",
  :display_name => "Apache Max Keepalive Requests",
  :description => "Max requests allowed on a persistent connection",
  :default => "100",
  :validations => {range: '1..3000'}

attribute "appserver/apache/keepalivetimeout",
  :display_name => "Apache Keepalive Timeout",
  :description => "Time to wait for requests on persistent connection",
  :default => "5",
  :validations => {range: '1..300'}

#servertokens
attribute "appserver/apache/servertokens",
  :display_name => "Apache Server Tokens",
  :description => "Server response header",
  :default => "ProductOnly",
  :choice => ["Major","Minor","Minimal","ProductOnly","OS","Full"]

attribute "appserver/apache/serversignature",
  :display_name => "Apache Server Signature",
  :description => "Configure footer on server-generated documents",
  :default => "On",
  :choice => ["On","Off"]

attribute "appserver/apache/traceenable",
  :display_name => "Apache Trace Enable",
  :description => "Determine behavior of TRACE requests",
  :default => "On",
  :choice => ["On","Off"]


## worker ou prefork
attribute "appserver/apache/mpm",
  :display_name => "Apache Single/Multi Threaded",
  :description => "Select worker for multithreaded or prefork for single threaded",
  :choice => [ "prefork", "worker" ],
  :default => "prefork"

attribute "appserver/apache/prefork/startservers",
  :display_name => "Apache Prefork MPM StartServers",
  :description => "Number of MPM servers to start",
  :default => "16",
  :validations => {range: '1..100'}

attribute "appserver/apache/prefork/minspareservers",
  :display_name => "Apache Prefork MPM MinSpareServers",
  :description => "Minimum number of spare server processes",
  :default => "16",
  :validations => {range: '1..100'}

attribute "appserver/apache/prefork/maxspareservers",
  :display_name => "Apache Prefork MPM MaxSpareServers",
  :description => "Maximum number of spare server processes",
  :default => "32",
  :validations => {range: '1..100'}

attribute "appserver/apache/prefork/serverlimit",
  :display_name => "Apache Prefork MPM ServerLimit",
  :description => "Upper limit on configurable server processes",
  :default => "400",
  :validations => {range: '1..10000'}
# No manual recomendan ponhelo igual a Maxclients
# o valor maximo e 20000

attribute "appserver/apache/prefork/maxclients",
  :display_name => "Apache Prefork MPM MaxClients",
  :description => "Maximum number of simultaneous connections",
  :default => "400",
  :validations => {range: '1..10000'}

attribute "appserver/apache/prefork/maxrequestsperchild",
  :display_name => "Apache Prefork MPM MaxRequestsPerChild",
  :description => "Maximum number of request a child process will handle",
  :default => "10000",
  :validations => {range: '0..100000'}

#attribute "appserver/apache/worker",
#  :display_name => "Apache Worker",
#  :description => "Hash of Apache prefork tuning attributes.",
#  :advanced => true,
#  :type => "hash"

attribute "appserver/apache/worker/startservers",
  :display_name => "Apache Worker MPM StartServers",
  :description => "Initial number of server processes to start",
  :default => "4",
  :validations => {range: '1..1000'}

attribute "appserver/apache/worker/maxclients",
  :display_name => "Apache Worker MPM MaxClients",
  :description => "Maximum number of simultaneous connections",
  :default => "1024",
  :validations => {range: '1..10000'}

attribute "appserver/apache/worker/minsparethreads",
  :display_name => "Apache Worker MPM MinSpareThreads",
  :description => "Minimum number of spare worker threads",
  :default => "64",
  :validations => {range: '1..10000'}

attribute "appserver/apache/worker/maxsparethreads",
  :display_name => "Apache Worker MPM MaxSpareThreads",
  :description => "Maximum number of spare worker threads",
  :default => "192",
  :validations => {range: '1..10000'}

attribute "appserver/apache/worker/threadsperchild",
  :display_name => "Apache Worker MPM ThreadsPerChild",
  :description => "Constant number of worker threads in each server process",
  :default => "64",
  :validations => {range: '1..10000'}

attribute "appserver/apache/worker/maxrequestsperchild",
  :display_name => "Apache Worker MPM MaxRequestsPerChild",
  :description => "Maximum number of request a child process will handle",
  :default => "0",
  :validations => {range: '0..10000'}


## atributos dependentes do so, os calcula o attributes/default.rb de apache2
# en funcion da plataforma
#attribute "appserver/apache/package",
#  :display_name => "Apache Package",
#  :description => "Name of Apache package",
#  :default => "apache2",
#  :validations => {regex: /\A[\w+\.\-]\z/}
#
#attribute "appserver/apache/dir",
#  :display_name => "Apache Directory",
#  :description => "Location for Apache configuration",
#  :default => "/etc/apache2",
#  :validations => {regex: /\A[\w+\/\-]\z/}
#
#
#attribute "appserver/apache/log_dir",
#  :display_name => "Apache Log Directory",
#  :description => "Location for Apache logs",
#  :default => "/var/log/apache2",
#  :validations => {regex: /\A[\w+\/\-]\z/}
#
#attribute "appserver/apache/error_log",
#  :display_name => "Apache Error Log File",
#  :description => "Filename for Apache error log",
#  :default => "error.log",
#  :validations => {regex: /\A[\w+\.\-]\z/}
#
#attribute "appserver/apache/user",
#  :display_name => "Apache User",
#  :description => "User Apache runs as",
#  :default => "www-data",
#  :validations => {regex: /\A[\w+\-]\z/}
#
#  
#attribute "appserver/apache/group",
#  :display_name => "Apache Group",
#  :description => "Group Apache runs as",
#  :default => "www-data",
#  :validations => {regex: /\A[\w+\-]\z/}
#
#attribute "appserver/apache/binary",
#  :display_name => "Apache Binary",
#  :description => "Apache server daemon program",
#  :default => "/usr/sbin/apache2",
#  :validations => {regex: /\A[\w+\/\-]\z/}
#
#attribute "appserver/apache/icondir",
#  :display_name => "Apache Icondir",
#  :description => "Directory location for icons",
#  :default => "/usr/share/apache2/icons",
#  :validations => {regex: /\A[\w+\/\-]\z/}
#
#attribute "appserver/apache/cache_dir",
#  :display_name => "Apache Cache Dir",
#  :description => "Directory location for cache",
#  :default => "/var/cache/apache2",
#  :validations => {regex: /\A[\w+\/\-]\z/}
#  
#attribute "appserver/apache/pid_file",
#  :display_name => "Apache PID File",
#  :description => "Location for PID File Apache process",
#  :default => "/var/run/apache2.pid",
#  :validations => {regex: /\A[\w+\.\/\-]\z/}
#  
#attribute "appserver/apache/lib_dir",
#  :display_name => "Apache Libs Directory",
#  :description => "Location for Apache Libraries",
#  :default => "/usr/lib/apache2",
#  :validations => {regex: /\A[\w+\/\-]\z/}

## parametros do passenger
attribute "appserver/apache/passenger/version",
    :display_name => 'Passenger version',
    :description => 'Passenger version to compile and install',
    :default => '3.0.19',
    :validations => {predefined: "version"}


attribute "appserver/apache/passenger/max_pool_size",
    :display_name => 'Max pool size',
    :description => 'Maximum pool size',
    :default => '6',
    :validations => {regex: /^\d+$/}

