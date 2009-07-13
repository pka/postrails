class SchemasController < ApplicationController
  active_scaffold :db_schema do |config|
    config.list.columns = [:nspname, :owner, :nspacl]
    config.actions = [:list]
  end
  layout "databases"
end
