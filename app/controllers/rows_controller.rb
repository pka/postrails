class RowsController < ApplicationController
  active_scaffold :application #Create actions. Note: called each time in DEV env.
  layout "databases"

  before_filter :set_database
  before_filter :refresh_scaffold

  protected

  def set_database
    @database = Database.find_by_name(params[:database_name])
    if @database
      params[:schema_name] ||= 'public'
      @db_schema = @database.find_schema_by_name(params[:schema_name])
      @tables = @db_schema.tables
    end
  end

  def refresh_scaffold
    unless @table
      #@database = Database.find_by_name(params[:database_name])
      @table = params[:table_name]
      logger.debug "refresh_scaffold to #{@table}"
      table_class = Table.new(:database => @database,
        :schema => params[:schema_name], :table_name => @table).ar_class
      self.class.instance_eval <<EOS
        active_scaffold('#{table_class.name}') do |config|
          config.label = '#{@table}'
        end
EOS
      handle_user_settings
    end
  end

end
