default["appserver"]["uwsgi"]["url"] = "http://projects.unbit.it/downloads/"

# To get last lts version, if lts package no works:
# http://uwsgi-docs.readthedocs.io/en/latest/Download.html
default["appserver"]["uwsgi"]["version"] = "lts"

default["appserver"]["uwsgi"]["installation_path"] = "/opt/uwsgi"
default["appserver"]["uwsgi"]["run_options"] = {}
default["appserver"]["uwsgi"]["user"] = "uwsgi"
default["appserver"]["uwsgi"]["group"] = "users"
default["appserver"]["uwsgi"]["processes"] = node["cpu"]["total"]
default["appserver"]["uwsgi"]["threads"] = 0
default["appserver"]["uwsgi"]["socket"] = 'unix:///tmp/uwsgi.sock'
default["appserver"]["uwsgi"]["psgi"]["coroae"] = 0



