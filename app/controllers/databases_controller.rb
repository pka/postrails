class DatabasesController < ApplicationController
  active_scaffold do |config|
    config.list.columns = [:datname, :owner, :datacl, :datallowconn, :datconfig, :datconnlimit, :datistemplate]
    #:dattablespace, :encoding
    config.actions = [:list]
  end

  def schema_select
    db_schema_tables_select
    render :partial => 'schema_select'
  end

end
