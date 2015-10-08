require 'spec_helper'

describe "Minecraft Server is running?" do

    c = command('ps --no-headers -o comm -u minecraft')

    it "has a running service java on minecraf user?" do
        expect(c.stdout).to match /java/i
    end
	
    #port = $node['app']['minecraft']['server-port']

    it "is listening Minecraft Server on port 25565?" do
        expect(port(25565)).to be_listening.on('0.0.0.0')
    end

end

