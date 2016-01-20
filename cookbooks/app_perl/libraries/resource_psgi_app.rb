class Chef
    class Resource
        class PsgiApp < Chef::Resource::RiyicApp
            
            def initialize(name, run_context = nil)

                super(name, run_context)
                @resource_name = :psgi_app
                @provider = Chef::Provider::PsgiApp
                @extra_modules = []
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

            def coroae(arg=nil)
               set_or_return(
                  :coroae,
                  arg,
                  :kind_of => Integer,
                  :default => 0
               )
            end
        end

    end

end
