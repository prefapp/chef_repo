name             'system_user'
maintainer       'RIYIC'
maintainer_email 'info@riyic.com'
license          'Apache 2.0'
description      'Installs/Configures system_user'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "shell_lshell"

# "system":{
#   "users": {
#     "default":[
#       {
#       "username": "user1",
#       "password": "user1"
#       }
#     ],
#     "lshell": [
#       {
#         "username": "alumno2",
#         "password": "alumno2",
#         "group": "users",
#         "shell_options": {
#           "intro" : "probando nova intro",
#           "path"  : ["/home/alumno"]
#         }
#       }
#     ]
#   }
# },


recipe "default",
    :description => "Add a system user with default shell (bash)",
    :attributes => [/\/default\//],
    :stackable => true

recipe "with_lshell",
    :description => "Add a system user with Limited shell (lshell)",
    :attributes => [/\/lshell\//],
    :dependencies => ["shell_lshell"],
    :stackable => true

attribute "system/users/default/@/username",
    :display_name => 'System username',
    :description => ' User name to add to the system',
    :advanced => false,
    :required => true,
    :validations => {predefined: "username"}


attribute "system/users/default/@/password",
    :display_name => 'User password',
    :description => 'Password to the system user',
    :advanced => false,
    :required => true,
    :validations => {predefined: "password"}

attribute "system/users/default/@/group",
    :display_name => 'User Group',
    :description => 'Group to join the user, default: users',
    :advanced => false,
    :default => "users",
    :validations => {predefined: "username"}

attribute "system/users/lshell/@/username",
    :display_name => 'System username',
    :description => ' User name to add to the system',
    :advanced => false,
    :required => true,
    :validations => {predefined: "username"}


attribute "system/users/lshell/@/password",
    :display_name => 'User password',
    :description => 'Password to the system user',
    :advanced => false,
    :required => true,
    :validations => {predefined: "password"}

attribute "system/users/lshell/@/group",
    :display_name => 'User Group',
    :description => 'Group to join the user, default: users',
    :advanced => false,
    :default => "users",
    :validations => {predefined: "username"}


attribute "system/users/lshell/@/shell_options/allowed",
    :display_name => "Lshell allowed commands",
    :description => "Allowed commands to this user",
    :type => "array",
    :default => ["ls","echo","cd"],
    :validations => {predefined: "unix_command"}

attribute "system/users/lshell/@/shell_options/aliases",
    :display_name => "User command aliases",
    :description => "Command aliases list (similar to bash alias directive)",
    :type => "hash",
    :default => {'ll'=>'ls -l', 'vi'=>'vim'},
    :validations => {predefined: "unix_command"}

attribute "system/users/lshell/@/shell_options/path",
    :display_name => "User path restrictions",
    :description => "List of paths to restrict the user 'geographicaly'",
    :type => "array",
    :default => [],
    :validations => {predefined: "unix_path"}

