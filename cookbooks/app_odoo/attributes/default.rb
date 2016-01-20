default["app"]["odoo"]["default_repo_url"] = 'https://nightly.odoo.com/8.0/nightly/src/'

default["app"]["odoo"]["default_repo_type"] = 'remote_archive'

default["app"]["odoo"]["default_revision"] = 'odoo_8.0.latest.tar.gz'

default["app"]["odoo"]["default_user"] = 'odoo'

default["app"]["odoo"]["default_group"] = 'odoogrp'

default["app"]["odoo"]["wkhtmltopdf"]["version"] = '0.12.2.1'

default["app"]["odoo"]["wkhtmltopdf"]["download_url"] = lazy do

    version = node['app']['odoo']['wkhtmltopdf']['version']
    version_array = version.split('.')

    'http://download.gna.org/wkhtmltopdf/'+
    "#{version_array[0]}.#{version_array[1]}/"+
    "#{version}/"+
    "wkhtmltox-#{version}_linux-trusty-amd64.deb"

end


