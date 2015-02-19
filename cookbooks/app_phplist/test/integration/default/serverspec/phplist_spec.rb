require 'spec_helper'

describe "Phplist app" do

    domain = $node["app"]["phplist"]["installations"][0]["domain"]

    describe "Send a http connection to domain #{domain} in localhost" do
    
        c = command("curl -L -H 'Host:#{domain}' 127.0.0.1/lists/")

        it "connection should not return error" do
            expect(c.exit_status) == 0
        end

        it "should respond with phplist message" do
        
            expect(c.stdout).to match /phplist|Unknown database/
        end

        #its(:stdout) {should match /wordpress/}

        #its(:exit_status) {should eq 0 }

    end

    user = $node["app"]["phplist"]["installations"][0]["user"]
    target_path = $node["app"]["phplist"]["installations"][0]["target_path"]

    describe file("#{target_path}/public_html/lists/index.php") do

        it {should be_owned_by user}
        
    end


    describe "php5-fpm '#{domain}' pool" do

        c = command("ps -auxwwwwf |fgrep 'pool #{domain}'")

        it "must be running as app user '#{user}'" do
            expect(c.stdout).to match /^#{user}/
        end

    end


end
