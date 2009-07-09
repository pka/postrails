class DatabaseController < ApplicationController
  #active_scaffold :post

  def logout
    @realm = 'Login Required'
    response.headers["Status"] = "Unauthorized"
    response.headers["WWW-Authenticate"] = "Basic realm=\"#{@realm}\""
    render :text => '', :status => 401
  end

  def refresh_tables
    @database = Database.find_by_datname(params[:database_name])
    @tables = @database.tables
    render :partial => 'tables_list'
  end

end
