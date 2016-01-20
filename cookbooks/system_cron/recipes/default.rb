include_recipe "cron::default"


if node["riyic"]["dockerized"] == "yes"

    # queremos controlalo con supervisor
    srv = resources(service: "cron")
    # srv.provider Chef::Provider::Service::Upstart
    srv.start_command "/bin/true"
    srv.stop_command "/bin/true"
    srv.restart_command "/bin/true"
    srv.action :nothing

    include_recipe "pcs_supervisor::default"

    supervisor_service "cron" do        
        stdout_logfile "/var/log/supervisor/cron.log"
        stderr_logfile "/var/log/supervisor/cron.err"
        command "cron -f"
        action "enable"
    end
end
