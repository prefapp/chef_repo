require 'spec_helper'

describe "postgresql" do

    p = $node['postgresql']['config']['port']
    it "is listening on port tcp/#{p} of 0.0.0.0" do
        expect(port(p)).to be_listening.on('0.0.0.0').with('tcp')
    end

    it "has a running service 'postgres'" do
        expect(service("postgres")).to be_running
    end
    
    db = $node['dbs']['postgresql']['dbs'][0]

    # debe existir a db 
    describe command("su -c \"psql -p #{p} -l\" - postgres") do
        its(:stdout) {should match /#{db['name']}/}
    end
    
    # debe existir o user_db
    describe command(
        "su -c \"psql postgres -p #{p} -tAc \\\"SELECT 1 FROM pg_roles WHERE rolname=\'#{db["user"]}\'\\\"\" - postgres"
    ) do
        its(:stdout) {should match /1/}
    end

    # o usuario debe ter os privilegios especificados
    describe command(
        "su -c \"psql -p #{p} -tAc \\\"\\\du\\\" \" - postgres"
    ) do
        its(:stdout) {should match /#{db['user']}|Create DB/}
    end


end
