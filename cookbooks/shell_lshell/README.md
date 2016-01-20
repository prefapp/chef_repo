shell_lshell
====================
Cookbook to install Limited Shell (https://github.com/ghantoos/lshell)

Requirements
------------
lshell needs python support. 

Attributes
----------

### Global config

- **logpath:** directory where store logs (default /var/log/lshell/ )
`default["shell"]["lshell"]["globals"]["logpath"] = "/var/log/lshell/"`

- **loglevel:** set log level to 0, 1, 2, 3 or 4 (0: no logs, 1: least verbose,4: log all commands)
`default["shell"]["lshell"]["globals"]["loglevel"] = 2`

- **logfilename:** configure log file name (default is %u i.e. username.log)  
\# logfilename     : %y%m%d-%u  
\# logfilename     : syslog  
`default["shell"]["lshell"]["globals"]["logfilename"] = nil`

- **syslogname:**  in case you are using syslog, you can choose your logname  
\#syslogname      : myapp  
`default["shell"]["lshell"]["globals"]["syslogname"] = nil`


### user, group and default options

- **allowed:**  a list of the allowed commands or 'all' to allow all commands in user's PATH
`default["shell"]["lshell"]["options"]["allowed"] = ['ls','echo','cd','ll','la'] `

- **forbidden:**  a list of forbidden character or commands  
`default["shell"]["lshell"]["options"]["forbidden"] = [';', '&', '|','`','>','<', '$(', '${'] `

- **sudo_commands:**  a list of allowed command to use with sudo(8)  
`default["shell"]["lshell"]["options"]["sudo_commands"] = []`

- **warning_counter:** number of warnings when user enters a forbidden value before getting exited from lshell, set to **-1** to disable.  
`default["shell"]["lshell"]["options"]["warning_counter"] = 2 `

- **aliases:**  command aliases list (similar to bash’s alias directive)  
`default["shell"]["lshell"]["options"]["aliases"]        = {'ll'=>'ls -l', 'vi'=>'vim', 'la'=>'ls -la'} `

- **intro:** introduction text to print (when entering lshell)  
`default["shell"]["lshell"]["options"]["intro"]  = nil `

- **prompt:**  configure your promt using %u or %h (default: username)  
`default["shell"]["lshell"]["options"]["prompt"]  = nil`

- **prompt_short:** set sort prompt current directory update (default: 0)  
`default["shell"]["lshell"]["options"]["prompt_short"]  = nil`

- **timer:**  a value in seconds for the session timer  
`default["shell"]["lshell"]["options"]["timer"]  = nil`

- **path:** list of path to restrict the user "geographicaly"
\#path            : ['/home/bla/','/etc']  
`default["shell"]["lshell"]["options"]["path"]  = nil`

- **home_path:**  set the home folder of your user. If not specified the home_path is set to the $HOME environment variable
\#home_path       : '/home/bla/'  
`default["shell"]["lshell"]["options"]["home_path"]  = nil`

- **env_path:**  update the environment variable $PATH of the user  
\#env_path        : ':/usr/local/bin:/usr/sbin'  
`default["shell"]["lshell"]["options"]["env_path"]  = nil`

- **allowed_cmd_path:** a list of path; all executable files inside these path will be allowed   
\#allowed_cmd_path: ['/home/bla/bin','/home/bla/stuff/libexec']  
`default["shell"]["lshell"]["options"]["allowed_cmd_path"]  = nil`

- **env_vars:**  add environment variables  
\#env_vars        : {'foo':1, 'bar':'helloworld'}   
`default["shell"]["lshell"]["options"]["env_vars"]  = nil`

- **scp:** allow or forbid the use of scp (set to 1 or 0)  
\#scp             : 1  
`default["shell"]["lshell"]["options"]["scp"]  = nil`

- **scp_upload:** forbid scp upload  
\#scp_upload       : 0  
`default["shell"]["lshell"]["options"]["scp_upload"]  = nil`

- **scp_download:** forbid scp download  
\#scp_download     : 0  
`default["shell"]["lshell"]["options"]["scp_download"]  = nil`

- **sftp:**  allow of forbid the use of sftp (set to 1 or 0)  
\#sftp            : 1  
`default["shell"]["lshell"]["options"]["sftp"]  = nil`

- **overssh:**  list of command allowed to execute over ssh (e.g. rsync, rdiff-backup, etc.)  
\#overssh         : ['ls', 'rsync']  
`default["shell"]["lshell"]["options"]["overssh"]  = nil`

- **strict:** logging strictness. If set to 1, any unknown command is considered as forbidden, and user's warning counter is decreased. If set to 0, command is
 considered as unknown, and user is only warned (i.e. *** unknown synthax)  
\#strict          : 1
`default["shell"]["lshell"]["options"]["strict"]  = nil`

- **scpforce:**  force files sent through scp to a specific directory  
\#scpforce        : '/home/bla/uploads/'  
`default["shell"]["lshell"]["options"]["scpforce"]  = nil`

- **history_size:**   history file maximum size   
\#history_size     : 100  
`default["shell"]["lshell"]["options"]["history_size"]  = nil`

- **history_file:**  set history file name (default is /home/%u/.lhistory)  
\#history_file     : "/home/%u/.lshell_history"  
`default["shell"]["lshell"]["options"]["history_file"]  = nil`

- **login_script:**  define the script to run at user login  
\#login_script     : "/path/to/myscript.sh"  
`default["shell"]["lshell"]["options"]["login_script"]  = nil`

Usage
-----
Add shell_lshell::default recipe to your node's `run_list`.

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: riyic.com
