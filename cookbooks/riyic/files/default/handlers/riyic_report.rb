#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2010 Opscode, Inc.
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

require 'chef/handler'
require 'net/http'
require 'chef/resource/directory'

module Riyic
    class Report < ::Chef::Handler

      # servidores de produccion e desarrollo
      PRODUCTION_SERVER = 'https://riyic.com/api/v1'
      DEV_SERVER = 'http://10.0.3.1:3000/api/v1'

      attr_reader :config
    
      def initialize(config={})
        @config = config

        #
        # se non existe o atributo env enton evitamos comunicar nada
        #
        if @config[:env]
            host = (@config[:env] == 'production')? PRODUCTION_SERVER: DEV_SERVER
            
            controller = (@config[:node_details])? 'nodedetails' : 'reports'

            @config[:report_url] = "#{host}/servers/#{@config[:server_id]}/#{controller}"

        end

        @config
      end

      def report  
        # enviamos un reporte de execucion, ou a info do node segun o parametro que nos pasen

        if @config[:node_details]
          node_details
        else
          riyic_report
        end

      end
    

      def node_details
    
        if exception
          Chef::Log.error("Creating JSON exception report")
        else
          Chef::Log.info("Creating JSON run report")
        end
        #ensure start time and end time are output in the json properly in the event activesupport happens to be on the system
        #run_data = data
        #run_data[:start_time] = run_data[:start_time].to_s
        #run_data[:end_time] = run_data[:end_time].to_s          
        run_data = run_status.node
        log = send_report(run_data)
    
        Chef::Log.info("Node details sent #{log}")
      end

    
      def riyic_report

        run_data = {}
    
        run_data[:status] = (run_status.success?)? 'OK':'KO'

        #run_data[:elapsed_time] = run_status.elapsed_time.round(3)
        # round non acepta argumentos en ruby 1.8
        run_data[:elapsed_time] = run_status.elapsed_time.round()
        run_data[:start_time] = run_status.start_time
        run_data[:end_time] = run_status.end_time

        if exception
          Chef::Log.error("Creating JSON exception report")
          run_data[:exception] = run_status.formatted_exception
          run_data[:backtrace] = run_status.backtrace
        else
          Chef::Log.info("Creating JSON run report")
        end

        ## cuidadin con json de chef que peta como unha castanha co que usamos na web (os null non os acepta ben vacios?)
        #run_data[:all_resources] = run_status.all_resources
        #run_data[:updated_resources] = run_status.updated_resources
    
        log = send_report(run_data)

        Chef::Log.info("Report sent #{log}")
      end
      


      def send_report(run_data)

        return unless(@config[:report_url])

        uri = URI(@config[:report_url])

        http = Net::HTTP.new(uri.host, uri.port)
        #http.use_ssl = true

        req = Net::HTTP::Post.new(uri.request_uri)
        req.set_form_data(:auth_token => @config[:auth_token], 
                          :data => Chef::JSONCompat.to_json(run_data))
                          #:data => Chef::JSONCompat.to_json_pretty(run_data))

        response = http.request(req)
        case response
        when Net::HTTPSuccess, Net::HTTPRedirection
            # OK
            log = " OK: #{response.body}"
        else
            log = " KO: #{response.value}"
        end

        log

      end
    
    end
end
