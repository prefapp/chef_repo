module UserHelper
	def generate_password_hash(pass)
		cmd = Mixlib::ShellOut.new("openssl passwd -1 #{pass}")
		pass_hash = cmd.run_command.stdout.chomp
	end
end