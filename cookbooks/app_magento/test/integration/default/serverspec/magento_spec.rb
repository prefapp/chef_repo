require 'spec_helper'

describe "Magento app" do

    domain = $node["app"]["magento"]["domain"]

    describe "Send a http connection to domain #{domain} in localhost" do
    
        c = command("curl -L -H 'Host:#{domain}' 127.0.0.1/")

        it "connection should not return error" do
            expect(c.exit_status) == 0
        end

        it "should respond with magento message" do
        
            expect(c.stdout).to match /magento|database connection/
        end

        #its(:stdout) {should match /magento/}

        #its(:exit_status) {should eq 0 }

    end

    user = $node["app"]["magento"]["user"]
    target_path = $node["app"]["magento"]["installation"]["target_path"]

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
