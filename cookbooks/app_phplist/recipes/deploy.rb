include_recipe "app_phplist::default"


node["app"]["phplist"]["installations"].each do |app|

        args = {}

        %W{
            domain
            target_path
            user
            group
            repo_url
            repo_type
            revision
            db_name
            db_user
            db_host
            db_password
            smtp_user
            smtp_password
            smtp_server
            smtp_server_secure
            test_mode
            bounce_address
            bounce_mailbox_host
            bounce_mailbox_user
            bounce_mailbox_password
            bounce_unsubscribe_threshold
            default_system_language
            upload_images_dir

        }.each do |attribute|
    
            args[attribute] = app[attribute] || node["app"]["phplist"]["default_#{attribute}"]

        end

    # instalamos a aplicacion e configuramos os servicios necesarios
    fcgi_app args["domain"] do

        target_path        args['target_path']
        document_root      "#{args["target_path"]}/public_html"
        server_alias       args['alias'] if args['alias']
        action             :deploy
        owner              args['user']
        group              args['group']
        timeout            "600"
    
        repo_url           args["repo_url"]
        repo_type          args["repo_type"]
        revision           args["revision"]
        purge_target_path  'yes'
        extra_packages     ["php5-imap"]

        notifies          :run, 'execute[php5enmod]'
        notifies          :restart, 'service[nginx]'
        notifies          :restart, 'service[php5-fpm]'
    
    end

    # en debian/ubuntu hai que activar o modulo de imap
    execute "php5enmod" do
        command "php5enmod imap"
        action :nothing
    end

    # creamos o directorio de upload de imagenes dentro de public_html
    # e damoslle permiso de escritura para o webserver
    if args['upload_images_dir']

        directory "#{args['target_path']}/public_html/#{args['upload_images_dir']}" do
            mode    "777"
            action  :create
            owner   args['user'] 
            group   args['group']
        end

    end

    
    # creamos o ficheiro de configuracion
    template "#{args['target_path']}/public_html/lists/config/config.php" do

        source      'config.php.erb'
        cookbook    "app_phplist" 
        user        args["user"]
        group       args["group"]
        variables   ({:app => args})
                    
    end

end
