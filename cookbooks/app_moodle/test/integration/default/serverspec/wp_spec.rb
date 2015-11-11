require 'spec_helper'

describe "Wordpress app" do

    domain = $node["app"]["wordpress"]["installation"]["domain"]

    describe "Send a http connection to domain #{domain} in localhost" do
    
        c = command("curl -L -H 'Host:#{domain}' 127.0.0.1/")

        it "connection should not return error" do
            expect(c.exit_status) == 0
        end

        it "should respond with wordpress message" do
        
            expect(c.stdout).to match /wordpress|database connection/
        end

        #its(:stdout) {should match /wordpress/}

        #its(:exit_status) {should eq 0 }

    end

    user = $node["app"]["wordpress"]["installation"]["user"]
    target_path = $node["app"]["wordpress"]["installation"]["target_path"]

    describe file("#{target_path}/index.php") do

        it {should be_owned_by user}
        
    end


    describe "php5-fpm '#{domain}' pool" do

        c = command("ps axo user:30,pid,pcpu,pmem,vsz,rss,tty,stat,start,time,cmd:1000 |fgrep 'pool #{domain}'")

        it "must be running as app user '#{user}'" do
            expect(c.stdout).to match /^#{user}/
        end

    end


end
