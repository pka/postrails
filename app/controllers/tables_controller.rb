class TablesController < ApplicationController
  active_scaffold :application #Create actions. Note: called each time in DEV env.
  layout "databases"

  before_filter :refresh_scaffold

  protected

  def refresh_scaffold
    session[:database] = params[:database] if params[:database]
    session[:table] = params[:table] if params[:table]
    unless @table
      @database = Database.find_by_datname(session[:database])
      @table = session[:table]
      logger.debug "refresh_scaffold to #{@table}"
      table_class = Table.new.connect_table(@database, @table)
      self.class.instance_eval <<EOS
        active_scaffold('#{table_class.name}') do |config|
          config.label = '#{@table}'
        end
EOS
      handle_user_settings
    end
  end

end
