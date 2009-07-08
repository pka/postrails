class DatabaseController < ApplicationController
  active_scaffold :post

  def refresh_tables
    @database = Database.find_by_datname(params[:database_name])
    @tables = @database.tables
    render :partial => 'tables_list'
  end

end
