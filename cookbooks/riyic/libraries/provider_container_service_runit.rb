#
# Copyright:: Copyright (c) 2012-2014 Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/resource/link'
require 'chef/provider/link'
require 'chef/resource/file'
require 'chef/provider/file'
require 'chef/resource/directory'
require 'chef/provider/directory'
require_relative 'provider_container_service.rb'

class Chef
  class Provider
    class ContainerService
      class Runit < Chef::Provider::ContainerService

        attr_reader :command
        attr_reader :log_type # stdout, file

        TIMEOUT = 10
        VERBOSE = false
        LOGS_BASE_DIR = '/opt/logs'

        def self.logs_base_dir
          LOGS_BASE_DIR
        end

        def initialize(name, run_context=nil)
          super
          @new_resource.supports[:status] = true
          @staging_dir = nil
          @down_file = nil
          @run_script = nil
          @log_dir = nil
          @log_config = nil
          @log_main_dir = nil
          @log_run_script = nil
          @service_dir_link = nil

          options = node['container_service'][new_resource.service_name]
          Chef::Log.info(options)
          @command = options['command']
          @log_type = options['log_type'].nil? ? :file : options['log_type'].to_sym
          @run_script_content = options['run_script_content']
          @check_script_content = options['check_script_content']
          @disable = options['disable']
        end

        def load_current_resource
          @current_resource = Chef::Resource::Service.new(new_resource.name, run_context)
          @current_resource.service_name(new_resource.service_name)
          return if @disable

          setup

          # Check the current status of the runit service
          @current_resource.running(running?)
          @current_resource.enabled(enabled?)
          @current_resource
        end

        ##
        # Setup Action
        #
        def setup
          Chef::Log.debug("Creating service staging directory for #{new_resource.service_name}")
          staging_dir.run_action(:create)

          Chef::Log.debug("Creating service directory")
          service_dir.run_action(:create)

          Chef::Log.debug("Creating down file for #{new_resource.service_name}")
          down_file.run_action(:create)

          Chef::Log.debug("Creating run script for #{new_resource.service_name}")
          run_script.run_action(:create)

          if @check_script_content
            Chef::Log.debug("Creating check script for #{new_resource.service_name}")
            check_script.run_action(:create)
          end

          #if @log_type.eql?(:file)
            Chef::Log.debug("Creating '#{log_dir}' directory for #{new_resource.service_name}")
            log_dir.run_action(:create)
            log_config.run_action(:create)
          #end

          Chef::Log.debug("Creating log dir for #{new_resource.service_name}")
          log_main_dir.run_action(:create)

          Chef::Log.debug("Creating log run script for #{new_resource.service_name}")
          log_run_script.run_action(:create)

          Chef::Log.debug("Linking staging directory to service directory for #{new_resource.service_name}")
          service_dir_link.run_action(:create)
        end


        ##
        # Service Resource Overrides
        #
        def enable_service
          return if @disable
          down_file.run_action(:delete)
        end

        def disable_service
          return if @disable
          down_file.run_action(:create)
          shell_out("#{sv_bin} #{sv_args} down #{service_dir_name}")
          Chef::Log.debug("#{new_resource} down")
        end

        def start_service
          return if @disable
          wait_for_service_enable
          shell_out!("#{sv_bin} #{sv_args} start #{service_dir_name}")
        end

        def stop_service
          return if @disable
          shell_out!("#{sv_bin} #{sv_args} stop #{service_dir_name}")
        end

        def restart_service
          return if @disable
          shell_out!("#{sv_bin} #{sv_args} restart #{service_dir_name}")
        end

        def reload_service
          return if @disable
          shell_out!("#{sv_bin} #{sv_args} force-reload #{service_dir_name}")
        end

        def sv_args
          sv_args = ''
          sv_args += "-w #{TIMEOUT} " if TIMEOUT
          sv_args += '-v ' if VERBOSE
          sv_args
        end
        ##
        # Helper Methods for Service Override
        #
        def running?
          cmd = shell_out("#{sv_bin} status #{service_dir_name}")
          (cmd.stdout.match(/^run:/) && cmd.exitstatus == 0) ? true : false
        end

        def enabled?
          !::File.exists?(::File.join(service_dir_name, 'down'))
        end

        ##
        # General Helpers Methods
        #
        def wait_for_service_enable
          Chef::Log.debug("waiting until named pipe #{service_dir_name}/supervise/ok exists.")
          until ::FileTest.pipe?("#{service_dir_name}/supervise/ok")
            sleep 1
            Chef::Log.debug('.')
          end

          Chef::Log.debug("waiting until named pipe #{service_dir_name}/log/supervise/ok exists.")
          until ::FileTest.pipe?("#{service_dir_name}/log/supervise/ok")
            sleep 1
            Chef::Log.debug('.')
          end
        end

        def service_dir_name
          ::File.join(omnibus_root, 'service', new_resource.service_name)
        end

        def staging_dir_name
          ::File.join(omnibus_root, 'sv', new_resource.service_name)
        end

        def sv_bin
          "sleep 5 && #{::File.join(omnibus_embedded_bin_dir, 'sv')}"
        end

        ##
        # Helper Methods for Supervisor Setup
        #
        def run_script_content

            (@run_script_content)?

                @run_script_content :

                "#!/bin/sh
