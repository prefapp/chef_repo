include_recipe "app_redmine::default"

app = node["app"]["redmine"]

rack_app app["domain"] do

    target_path        app['target_path']
    action             :deploy
    owner              app['user']
    group              app['group']
    timeout            "600"

    repo_url           app["repo_url"]
    repo_type          app["repo_type"]
    revision           app["revision"]
    purge_target_path  'yes'
    notifies          :restart, 'service[nginx]'

end
