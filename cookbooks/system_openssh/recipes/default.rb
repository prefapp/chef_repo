include_recipe "openssh::default"

if node["riyic"]["dockerized"] == "yes"

    # queremos controlalo con supervisor
    srv = resources(service: "ssh")
    # srv.provider Chef::Provider::Service::Upstart
    srv.start_command "/bin/true"
    srv.stop_command "/bin/true"
    srv.restart_command "/bin/true"
    srv.action :nothing

    # creamos a carpeta /var/run/sshd
    directory "/var/run/sshd" do
      owner "root"
      group "root"
      mode 0755
      action :create
    end

    include_recipe "pcs_supervisor::default"

    supervisor_service "ssh" do        
        stdout_logfile "/var/log/supervisor/ssh.log"
        stderr_logfile "/var/log/supervisor/ssh.err"
        command "/usr/sbin/sshd -D"
        action "enable"
    end
end
