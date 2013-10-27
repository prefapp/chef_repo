name             "system_cron"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to manage cron tasks"
version          "0.0.1"

depends "cron"
depends "pcs_supervisor"

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "default",
    description: "Installs cron service",
    attributes: [],
    dependencies: []

recipe "add_task",
    description: "Add cron task",
    attributes: [/.+/],
    stackable: true,
    dependencies: []

## Atributos
attribute "system/cron/tasks/@/minute",
    :display_name => 'Minute',
    :description => 'Minute field in cron task',
    :required => true,
    :default => '*',
    :validations => {regex: /^[*\/\d\-]+$/},
    :advanced => false

attribute "system/cron/tasks/@/hour",
    :display_name => 'Hour',
    :description => 'Hour field in cron task',
    :required => true,
    :default => '*',
    :validations => {regex: /^[*\/\d\-]+$/},
    :advanced => false

attribute "system_cron/tasks/@/day",
    :display_name => 'Day of month',
    :description => 'Day of month field in cron task',
    :required => true,
    :default => '*',
    :validations => {regex: /^[*\/\d\-]+$/},
    :advanced => false


attribute "system_cron/tasks/@/month",
    :display_name => 'Month',
    :description => 'Month field in cron task',
    :required => true,
    :default => '*',
    :validations => {regex: /^[*\/\d\-]+$/},
    :advanced => false

attribute "system_cron/tasks/@/weekday",
    :display_name => 'Weekday',
    :description => 'Weekday in cron task',
    :required => true,
    :default => '*',
    :validations => {regex: /^[*\/\d\-]+$/},
    :advanced => false

attribute "system_cron/tasks/@/command",
    :display_name => 'Command',
    :description => 'Command to launch',
    :required => true,
    :default => 'my task command',
    :validations => {predefined: "unix_command"},
    :advanced => false


attribute "system_cron/tasks/@/user",
    :display_name => 'User',
    :description => 'User who launch the task',
    :default => 'root',
    :validations => {predefined: "username"}

