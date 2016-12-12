# aseguramos que o metodo de instalacion sexa por paqueteria
# de momento (ubuntu14 ten no repo php 5.5.9)
node.override["php"]["install_method"] = node['lang_php']['install_method']

if node["lang"]["php"]["version"] >= '5.6'

  apt_repository 'ondrej-php' do
    uri          'ppa:ondrej/php'
    distribution node['lsb']['codename']
    only_if { node['lang']['php']['version'] >= '5.6' }
  end

  version_corta = node["lang"]["php"]["version"]

  node.override["php"]["version"] = version_corta
  node.override["php"]["conf_dir"] = "/etc/php/#{version_corta}/cli"

  node.override["php"]["packages"] = %W{

    php#{version_corta}
    php#{version_corta}-cli
    php#{version_corta}-mcrypt
    php#{version_corta}-mbstring
    php#{version_corta}-curl
    php#{version_corta}-gd
    php#{version_corta}-intl
    php#{version_corta}-xsl
    php#{version_corta}-zip
    php-pear

  }

  node.override["php"]["mysql"]["packages"] = "php#{version_corta}-mysql"
  node.override["php"]["fpm_package"] = "php#{version_corta}-fpm"
  node.override["php"]["fpm_pooldir"] = "/etc/php/#{version_corta}/fpm/pool.d"
  node.override["php"]["fpm_service"] = "php#{version_corta}-fpm"
  node.override["php"]["fpm_default_conf"] = "/etc/php/#{version_corta}/fpm/pool.d/www.conf"


end

include_recipe "php::default"
