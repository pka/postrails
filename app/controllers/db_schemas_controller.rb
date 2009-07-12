class DbSchemasController < ApplicationController
  active_scaffold do |config|
    config.list.columns = [:nspname, :owner, :nspacl]
    config.actions = [:list]
  end
  layout "databases"
end
