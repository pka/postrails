class UsersController < ApplicationController
  active_scaffold :roles do |config|
    config.list.columns = [:rolname, :rolcanlogin, :rolcatupdate, :rolcreatedb, :rolcreaterole, :rolinherit, :rolsuper, :rolvaliduntil, :rolconfig, :rolconnlimit]
    config.actions = [:list]
    #config.actions.exclude :nested
  end

  layout "applications"
end
