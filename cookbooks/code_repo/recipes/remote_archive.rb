include_recipe "code_repo::default"

node["repository"]["remote_archive"].each do |repo|

    code_repo repo["target_path"] do
        provider    Chef::Provider::CodeRepoRemoteArchive
        url         repo["url"]
        revision    repo["archive"]
        owner       repo["owner"]
        group       repo["group"]   

        ssh_host_key    repo["ssh_host_key"] if repo.include?("ssh_host_key")
        credential      repo["credential"]
        action          "pull"
    end

  end

end
