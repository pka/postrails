class TablesController < ApplicationController
  active_scaffold :application #Warning: called each time in DEV env.
  layout "database"

  before_filter :authenticate
  before_filter :refresh_scaffold

  protected

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      config = ActiveRecord::Base.connection.instance_eval { @config }
      if username != config[:user] || !Application.connected?
        logger.debug "Connect as user: #{username}"
        Application.establish_connection(config.merge(:username => username, :password => password))
        Application.connection.execute("SELECT now()") rescue nil #force connection
      end
      Application.connected?
    end
  end

  def refresh_scaffold
    #session[:table] ||= params[:table]
    #@table = session[:table]
    @table = params[:table]
    if @table
      logger.debug "refresh_scaffold to #{@table}"
      params[:table] = nil
      Table.change_table(@table)
      self.class.instance_eval {
        active_scaffold(:table)
      }
      handle_user_settings
      active_scaffold_config.label = @table
    end
  end

end
