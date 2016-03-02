default['app']['magento']['version'] = '2.0.0'

default['app']['magento']['default_domain'] = node['fqdn']

default['app']['magento']['default_repo_url'] = 'https://github.com/magento/magento2.git'

default['app']['magento']['default_repo_type'] = 'git'

default['app']['magento']['default_revision'] = lazy { node['app']['magento']['version'] }

default['app']['magento']['default_user'] = 'magento'

default['app']['magento']['default_group'] = 'magento'

default['app']['magento']['default_system_lang'] = 'es_ES'

default['app']['magento']['default_datadir'] = lazy  {
   "#{node['app']['magento']['target_path']}/../magentodata"
}
