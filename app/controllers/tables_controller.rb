class TablesController < ApplicationController
  active_scaffold #Warning: called each time in DEV env.
  layout "database"

  before_filter :authenticate
  before_filter :refresh_scaffold

  protected

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      config = ActiveRecord::Base.connection.instance_eval { @config }
      if username != config[:user] || !Post.connected?
        logger.debug "Connect as user: #{username}"
        Post.establish_connection(config.merge(:username => username, :password => password))
        Post.connection.execute("SELECT now()") rescue nil #force connection
      end
      Post.connected?
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
