require 'serverspec'

set :backend, :exec

describe "php-fpm" do
    
    it "is listening on port 9000" do
        expect(port(9000)).to be_listening
    end

    it "has a running service of php-fpm" do
        expect(service("php5-fpm")).to be_running
    end
end
