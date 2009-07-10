class DatabasesController < ApplicationController
  active_scaffold

  def refresh_tables
    @database = Database.find_by_datname(params[:database_name])
    @tables = @database.tables
    render :partial => 'tables_list'
  end
end
