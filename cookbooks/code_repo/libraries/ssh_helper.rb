module SshHelper
    SSH_KEYFILE = "/tmp/keyfile"
    SSH_WRAPPER = "/tmp/gitssh.sh"

    def create_keyfile(key)
        raise "SSH key can't be blank" unless ssh_key

        Chef::Log.info("Creating tem SSH keyfile")

        ::File.open(SSHKEYFILE,"w") do |file|
            file << key
            file.chmod(0600)
            file.user()
        end
    end

    def delete_keyfile
        ::File.delete(SSHKEYFILE)
    end

    def add_host_key(host_key)
        # Make sure .ssh directory exists.
        host_file_dir = "/root/.ssh"
        ::Dir.mkdir(host_file_dir, 0700) unless ::File.exists?(host_file_dir)
        host_file = "#{host_file_dir}/known_hosts"
        if ::File.exists?(host_file) && ::File.readlines(host_file).grep("#{host_key}\n").any?
          Chef::Log.info("  Skipping key installation. Looks like the key already exists.")
        else
          Chef::Log.info("  Installing ssh host key for root.")
          ::File.open(host_file, "a") do |known_hosts|
            known_hosts << "#{host_key}\n"
            known_hosts.chmod(0600)
          end
        end
    end

    # Create bash script, which will set user defined ssh key required to access to private git source code repositories.
    def create_ssh_wrapper(ssh_key, host_key)
        create_keyfile(ssh_key)

        # add record to /known_hosts file and enable StrictHostKeyChecking
        # if host_key input is set
        if check_host_key.to_s.empty?
          strict_check = "no"
        else
          strict_check = "yes"
          add_host_key(host_key)
        end

        Chef::Log.info("  Creating GIT_SSH environment variable with options: StrictHostKeyChecking=#{strict_check}")
        ::File.open(SSH_WRAPPER, "w") do |sshfile|
            sshfile << "exec ssh -o StrictHostKeyChecking=#{strict_check} -i #{SSH_KEYFILE} \"$@\""
            sshfile.chmod(0777)
        end

        ENV["GIT_SSH"] = SSH_WRAPPER
    end

    # Delete SSH key created by "create" method, after successful pull operation. And clear GIT_SSH.
    def delete_ssh_wrapper
        delete_keyfile
        ::File.delete(SSH_WRAPPER)
        ENV.delete("GIT_SSH")
    end
end
