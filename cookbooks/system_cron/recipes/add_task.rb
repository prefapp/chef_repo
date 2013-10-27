i = 0
node["system"]["cron"]["tasks"].each do |task|
    
    cron_d "task_#{i}" do
        minute  task["minute"]
        hour    task["hour"]
        day     task["day"]
        month   task["month"]
        weekday task["weekday"]
        command task["command"]
        user    task["user"]
    end

    i = i + 1

end
