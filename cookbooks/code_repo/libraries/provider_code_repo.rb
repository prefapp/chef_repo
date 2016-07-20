require_relative 'provider_code_repo_git'

class Chef
  class Provider
    class CodeRepo < Chef::Provider::CodeRepoGit
    end
  end
end
