# dependencias para poder usar o lwrp
include_recipe "lang_php::default"
include_recipe "appserver_nginx::default"
include_recipe "appserver_fpm::default"
include_recipe "code_repo::default"
