default['app']['odoo']['version'] = '9.0'

default["app"]["odoo"]["default_repo_url"] = lazy do 
  "https://nightly.odoo.com/#{node['app']['odoo']['version']}/nightly/src/"
end

default["app"]["odoo"]["default_repo_type"] = 'remote_archive'

default["app"]["odoo"]["default_revision"] = lazy do 
  "odoo_#{node['app']['odoo']['version']}.latest.tar.gz"
end

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


