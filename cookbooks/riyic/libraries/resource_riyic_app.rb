require 'chef/resource'

class Chef
  class Resource
    class  RiyicApp < Chef::Resource

      def initialize(name, run_context=nil)
        super(name, run_context)
        @resource_name = :riyic_app        # Bind ourselves to the name with an underscore
        @action = :deploy                # Default Action Goes here
        @allowed_actions = [:deploy, :force_deploy]

        # Now we need to set up any resource defaults
        @domain = name  # This is equivalent to setting :name_attribute => true
        @server_alias = []
        @target_path = nil
        @entry_point = nil
        @owner = nil
        @group = 'users'
        @repo_url = nil
        @repo_type = 'git'
        @revision = 'HEAD'

        @credential = nil
        @environment = 'production'
        @env_vars = {}
        @static_files_path = nil
        @migration_command = nil
        @internal_socket = nil
        @timeout = '60'
        @extra_packages = []
        @cookbook = nil
        @fronted_template = nil
      end

      # Define the attributes we set defaults for
      def domain(arg=nil)
        set_or_return(
          :domain,
          arg,
          :kind_of => String,
          :required => true
        )
      end

      def server_alias(arg=nil)
        set_or_return(
          :server_alias,
          arg,
          :kind_of => Array
        )
      end

      def target_path(arg=nil)
        set_or_return(
          :target_path,
          arg,
          :kind_of => String,
          :required => true
        )
      end

      def document_root(arg=nil)
        set_or_return(
          :document_root,
          arg,
          :kind_of => [String, NilClass],
          :required => false,
          :default => nil
        )
      end

      def entry_point(arg=nil)
        set_or_return(
          :entry_point,
          arg,
          :kind_of => String,
          :required => true
        )
      end

      def owner(arg=nil)
        set_or_return(
          :owner,
          arg,
          :kind_of => String,
          :default => 'owner',
        )
      end

      def group(arg=nil)
        set_or_return(
          :group,
          arg,
          :kind_of => String,
          :default => 'users'
        )
      end

      def repo_url(arg=nil)
        set_or_return(
          :repo_url,
          arg,
          :kind_of => String,
          :required => true,
        )
      end

      def repo_type(arg=nil)
        set_or_return(
          :repo_type,
          arg,
          :kind_of => String,
          :default => 'git'
        )
      end

      def revision(arg=nil)
        set_or_return(
          :revision,
          arg,
          :kind_of => String,
          :default => 'HEAD',
        )
      end

      def credential(arg=nil)
        set_or_return(
          :credential,
          arg,
          :kind_of => String,
        )
      end

      def environment(arg=nil)
        set_or_return(
          :environment,
          arg,
          :kind_of => String,
          :default => 'production'
        )
      end

      def env_vars(arg=nil)
        set_or_return(
          :env_vars,
          arg,
          :kind_of => Hash,
          :default => {}
        )
      end



      def static_files_path(arg=nil)
        set_or_return(
          :static_files_path,
          arg,
          :kind_of => String,
        )

      end

      def migration_command(arg=nil)
        set_or_return(
          :migration_command,
          arg,
          :kind_of => [String,NilClass],
          :default => nil
        )
      end


      def postdeploy_script(arg=nil)
        set_or_return(
          :postdeploy_script,
          arg,
          :kind_of => [String,NilClass],
          :default => nil
        )
      end

      def internal_socket(arg=nil)
        set_or_return(
          :internal_socket,
          arg,
          :kind_of => String,
          :default => "unix:///var/run/riyic_app.sock"
        )
      end


      def timeout(arg=nil)
        set_or_return(
          :timeout,
          arg,
          :kind_of => String,
          :default => '60'
        )
      end


      def extra_packages(arg=nil)
        set_or_return(
          :extra_packages,
          arg,
          :kind_of => Array,
        )
      end


      def repo_depth(arg=nil)
        set_or_return(
          :repo_depth,
          arg.to_i,
          :kind_of => Integer,
          :default => 0
        )
      end


      def purge_target_path(arg=nil)
        set_or_return(
          :purge_target_path,
          arg,
          :kind_of => [String, NilClass],
          :default => nil
        )
      end

      def cookbook(arg=nil)
        set_or_return(
          :cookbook,
          arg,
          :kind_of => [String, NilClass],
          :default => nil
        )
      end

      def frontend_template(arg=nil)
        set_or_return(
          :frontend_template,
          arg,
          :kind_of => [String, NilClass],
          :default => nil
        )
      end

    end
  end
end
