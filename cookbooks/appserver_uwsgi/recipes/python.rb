# librerias de desarrollo de python (debian, ubuntu)
package "python-dev"

node.run_state['uwsgi_plugins'] =
    node.run_state['uwsgi_plugins'] | ['python']

node.run_state['uwsgi_builds'] =
    node.run_state['uwsgi_builds'] | ['base']