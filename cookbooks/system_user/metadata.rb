name             'system_user'
maintainer       'RIYIC'
maintainer_email 'info@riyic.com'
license          'Apache 2.0'
description      'Manage a system user with a associated shell'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.1'

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
    :description => "Add a system user with no shell",
    :attributes => [/\/default\//],
    :stackable => true

recipe "with_bash",
    :description => "Add a user to the system with bash shell",
    :attributes => [/\/bash\//],
    :stackable => true

recipe "with_ssh_keys",
    :description => "Add a ssh key to the user",
    :attributes => [/\/ssh_keys\//],
    :stackable => true

recipe "with_lshell",
    :description => "Add a user to the system with Limited shell (lshell)",
    :attributes => [/\/lshell\//],
    :dependencies => ["shell_lshell"],
    :stackable => true

#
## ATRIBUTES
#

attribute "system/users/default/@/username",
    :display_name => 'System username',
    :description => ' User name to add to the system without shell',
    :advanced => false,
    :default => "user",
    :required => true,
    :validations => {predefined: "username"}

attribute "system/users/bash/@/username",
    :display_name => 'System username',
    :description => ' User name to add to the system with bash shell',
    :advanced => false,
    :default => "user",
    :required => true,
    :validations => {predefined: "username"}


attribute "system/users/bash/@/password",
    :display_name => 'User password',
    :description => 'Password to the system user',
    :advanced => false,
    :calculated => false,
    :required => false,
    :validations => {predefined: "password"}

#attribute "system/users/bash/@/ssh_keys",
#    :display_name => 'User ssh authorized keys',
#    :description => 'Ssh authorized keys for the user',
#    :advanced => false,
#    :calculated => false,
#    :required => false,
#    :type => 'array',
#    :default => [],
#    :validations => {predefined: "ssh_public_key"}

attribute "system/users/bash/@/ssh_keys",
    :display_name => 'User ssh authorized keys',
    :description => 'Ssh authorized key for the users',
    :advanced => false,
    :calculated => false,
    :required => false,
    :default => '',
#    :type => 'array',   # arreglo para probas
#    :default => [],
    :validations => {predefined: "ssh_public_key"}

attribute "system/users/bash/@/group",
    :display_name => 'User Group',
    :description => 'Group to join the user, default: users',
    :advanced => false,
    :default => "users",
    :validations => {predefined: "username"}

# lshell
attribute "system/users/lshell/@/username",
    :display_name => 'System username',
    :description => ' User name to add to the system with lshell shell',
    :advanced => false,
    :required => true,
    :default => 'user',
    :validations => {predefined: "username"}


attribute "system/users/lshell/@/password",
    :display_name => 'User password',
    :description => 'Password to the system user',
    :advanced => false,
    :required => false,
    :calculated => true,
    :validations => {predefined: "password"}

attribute "system/users/lshell/@/group",
    :display_name => 'User Group',
    :description => 'Group to join the user, default: users',
    :advanced => false,
    :default => "users",
    :validations => {predefined: "username"}

attribute "system/users/lshell/@/ssh_keys",
    :display_name => 'User ssh authorized keys',
    :description => 'Ssh authorized keys for the user',
    :advanced => false,
    :calculated => false,
    :required => false,
    :type => 'array',
    :default => [],
    :validations => {predefined: "ssh_public_key"}


attribute "system/users/lshell/@/shell_options/allowed",
    :display_name => "Lshell allowed commands",
    :description => "Allowed commands to this user",
    :type => "array",
    :default => nil,
    :validations => {predefined: "unix_command"}

attribute "system/users/lshell/@/shell_options/forbidden",
    :display_name => "Forbidden characters or commands",
    :description => "List of characters or words not allowed in user session commands",
    :type => "array",
    :default => nil,
    :validations => {regex: /^.{1,15}$/}

attribute "system/users/lshell/@/shell_options/warning_counter",
    :display_name => "Warnings before logout (-1 to disable)",
    :description => "Number of warnings when user enters a forbidden value before getting exited from lshell, set to -1 to disable.",
    :type => "string",
    :default => nil,
    # :validations => {predefined: "signed_int"}
    :validations => {range: '-1..1000'}

attribute "system/users/lshell/@/shell_options/sudo",
    :display_name => "List of allowed commands in sudo",
    :description => "A list of allowed commands to use with sudo",
    :type => "array",
    :default => nil,
    :validations => {predefined: "unix_command"}

attribute "system/users/lshell/@/shell_options/aliases",
    :display_name => "User command aliases",
    :description => "Command aliases list (similar to bash alias directive)",
    :type => "hash",
    :default => nil,
    :validations => {predefined: "unix_command"}

attribute "system/users/lshell/@/shell_options/path",
    :display_name => "User path restrictions",
    :description => "List of paths to restrict the user 'geographicaly'",
    :type => "array",
    :default => nil,
    :validations => {predefined: "unix_path"}

##  introduction text to print (when entering lshell)
attribute "system/users/lshell/@/shell_options/intro",
    :display_name => "Intro",
    :description => "Introduction text to print when entering lshell",
    :type => "string",
    :default => nil,
    :validations => {predefined: "multiline_text"}

##  add environment variables
#env_vars        : {'foo':1, 'bar':'helloworld'}
attribute "system/users/lshell/@/shell_options/env_vars",
    :display_name => "Environment variables",
    :description => "Environment variables added to the user session",
    :type => "hash",
    :default => nil,
    :validations => {predefined: "text"}


##  a list of path; all executable files inside these path will be allowed 
#allowed_cmd_path: ['/home/bla/bin','/home/bla/stuff/libexec']
attribute "system/users/lshell/@/shell_options/allowed_cmd_path",
    :display_name => "List of paths with permited commands",
    :description => "List of paths where all executable file inside will be allowed",
    :type => "array",
    :default => nil,
    :validations => {predefined: "unix_path"}

##  configure your promt using %u or %h (default: username)
attribute "system/users/lshell/@/shell_options/prompt",
    :display_name => "Prompt String",
    :description => "Prompt String Shell Variable",
    :type => "string",
    :default => nil,
    :validations => {predefined: "text"}


##  logging strictness. If set to 1, any unknown command is considered as 
##  forbidden, and user's warning counter is decreased. If set to 0, command is
##  considered as unknown, and user is only warned (i.e. *** unknown synthax)
#strict          : 1
attribute "system/users/lshell/@/shell_options/strict",
    :display_name => "Logging strictness",
    :description => "If set to 1, any unknown command is considered as forbidden, and user's warning counter is decreased." +
                    "If set to 0, command is considered as unknown, and user is only warned (i.e. *** unknown synthax)",
    :type => "string",
    :default => nil,
    :choice => ["0","1"]


##  history file maximum size 
#history_size     : 100
attribute "system/users/lshell/@/shell_options/history_size",
    :display_name => "History size",
    :description => "History file maximum size in lines",
    :type => "string",
    :default => nil,
    :validations => {range: '1..10000'}


##  set history file name (default is /home/%u/.lhistory)
#history_file     : "/home/%u/.lshell_history"
attribute "system/users/lshell/@/shell_options/history_file",
    :display_name => "History filename",
    :description => "Set history file name (default is /home/%u/.lhistory)",
    :type => "string",
    :default => nil,
    :validations => {predefined: "unix_path"}

##  define the script to run at user login
#login_script     : "/path/to/myscript.sh"
attribute "system/users/lshell/@/shell_options/login_script",
    :display_name => "Script to run at user login",
    :description => "Define the script to run at user login (/path/to/myscript.sh)",
    :type => "string",
    :default => nil,
    :validations => {predefined: "unix_path"}