exec 2>&1
exec #{@command} 2>&1"

        end

        def log_run_script_content
          content = "#!/bin/sh\n"
          case @log_type
          when :stdout
            content += "exec chef-init-logger --service-name #{new_resource.service_name} --log-destination stdout"
          when :file
            content += "exec svlogd -tt #{service_log_dir_path}"
          end
          content
        end

        def service_log_dir_path 
          return "#{LOGS_BASE_DIR}/#{new_resource.service_name}"
        end

        ##
        # Helper Methods that control Chef Resources
        #
        def staging_dir
          return @staging_dir unless @staging_dir.nil?
          @staging_dir = Chef::Resource::Directory.new(staging_dir_name, run_context)
          @staging_dir.recursive(true)
          @staging_dir.mode(00755)
          @staging_dir
        end

        def service_dir
          return @service_dir unless @service_dir.nil?
          @service_dir = Chef::Resource::Directory.new(::File.join(omnibus_root, 'service'), run_context)
          @service_dir.recursive(true)
          @service_dir.mode(00755)
          @service_dir
        end

        def run_script
          return @run_script unless @run_script.nil?
          @run_script = Chef::Resource::File.new(::File.join(staging_dir_name, 'run'), run_context)
          @run_script.content(run_script_content)
          @run_script.mode(00755)
          @run_script
        end

        def check_script
          return @check_script unless @check_script.nil?
          @check_script = Chef::Resource::File.new(::File.join(staging_dir_name, 'check'), run_context)
          @check_script.content(@check_script_content)
          @check_script.mode(00755)
          @check_script
        end


        def log_dir
          return @log_dir unless @log_dir.nil?
          @log_dir = Chef::Resource::Directory.new(service_log_dir_path, run_context)
          @log_dir.recursive(true)
          @log_dir.mode(00755)
          @log_dir
        end


        def log_main_dir
          return @log_main_dir unless @log_main_dir.nil?
          @log_main_dir = Chef::Resource::Directory.new(::File.join(staging_dir_name, 'log'), run_context)
          @log_main_dir.recursive(true)
          @log_main_dir.mode(00755)
          @log_main_dir
        end

        def log_run_script
          return @log_run_script unless @log_run_script.nil?
          @log_run_script = Chef::Resource::File.new(::File.join(staging_dir_name, 'log', 'run'), run_context)
          @log_run_script.content(log_run_script_content)
          @log_run_script.mode(00755)
          @log_run_script
        end

        def log_config
          return @log_config unless @log_config.nil?
          @log_config = Chef::Resource::File.new("#{service_log_dir_path}/config", run_context)
          @log_config.content("
# ver http://smarden.org/runit/svlogd.8.html
#

# tamanho maximo de current (300MB)
s300000000

# ficheiros rotados  a manter antes de purgar
n15

# se non hai espacio cantos ficheiros rotados minimos debemos manter
N3
")
          @log_config.mode(00755)
          @log_config
        end

        def service_dir_link
          return @service_dir_link unless @service_dir_link.nil?
          @service_dir_link = Chef::Resource::Link.new(::File.join(service_dir_name), run_context)
          @service_dir_link.to(staging_dir_name)
          @service_dir_link
        end

        def down_file
          return @down_file unless @down_file.nil?
          @down_file = Chef::Resource::File.new(::File.join(staging_dir_name, 'down'), run_context)
          @down_file.backup(false)
          @down_file
        end
      end
    end
  end
end
