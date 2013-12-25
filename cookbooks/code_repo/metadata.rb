name             "code_repo"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
version          "0.1.1"
description      "Download source code from different source repo types"

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "default",
    :description => "empty",
    :attributes => []

recipe "git_repo",
    :description => "Download code from a git repo",
    :attributes => [/^repository\/git\//],
    :stackable => true

recipe "git_bundle",
    :description => "Download code from various git repos",
    :attributes => [/^repository\/git_bundle\//],
    :stackable => true

recipe "git_archive",
    :description => "Download archives from a git repo",
    :attributes => [/^repository\/git_archive\//],
    :stackable => true

recipe "git_archive_bundle",
    :description => "Download archives from varios git repos",
    :attributes => [/^repository\/git_archive_bundle\//],
    :stackable => true

# git 
attribute "repository/git/@/target_path",
    :display_name => "Destination path",
    :description => 'The code will be deployed to this folder',
    :default => '/usr/src/my_app',
    :advanced => false,
    :validations => {predefined: "unix_path"}

attribute "repository/git/@/url",
    :display_name => 'Repository source code url',
    :description => 'Repository from which to download source code',
    :advanced => false,
    :required => true,
    :default => "git@github.com:gitsite/deployment.git",
    :validations => {predefined: "url"}

attribute "repository/git/@/revision",
    :display_name => 'Repository revision',
    :description => 'Repository revision/tag/branch/commit to pull',
    :default => "HEAD",
    :validations => {predefined: "revision"}

attribute "repository/git/@/owner",
    :display_name => "Deployment owner",
    :description => 'User that shall own the target path',
    :default => 'owner',
    :advanced => false,
    :validations => {predefined: "username"}

attribute "repository/git/@/group",
    :display_name => "Deployment group",
    :description => 'The group that shall own the target path',
    :default => 'ownergrp',
    :validations => {predefined: "username"}

attribute "repository/git/@/credential",
    :display_name => "Credential to private repo",
    :description => 'Credential to authenticate with remote private repo',
    :field_type => 'textarea',
    :validations => {predefined: "multiline_text"}

attribute "repository/git/@/ssh_host_key",
    :display_name => "Remote ssh host key",
    :description => 'Remote ssh host key to host key verification',
    :validations => {predefined: "text"}


# git (bundle)
attribute "repository/git_bundle/@/bundle",
    :display_name => 'List of git repos to download. Format: "target_path|git_repo_url|revision"',
    :description => 'List of repos to download and where',
    :advanced => false,
    :required => true,
    :type => "array",
    :default => ["/usr/src/my_app|git@github.com:gitsite/deployment.git|HEAD"],
    :validations => {predefined: "git_bundle"}

attribute "repository/git_bundle/@/owner",
    :display_name => "Deployment owner",
    :description => 'User that shall own the target path',
    :default => 'owner',
    :advanced => false,
    :validations => {predefined: "username"}

attribute "repository/git_bundle/@/group",
    :display_name => "Deployment group",
    :description => 'The group that shall own the target path',
    :default => 'ownergrp',
    :validations => {predefined: "username"}

attribute "repository/git_bundle/@/credential",
    :display_name => "Credential to private repo",
    :description => 'Credential to authenticate with remote private repo',
    :field_type => 'textarea',
    :validations => {predefined: "multiline_text"}

attribute "repository/git_bundle/@/ssh_host_key",
    :display_name => "Remote ssh host key",
    :description => 'Remote ssh host key to host key verification',
    :validations => {predefined: "text"}


# git_archive
attribute "repository/git_archive/@/target_path",
    :display_name => "Destination path",
    :description => 'The code will be deployed to this folder',
    :default => '/usr/src/my_app',
    :advanced => false,
    :validations => {predefined: "unix_path"}

attribute "repository/git_archive/@/url",
    :display_name => 'Repository source code url',
    :description => 'Repository from which to download source code',
    :advanced => false,
    :required => true,
    :default => "git@github.com:gitsite/deployment.git",
    :validations => {predefined: "url"}

attribute "repository/git_archive/@/files",
    :display_name => 'List of files/directories to download from repo',
    :description => 'List of files/directories to download from repo',
    :default => [],
    :type => "array",
    :validations => {predefined: "unix_path"}


attribute "repository/git_archive/@/revision",
    :display_name => 'Repository revision',
    :description => 'Repository revision/tag/branch/commit',
    :default => "HEAD",
    :validations => {predefined: "revision"}

attribute "repository/git_archive/@/owner",
    :display_name => "Deployment owner",
    :description => 'User that shall own the target path',
    :default => 'owner',
    :advanced => false,
    :validations => {predefined: "username"}

attribute "repository/git_archive/@/group",
    :display_name => "Deployment group",
    :description => 'The group that shall own the target path',
    :default => 'ownergrp',
    :validations => {predefined: "username"}

attribute "repository/git_archive/@/credential",
    :display_name => "Credential to private repo",
    :description => 'Credential to authenticate with remote private repo',
    :field_type => 'textarea',
    :validations => {predefined: "multiline_text"}

attribute "repository/git_archive/@/ssh_host_key",
    :display_name => "Remote ssh host key",
    :description => 'Remote ssh host key to host key verification',
    :validations => {predefined: "text"}


# git_archive (bundle)
attribute "repository/git_archive_bundle/@/bundle",
    :display_name => 'Bundle of repos from where to download files. Format: "target_path|git_repo_url|revision|file1,file2..."',
    :description => 'Bundle of repos from where to download files',
    :advanced => false,
    :required => true,
    :type => "array",
    :default => ["/usr/src/my_app|git@github.com:gitsite/deployment.git|HEAD|file1,dir1"],
    :validations => {predefined: "git_bundle"}

attribute "repository/git_archive_bundle/@/owner",
    :display_name => "Deployment owner",
    :description => 'User that shall own the target path',
    :default => 'owner',
    :advanced => false,
    :validations => {predefined: "username"}

attribute "repository/git_archive_bundle/@/group",
    :display_name => "Deployment group",
    :description => 'The group that shall own the target path',
    :default => 'ownergrp',
    :validations => {predefined: "username"}

attribute "repository/git_archive_bundle/@/credential",
    :display_name => "Credential to private repo",
    :description => 'Credential to authenticate with remote private repo',
    :field_type => 'textarea',
    :validations => {predefined: "multiline_text"}

attribute "repository/git_archive_bundle/@/ssh_host_key",
    :display_name => "Remote ssh host key",
    :description => 'Remote ssh host key to host key verification',
    :validations => {predefined: "text"}

# remote file

# attribute "repository/remote_file/@/unpack_file",
#     :display_name => "Unpack tar file?",
#     :description => "Must be tar file unpacked?"
