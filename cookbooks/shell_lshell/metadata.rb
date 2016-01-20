name             'shell_lshell'
maintainer       'RIYIC'
maintainer_email 'info@riyic.com'
license          'Apache 2.0'
description      'Installs/Configures shell_lshell'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.2'

#depends "python"
recipe "default",
    :description => "Installs Limited Shell ",
    :attributes => [/.+/]

# [GLOBAL OPTIONS]
##  log directory (default /var/log/lshell/ )
# logpath         : /var/log/lshell/
attribute "shell/lshell/globals/logpath",
    :display_name => "Log directory",
    :description => "Directory where store lshell logs (default /var/log/lshell/)",
    :type => "string",
    :advanced => false,
    :default => "/var/log/lshell/",
    :validations => {predefined: "unix_path"}

##  set log level to 0, 1, 2, 3 or 4  (0: no logs, 1: least verbose,
##                                                 4: log all commands)
# loglevel        : 2
attribute "shell/lshell/globals/loglevel",
    :display_name => "Log level",
    :description => "Set log level to 0, 1, 2, 3 or 4  (0: no logs, 1: least verbose, 4: log all commands",
    :type => "string",
    :default => "2",
    :advanced => false,
    :validations => {range: '0..4'}

##  configure log file name (default is %u i.e. username.log)
#logfilename     :  
#logfilename     : syslog
attribute "shell/lshell/globals/logfilename",
    :display_name => "Log Filename",
    :description => "Configure log filename (default is %u i.e. username.log). Others examples: %y%m%d-%u, syslog ...",
    :type => "string",
    :default => "%y%m%d-%u",
    :advanced => false,
    :validations => {predefined: "text"}

##  in case you are using syslog, you can choose your logname
#syslogname      : myapp
attribute "shell/lshell/globals/syslogname",
    :display_name => "Syslog name",
    :description => "In case you are using syslog, you can choose your logname",
    :type => "string",
    :default => nil,
    :advanced => false,
    :validations => {predefined: "text"}

#[DEFAULT OPTIONS]
attribute "shell/lshell/options/allowed",
    :display_name => "Lshell allowed commands",
    :description => "Allowed commands to this user",
    :type => "array",
    :default => ["ls","echo","cd"],
    :validations => {predefined: "unix_command"}

attribute "shell/lshell/options/forbidden",
    :display_name => "Forbidden characters or commands",
    :description => "List of characters or words not allowed in user session commands",
    :type => "array",
    :default => [';', '&', '|','`','>','<', '$(', '${'],
    :validations => {regex: /^.{1,15}$/}

attribute "shell/lshell/options/warning_counter",
    :display_name => "Warnings before logout (-1 to disable)",
    :description => "Number of warnings when user enters a forbidden value before getting exited from lshell, set to -1 to disable.",
    :type => "string",
    :default => "2",
    # :validations => {predefined: "signed_int"}
    :validations => {range: '-1..1000'}

attribute "shell/lshell/options/sudo",
    :display_name => "List of allowed commands in sudo",
    :description => "A list of allowed commands to use with sudo",
    :type => "array",
    :default => [],
    :validations => {predefined: "unix_command"}

attribute "shell/lshell/options/aliases",
    :display_name => "User command aliases",
    :description => "Command aliases list (similar to bash alias directive)",
    :type => "hash",
    :default => {'ll'=>'ls -l', 'vi'=>'vim'},
    :validations => {predefined: "unix_command"}

attribute "shell/lshell/options/path",
    :display_name => "User path restrictions",
    :description => "List of paths to restrict the user 'geographicaly'",
    :type => "array",
    :default => [],
    :validations => {predefined: "unix_path"}

##  introduction text to print (when entering lshell)
attribute "shell/lshell/options/intro",
    :display_name => "Intro",
    :description => "Introduction text to print when entering lshell",
    :type => "string",
    :default => "",
    :validations => {predefined: "multiline_text"}

##  add environment variables
#env_vars        : {'foo':1, 'bar':'helloworld'}
attribute "shell/lshell/options/env_vars",
    :display_name => "Environment variables",
    :description => "Environment variables added to the user session",
    :type => "hash",
    :default => {},
    :validations => {predefined: "text"}


##  a list of path; all executable files inside these path will be allowed 
#allowed_cmd_path: ['/home/bla/bin','/home/bla/stuff/libexec']
attribute "shell/lshell/options/allowed_cmd_path",
    :display_name => "List of paths with permited commands",
    :description => "List of paths where all executable file inside will be allowed",
    :type => "array",
    :default => [],
    :validations => {predefined: "unix_path"}

##  configure your promt using %u or %h (default: username)
attribute "shell/lshell/options/prompt",
    :display_name => "Prompt String",
    :description => "Prompt String Shell Variable",
    :type => "string",
    :default => "%u@%h",
    :validations => {predefined: "text"}


##  logging strictness. If set to 1, any unknown command is considered as 
##  forbidden, and user's warning counter is decreased. If set to 0, command is
##  considered as unknown, and user is only warned (i.e. *** unknown synthax)
#strict          : 1
attribute "shell/lshell/options/strict",
    :display_name => "Logging strictness",
    :description => "If set to 1, any unknown command is considered as forbidden, and user's warning counter is decreased." +
                    "If set to 0, command is considered as unknown, and user is only warned (i.e. *** unknown synthax)",
    :type => "string",
    :default => "1",
    :choice => ["0","1"]


##  history file maximum size 
#history_size     : 100
attribute "shell/lshell/options/history_size",
    :display_name => "History size",
    :description => "History file maximum size in lines",
    :type => "string",
    :default => "100",
    :validations => {range: '1..10000'}


##  set history file name (default is /home/%u/.lhistory)
#history_file     : "/home/%u/.lshell_history"
attribute "shell/lshell/options/history_file",
    :display_name => "History filename",
    :description => "Set history file name (default is /home/%u/.lhistory)",
    :type => "string",
    :default => "/home/%u/.lshell_history",
    :validations => {predefined: "unix_path"}

##  define the script to run at user login
#login_script     : "/path/to/myscript.sh"
attribute "shell/lshell/options/login_script",
    :display_name => "Script to run at user login",
    :description => "Define the script to run at user login (/path/to/myscript.sh)",
    :type => "string",
    :default => "",
    :validations => {predefined: "unix_path"}
