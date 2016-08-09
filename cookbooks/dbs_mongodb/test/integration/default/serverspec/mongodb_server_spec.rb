require 'spec_helper'

port = $node['mongodb']['config']['port']
interface = $node['dbs']['mongodb']['bind_address']

describe "mongodb" do

    it "is listening on port tcp/#{port} of #{interface}" do
        expect(port(port)).to be_listening.on(interface).with('tcp')
    end

    it "has a running service 'mongodb'" do
        expect(service("mongod")).to be_running
    end
    

    # debe existir a db 
    
    # debe existir o user_db

end
