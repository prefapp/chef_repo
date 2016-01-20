require 'chefspec'
at_exit { ChefSpec::Coverage.report! }

RSpec.configure do |c|
    c.cookbook_path = ["/mnt/cookbooks/supermarket", "/mnt/riyic/cookbooks", "/mnt/others/cookbooks"]
    c.platform = 'ubuntu'
    c.version = '14.04'
end
