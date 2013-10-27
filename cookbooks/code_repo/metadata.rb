name             "code_repo"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
version          "0.1.0"
description      "Download source code from different source repo types"

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "default",
    :description => "empty",
    :attributes => []

recipe "git_repo",
    :description => "Download code from a git code repo",
    :attributes => [/^repository\/git\//],
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
    :default => "http://my-repo-url.com",
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


# remote file

# attribute "repository/remote_file/@/unpack_file",
#     :display_name => "Unpack tar file?",
#     :description => "Must be tar file unpacked?"
