class SchemasController < ApplicationController
  active_scaffold :db_schema
  layout "databases"

  before_filter :get_database
  before_filter :refresh_scaffold

  protected

  def get_database
    @database = Database.find_by_name(params[:database_id])
  end

  def refresh_scaffold
    unless @ar_class
      @ar_class = DbSchema.new(:database => @database).ar_class
      self.class.instance_eval <<EOS
        active_scaffold('#{@ar_class.name}') do |config|
          config.list.columns = [:nspname, :owner, :nspacl]
          config.actions = [:list]
        end
EOS
      handle_user_settings
    end
  end

end
