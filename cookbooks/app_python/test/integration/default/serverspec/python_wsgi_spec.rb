require 'spec_helper'

describe "uwsgi" do

    it "has a running service 'uwsgi'" do
        expect(service("uwsgi")).to be_running
    end
end

describe "nginx" do

    it "is listening on port tcp/80 of 0.0.0.0" do
        expect(port(80)).to be_listening.on('0.0.0.0').with('tcp')
    end

end

describe "Example WSGI app" do

    domain = $node["app"]["python"]["wsgi_apps"][0]["domain"]

    describe "Send a http connection to domain #{domain} in localhost" do
    
        c = command("curl -L -H 'Host:#{domain}' 127.0.0.1/page/foo")

        it "connection should not return error" do
            expect(c.exit_status) == 0
        end

        it "should return a determined dynamic content" do
        
            expect(c.stdout).to match /You are visiting foo/
        end

    end

    user = $node["app"]["python"]["wsgi_apps"][0]["owner"]
    target_path = $node["app"]["python"]["wsgi_apps"][0]["target_path"]

    describe file("#{target_path}") do

        it {should be_owned_by user}
        
    end


    describe "uwsgi #{domain} proccess" do

        c = command("ps -auxwwwwf |fgrep uwsgi")

        it "must be running as app user #{user}" do
            expect(c.stdout).to match /#{user}/
        end

    end


end
