include_recipe "code_repo::default"

node["repository"]["git"].each do |repo|

  code_repo repo["target_path"] do
    provider    Chef::Provider::CodeRepoGit
    url         repo["url"]
    revision    repo["revision"]
    owner       repo["owner"]
    group       repo["group"]   

    ssh_host_key    repo["ssh_host_key"] if repo.include?("ssh_host_key")
    credential      repo["credential"]
    action          "pull"

  end

end
