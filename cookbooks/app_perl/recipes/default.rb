# dependencias para poder usar o LWRP
include_recipe "lang_perl::default"
include_recipe "appserver_nginx::default"
include_recipe "appserver_uwsgi::psgi"
include_recipe "code_repo::default"
