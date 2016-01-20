require 'spec_helper'

port = $node['mongodb']['config']['port']

describe "mongodb" do

    it "is listening on port tcp/#{port} of 0.0.0.0" do
        expect(port(3306)).to be_listening.on('0.0.0.0').with('tcp')
    end

    it "has a running service 'mongodb'" do
        expect(service("mongod")).to be_running
    end
    

    # debe existir a db 
    
    # debe existir o user_db

end
