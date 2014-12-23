require 'spec_helper'

describe 'app_php::fcgi_app' do

    let(:chef_run){

        ChefSpec::SoloRunner.new(step_into: ['fcgi_app']) do |node|
            node.set["riyic"] = {
                "dockerized"=> "yes",
                "updates_check_interval" => "never"
            }

            node.set["app"] = {
                "php" => {
                    "fcgi_apps" => [{
                        "domain" => "wp.riyic.com",
                        "environment" => "production",
                        "target_path" => "/home/riyic/",
                        "owner" => "riyic",
                        "repo_url" => "https://github.com/WordPress/WordPress.git",
                        "repo_type" => "git",
                        "migrate" => "no",
                        "group" => "riyicgrp",
                        "revision" => "4.0.1",
                        "repo_depth" => 1,
                        "purge_target_path" => "yes"
                    }]
                }
            }
            
        end.converge('riyic::default','app_php::fcgi_app')
    }

    it 'install php-fpm package' do
        expect(chef_run).to install_package('php5-fpm')
        expect(chef_run).to install_package('php5')
    end

    it 'configure backend' do
        expect(chef_run).to create_fpm_pool("#{chef_run.node["app"]["php"]["fcgi_apps"][0]["domain"]}")
    end

    it 'configure frontend' do
        expect(chef_run).to create_nginx_fpm_site("#{chef_run.node["app"]["php"]["fcgi_apps"][0]["domain"]}")
    end
end
