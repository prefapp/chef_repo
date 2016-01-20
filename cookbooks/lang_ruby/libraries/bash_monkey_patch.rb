def patch_bash_script
    ::Chef::Resource::Bash.class_eval do
        def initialize(name, run_context=nil)
            super
            @resource_name = :bash 
            @provider = Chef::Provider::RvmShell
            @ruby_string = "default"
            @patch = nil
        end
            
        def ruby_string(arg=nil)
            set_or_return(
                :ruby_string,
                arg,
                :kind_of => [ String ]
            )
        end

        def patch(arg=nil)
            set_or_return(
                :patch,
                arg,
                :kind_of => [ String ]
            )
        end

    end
end
