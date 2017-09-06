# 
# agregamos o ppa de certbot
#
apt_repository 'nodejs' do
  uri           node['lang']['nodejs']['repo']
  distribution  node['lsb']['codename']
  components    ['main']
  keyserver     node['lang']['nodejs']['keyserver']
  key           node['lang']['nodejs']['key']
end

package 'nodejs' do
  action :upgrade
end


