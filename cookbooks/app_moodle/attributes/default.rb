default['app']['moodle']['version'] = 'MOODLE_29_STABLE'

default['app']['moodle']['default_domain'] = node['fqdn']

default['app']['moodle']['default_repo_url'] = 'git://git.moodle.org/moodle.git'

default['app']['moodle']['default_repo_type'] = 'git'

default['app']['moodle']['default_revision'] = lazy { node['app']['moodle']['version'] }

default['app']['moodle']['default_user'] = 'moodle'

default['app']['moodle']['default_group'] = 'moodle'

default['app']['moodle']['default_system_lang'] = 'es_ES'

default['app']['moodle']['default_datadir'] = lazy  {
  "#{node['app']['moodle']['target_path']}/../moodledata"
}

default['app']['moodle']['default_admin_user'] = 'admin'

