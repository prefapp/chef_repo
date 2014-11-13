require File.join(File.dirname(__FILE__), 'resource_riyic_app')
require File.join(File.dirname(__FILE__), 'provider_wsgi_app')

class Chef
  class Resource
    class WsgiApp < Chef::Resource::RiyicApp

      def initialize(name, run_context = nil)
        super(name, run_context)
        @resource_name = :wsgi_app
        @provider = Chef::Provider::WsgiApp
        @requirements_file = 'requirements.txt'
        @extra_modules = []
      end

      def requirements_file(arg=nil)
          set_or_return(
              :requirements_file,
              arg,
              :kind_of => String,
              :default => 'requirements.txt'
          )
      end


      def extra_modules(arg=nil)
          set_or_return(
              :extra_modules,
              arg,
              :kind_of => Array
          )
      end


    end
  end
end
