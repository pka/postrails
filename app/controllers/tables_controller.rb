class TablesController < ApplicationController
  active_scaffold :application #Warning: called each time in DEV env.
  layout "databases"

  before_filter :refresh_scaffold

  protected

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
