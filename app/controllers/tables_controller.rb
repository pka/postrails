class TablesController < ApplicationController
  active_scaffold :application #Create actions. Note: called each time in DEV env.
  layout "databases"

  before_filter :refresh_scaffold

  protected

  def refresh_scaffold
    session[:table] = params[:table] if params[:table]
    unless @table
      @table = session[:table]
      logger.debug "refresh_scaffold to #{@table}"
      table_name = Table.new.connect_table(@table).name
      self.class.instance_eval <<EOS
        active_scaffold('#{table_name}') do |config|
          config.label = '#{@table}'
        end
EOS
      handle_user_settings
    end
  end

end
