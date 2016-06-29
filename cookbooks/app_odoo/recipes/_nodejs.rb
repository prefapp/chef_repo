if node['app']['odoo']['version'].to_i >= 9
  
  node.set['lang']['nodejs']['package'] = [%w{less}]

  include_recipe "lang_nodejs::default"


  link '/usr/bin/node' do
    to '/usr/bin/nodejs'
  end

end
