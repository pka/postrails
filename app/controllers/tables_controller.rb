class TablesController < ApplicationController
  active_scaffold #Warning: called each time in DEV env.
  layout "database"

  before_filter :refresh_scaffold

  private

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
