class SchemasController < ApplicationController
  active_scaffold :db_schema do |config|
    config.list.columns = [:nspname, :owner, :nspacl]
    config.actions = [:list]
  end
  layout "databases"

  before_filter :get_database

  protected

  def get_database
    @database = Database.find_by_datname(params[:database_id])
  end

end
