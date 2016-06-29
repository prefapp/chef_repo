# instalamos a ultima version de wkhtmltox 
# ollo que tenhen que estar instalados os paquetes necesarios no sistema, senon casca
package_path = "/tmp/wkhtmltopdf.deb"

remote_file package_path do
    #source "#{node['app']['odoo']['wkhtmltopdf']['download_url']}/#{latest_version}/wkhtmltox-#{latest_version}_linux-trusty-amd64.deb"
    source node['app']['odoo']['wkhtmltopdf']['download_url'].call
    action :create_if_missing
    backup false
end

dpkg_package "wkhtmltopdf.deb" do
    source      package_path 
    action      :install
end


