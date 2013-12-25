default["appserver"]["uwsgi"]["installation_path"] = "/opt/uwsgi"
default["appserver"]["uwsgi"]["run_options"] = {}
default["appserver"]["uwsgi"]["user"] = "www-data"
default["appserver"]["uwsgi"]["group"] = "www-data"
default["appserver"]["uwsgi"]["processes"] = node["cpu"]["total"]
default["appserver"]["uwsgi"]["threads"] = 0
default["appserver"]["uwsgi"]["psgi"]["coroae"] = 0



