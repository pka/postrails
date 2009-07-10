class DatabasesController < ApplicationController
  active_scaffold do |config|
    config.list.columns = [:datname, :owner, :datacl, :datallowconn, :datconfig, :datconnlimit, :datistemplate]
    #:dattablespace, :encoding
    config.actions = [:list]
  end

  def refresh_tables
    @database = Database.find_by_datname(params[:database_name])
    @tables = @database.tables
    render :partial => 'tables_list'
  end
end
