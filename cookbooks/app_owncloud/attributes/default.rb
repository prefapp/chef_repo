default['app']['owncloud']['version'] = 'latest'
default['app']['owncloud']['repo_url'] = "http://download.owncloud.org/community/"
default['app']['owncloud']['repo_type'] = 'remote_archive'

default['app']['owncloud']['revision'] = lazy {
    "owncloud-#{node['app']['owncloud']['version']}.tar.bz2"
}

default['app']['owncloud']['dbtype'] = 'sqlite'

default['app']['owncloud']['dbtableprefix'] = 
    (node['app']['owncloud']['dbtype'] == 'sqlite')? 'oc_' : ''

default['app']['owncloud']['adminlogin'] = ''
default['app']['owncloud']['adminpass'] = ''
default['app']['owncloud']['data_dir'] = 
    "/opt/owncloud_data"

default['app']['owncloud']['max_upload_size'] = '512M'

#default['owncloud']['deploy_from_git'] = false
#default['owncloud']['git_repo'] = 'https://github.com/owncloud/core.git'
#default['owncloud']['git_ref'] = nil
#default['owncloud']['dir'] = "#{node['owncloud']['www_dir']}/owncloud"
#default['owncloud']['data_dir'] = "#{node['owncloud']['dir']}/data"
#default['owncloud']['server_name'] = node['fqdn'] || 'owncloud.local'
#default['owncloud']['server_aliases'] = [ 'localhost' ] # required by http_request[run setup]
#default['owncloud']['install_postfix'] = true
#default['owncloud']['web_server'] = 'apache'
#default['owncloud']['php-fpm']['pool'] = 'owncloud'
#default['owncloud']['max_upload_size'] = '512M'
#default['owncloud']['sendfile'] = node['virtualization']['system'].eql?('vbox') ? false : true
#default['owncloud']['ssl'] = true
#default['owncloud']['ssl_key']['source'] = 'self-signed'
#default['owncloud']['ssl_key']['bag'] = nil
#default['owncloud']['ssl_key']['item'] = nil
#default['owncloud']['ssl_key']['item_key'] = nil
#default['owncloud']['ssl_key']['encrypted'] = false
#default['owncloud']['ssl_key']['secret_file'] = nil
#default['owncloud']['ssl_key']['path'] = nil
#default['owncloud']['ssl_key']['content'] = nil
#default['owncloud']['ssl_cert']['source'] = 'self-signed'
#default['owncloud']['ssl_cert']['bag'] = nil
#default['owncloud']['ssl_cert']['item'] = nil
#default['owncloud']['ssl_cert']['item_key'] = nil
#default['owncloud']['ssl_cert']['encrypted'] = false
#default['owncloud']['ssl_cert']['secret_file'] = nil
#default['owncloud']['ssl_cert']['path'] = nil
#default['owncloud']['ssl_cert']['content'] = nil
#default['owncloud']['admin']['user'] = 'admin'
#default['owncloud']['admin']['pass'] = nil
#default['owncloud']['config']['dbtype'] = 'mysql'
#default['owncloud']['config']['dbname'] = 'owncloud'
#default['owncloud']['config']['dbuser'] = 'owncloud'
#default['owncloud']['config']['dbpassword'] = nil
#default['owncloud']['config']['dbhost'] = 'localhost'
#default['owncloud']['config']['dbtableprefix'] = ''
#default['owncloud']['config']['mail_smtpmode'] = 'sendmail'
#default['owncloud']['config']['mail_smtphost'] = '127.0.0.1'
#default['owncloud']['config']['mail_smtpport'] = 25
#default['owncloud']['config']['mail_smtptimeout'] = 10
#default['owncloud']['config']['mail_smtpsecure'] = ''
#default['owncloud']['config']['mail_smtpauth'] = false
#default['owncloud']['config']['mail_smtpauthtype'] = 'LOGIN'
#default['owncloud']['config']['mail_smtpname'] = ''
#default['owncloud']['config']['mail_smtppassword'] = ''
#default['owncloud']['cron']['enabled'] = true
#default['owncloud']['cron']['min'] = '*/15'
#default['owncloud']['cron']['day'] = '*'
#default['owncloud']['cron']['hour'] = '*'
#default['owncloud']['cron']['month'] = '*'
#default['owncloud']['cron']['weekday'] = '*'
