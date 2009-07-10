require 'systemu'

#Shell command wrapper
#status, output = Shell::run "ls -l"
module Shell

  def run(cmd)
    status, stdout, stderr = systemu "#{cmd} 2>&1"
    [status.to_i, stdout]
  end
  module_function :run

end
