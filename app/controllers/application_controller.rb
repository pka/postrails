# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  #helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  include DbAuthentication
  before_filter :authenticate

  private

  def db_schema_tables_select
    if params[:database_name]
      @database = Database.find_by_name(params[:database_name])
      params[:schema_name] ||= 'public'
      @db_schema = @database.find_schema_by_name(params[:schema_name])
      @tables = @db_schema.tables
    end
  end


end
