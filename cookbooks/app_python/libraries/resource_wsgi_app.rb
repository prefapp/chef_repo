#require File.join(File.dirname(__FILE__), 'resource_riyic_app')
#require File.join(File.dirname(__FILE__), 'provider_wsgi_app')

class Chef
  class Resource
    class WsgiApp < Chef::Resource::RiyicApp

      def initialize(name, run_context = nil)
        super(name, run_context)
        @resource_name = :wsgi_app
        @provider = Chef::Provider::WsgiApp
        @requirements_file = nil
        @extra_modules = []
      end

      def requirements_file(arg=nil)
          set_or_return(
              :requirements_file,
              arg,
              :kind_of => [String,NilClass],
              :default => nil
          )
      end


      def extra_modules(arg=nil)
          set_or_return(
              :extra_modules,
              arg,
              :kind_of => Array
          )
      end

      def processes(arg=nil)
         set_or_return(
            :processes,
            arg,
            :kind_of => Integer,
            :default => 2
         )
      end

      def threads(arg=nil)
         set_or_return(
            :threads,
            arg,
            :kind_of => Integer,
            :default => 0
         )
      end
    end
  end
end
