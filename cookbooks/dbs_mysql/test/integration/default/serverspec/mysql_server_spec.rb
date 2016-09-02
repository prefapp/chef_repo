require 'spec_helper'

describe "mysql" do

    # it "is listening on port tcp/3306 of 0.0.0.0" do
    #     expect(port(3306)).to be_listening.on('0.0.0.0').with('tcp')
    # end
    describe command("ss -tunl |fgrep ':3306'") do
      its(:stdout){should match /3306/}
    end

    it "has a running service 'mysqld'" do
        expect(service("mysqld")).to be_running
    end

    db = $node['dbs']['mysql']['dbs'][0]
    root_pass = $node['dbs']['mysql']['server']['root_password']

    # debe existir a db
    describe command("mysql -u root -p#{root_pass} -e 'SHOW DATABASES'") do
        its(:stdout) {should match /#{db['name']}/}
    end

    # debe existir o user_db
    describe command(
        "mysql -u root -p#{root_pass} -e 'SELECT * FROM user WHERE User = \"#{db['user']}\"' mysql"
    ) do
        its(:stdout) {should match /#{db['user']}/}
    end

end
