require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class MysqlClient
      class Ubuntu < Chef::Provider::MysqlClient
        def packages
          if node['platform_version'] == '16.04'
            %w(mysql-client-5.7 libmysqlclient-dev)
          else
            %w(mysql-client-5.5 libmysqlclient-dev)
          end
        end
      end
    end
  end
end
