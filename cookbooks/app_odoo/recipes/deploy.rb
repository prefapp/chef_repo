include_recipe "app_odoo::default"


extra_packages = %w{
    libfreetype6
    libxrender1
    fonts-dejavu-core
    ttf-bitstream-vera
    fonts-freefont-ttf
    gsfonts-x11
    gsfonts
    xfonts-utils
    libfontenc1
    libxfont1
    x11-common
    xfonts-encodings
    libxml2-dev
    libxslt-dev
    libsasl2-dev
    libldap2-dev
    libssl-dev
    libjpeg-dev
    fontconfig-config
    fontconfig

}

node["app"]["odoo"]["installations"].each do |app|

    wsgi_app app["domain"] do

        target_path       app["target_path"]
        environment       app["environment"]
        entry_point       "openerp-wsgi.py"
        action            :deploy
        owner             app["user"] || node["app"]["odoo"]["default_user"]
        group             group
        static_files_path ""
        timeout           "600"
    
        repo_url          app["repo_url"] || node["app"]["odoo"]["default_repo_url"]
        repo_type         app["repo_type"] || node["app"]["odoo"]["default_repo_type"]
        revision          app["revision"] || node["app"]["odoo"]["default_revision"]
        #migrate           "no"

        extra_modules     []
        extra_packages    extra_packages
        notifies          :reload, 'service[nginx]'
    
    end

    # descargar modulos extra
    #code_repo do
    #end

    # creamos o ficheiro de configuracion
    #template "openerp-wsgi.py" do
    #    variables   :app => app
    #end

end
