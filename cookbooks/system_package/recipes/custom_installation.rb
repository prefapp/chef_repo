node["system"]["packages"]["custom_installation"].each do |item|

    package_path = item["source"]

    if item["source_url"]

        package_path = "/tmp/#{item['name']}"

        remote_file package_path do

            source item["source_url"]
            action :create_if_missing
            backup false
            checksum item["checksum"] if item["checksum"]
        end

    end


    dpkg_package item["name"] do
        source      package_path 
        version     item["version"] if item["version"]
        options     item["options"] if item["options"]
        action      :install
    end
end
