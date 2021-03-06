#require File.join(File.dirname(__FILE__), 'resource_riyic_app')
#require File.join(File.dirname(__FILE__), 'provider_wsgi_app')

class Chef
  class Resource
    class FcgiApp < Chef::Resource::RiyicApp

      def initialize(name, run_context = nil)
        super(name, run_context)
        @resource_name = :fcgi_app
        @provider = Chef::Provider::FcgiApp
        @php_ini_admin_values = {}
 
      end


      def extra_modules(arg=nil)
          set_or_return(
              :extra_modules,
              arg,
              :kind_of => Array,
              :default => []
          )
      end

      def php_ini_admin_values(arg=nil)
          set_or_return(
              :php_ini_admin_values,
              arg,
              :kind_of => Hash,
              :default => {}
          )
      end

      # def processes(arg=nil)
      #    set_or_return(
      #       :processes,
      #       arg,
      #       :kind_of => Integer,
      #       :default => 2
      #    )
      # end

      # def threads(arg=nil)
      #    set_or_return(
      #       :threads,
      #       arg,
      #       :kind_of => Integer,
      #       :default => 0
      #    )
      # end
    end
  end
end
