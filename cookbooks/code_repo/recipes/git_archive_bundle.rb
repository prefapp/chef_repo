include_recipe "code_repo::default"

i = 0

node["repository"]["git_archive_bundle"].each do |repo|
    i = i+1

    code_repo_git_bundle "git_archive_bundle_#{i}" do
        provider    Chef::Provider::CodeRepoGitArchiveBundle
        bundle      repo["bundle"]
        owner       repo["owner"]
        group       repo["group"]   

        ssh_host_key    repo["ssh_host_key"] if repo.include?("ssh_host_key")
        credential      repo["credential"]
        action          "pull"
    end

  end

end
