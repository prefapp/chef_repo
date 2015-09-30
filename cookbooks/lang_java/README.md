java
=====

This cookbook installs OpenJDK/Oracle Java Runtime.


Usage
-----
### Examples

To install Oracle Java 7 
```
{
  "lang" : {
     "java" : {
       "install_flavor": "oracle",
       "jdk_version" : "7",
       "oracle" : {"accept_oracle_download_terms" : true}
   }
   },

  "run_list":[
	"recipe[lang_java::install]"
 ]
}

```

Requirements
-----

Chef 0.10.10+ and Ohai 6.10+ for `platform_family` use.

## Platform

* Ubuntu 14.04

Attributes
-----

See `attributes/default.rb` for default values.

* node.set["java"]["jdk_version"] = node['lang']['java']['jdk_version']
* node.set["java"]["install_flavor"] = node['lang']['java']['install_flavor']
* node.set['java']['oracle']['accept_oracle_download_terms'] = true


