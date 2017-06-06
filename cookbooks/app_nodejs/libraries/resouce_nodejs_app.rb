class Chef
  class Resource
    class NodejsApp < Chef::Resource::RiyicApp

      def initialize(name, run_context = nil)
        super(name, run_context)
        @resource_name = :nodejs_app
        @provider = Chef::Provider::NodejsApp
        @entry_point = 'index.js'
      end


      def entry_point(arg=nil)
        set_or_return(
          :entry_point,
          arg,
          :kind_of => String,
          :required => true
        )
      end

      def extra_modules(arg=nil)
          set_or_return(
              :extra_modules,
              arg,
              :kind_of => Array,
              :default => []
          )
      end
    end
  end
end
