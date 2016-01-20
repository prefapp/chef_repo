include_recipe "code_repo::default"

node["repository"]["git_archive"].each do |repo|

    # podemos saltar todas as urls que empecen por http(s), solo funciona con ssh
    # non chuta en github, podemos saltarnos todas as urls de github.com

    code_repo repo["target_path"] do
        provider    Chef::Provider::CodeRepoGitArchive
        url         repo["url"]
        revision    repo["revision"]
        owner       repo["owner"]
        group       repo["group"]
        files       repo["files"] 

        ssh_host_key    repo["ssh_host_key"] if repo.include?("ssh_host_key")
        credential      repo["credential"]
        action          "pull"
    end

end
