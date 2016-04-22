# default recipe
# create system users with no shell
include_recipe "system_user::with_bash"
include_recipe "system_user::without_shell"
include_recipe "system_user::with_lshell"


