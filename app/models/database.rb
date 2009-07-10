class Database < ActiveRecord::Base
  set_table_name "pg_database"
  set_primary_key "datdba"
  belongs_to :owner, :class_name => 'Role', :foreign_key => 'datdba', :readonly => true

  def db_connection
    config = self.connection.instance_eval { @config }
    #unless @db_connection
      #ActiveRecord::Base.connection_handler.remove_connection(self.class)
      ActiveRecord::Base.establish_connection(config.merge('database' => datname, 'schema_search_path' => 'public'))
      @db_connection = ActiveRecord::Base.connection
      logger.debug "Connection established #{@db_connection.instance_eval{ @config }.inspect}"
    #end
    @db_connection
  end

  #Return table names
  def tables
    db_connection.tables
  end

end
