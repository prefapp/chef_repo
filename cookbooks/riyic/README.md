Service provided patch inside containers
========================================

To see if the execution is running inside a container, the code checks the value of an automatic attribute (obtained by ohai from the kernel)

```ruby
node['virtualization']['system'] =~ /^lxc|docker$/
```

Then, inside containers, the chef **service** provider is monkey patched and forced to runit_service. The service then must have some attributes configured from recipes:


To control the service with runit, the node must have some of the following parameters:

- **node['container_service'][@service_name]['command']** : Mandatory. Command to exec the service, must be defined. It is going to be wrapped in this run script:

```
#!/bin/sh
exec 2>&1
exec #{@command} 2>&1
```


- **node['container_service'][@service_name]['log_type']:**  (:stdout|:file). Default to :file

- **node['container_service'][@service_name]['run_script_content']:** In case that just a command is not enought, you must provide
all the runit init script. 

Collection of popular init scripts:
http://smarden.org/runit1/runscripts.html

- **node['container_service'][@service_name]['check_script_content']**   
If default runit check process status is not enought, you can provide a script to make the job   
For example mysql:

```
#!/bin/sh
test -e /var/run/mysqld/mysqld.sock
```

- **node['container_service'][@service_name]['disable']** (true|false) . By default **false**, must be set a true to configure the service in runit but disabled


To avoid a service to be configured with runit provider, the **service name** must start with '**no_runit**'.
