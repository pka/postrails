class DatabasesController < ApplicationController
  active_scaffold do |config|
    config.list.columns = [:datname, :owner, :datacl, :datallowconn, :datconfig, :datconnlimit, :datistemplate]
    #:dattablespace, :encoding
    config.actions = [:list]
  end

  def schema_select
    @database = Database.find_by_name(params[:database_name])
    params[:schema_name] ||= 'public'
    @db_schema = @database.find_schema_by_name(params[:schema_name])
    @tables = @db_schema.tables
    render :partial => 'schema_select'
  end

end
