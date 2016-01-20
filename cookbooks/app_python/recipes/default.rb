# dependencias para poder usar o lwrp
include_recipe "lang_python::default"
include_recipe "appserver_nginx::package"
include_recipe "appserver_uwsgi::python"
include_recipe "code_repo::default"
