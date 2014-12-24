require 'spec_helper'

describe "php-fpm" do

    describe port(9000) do
        it "expects not to be listening on all interfaces" do
            is_expected.not_to be_listening.on('0.0.0.0')
        end

        it "expects to be listening with tcp on localhost" do
            is_expected.to be_listening.on('127.0.0.1').with('tcp')
        end

        #expect(port(9000)).to be_listening.on('127.0.0.1').with('tcp')
        #expect(port(9000)).not_to be_lis
    end

    it "has a running service 'php5-fpm'" do
        expect(service("php5-fpm")).to be_running
    end
end

describe "nginx" do

    it "is listening on port tcp/80 of 0.0.0.0" do
        expect(port(80)).to be_listening.on('0.0.0.0').with('tcp')
    end

end

describe "Wordpress PHP app" do

    domain = $node["app"]["php"]["fcgi_apps"][0]["domain"]

    describe "Send a http connection to domain #{domain} in localhost" do
    
        c = command("curl -L -H 'Host:#{domain}' 127.0.0.1/wp-admin/setup-config.php")

        it "connection should not return error" do
            expect(c.exit_status) == 0
        end

        it "should respond with wordpress setup page" do
        
            expect(c.stdout).to match /wordpress/
        end

        #its(:stdout) {should match /wordpress/}

        #its(:exit_status) {should eq 0 }

    end

    user = $node["app"]["php"]["fcgi_apps"][0]["owner"]
    target_path = $node["app"]["php"]["fcgi_apps"][0]["target_path"]

    describe file("#{target_path}index.php") do

        it {should be_owned_by user}
        
    end


end
