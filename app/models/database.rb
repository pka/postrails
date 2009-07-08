class Database < ActiveRecord::Base
  set_table_name "pg_database"
  set_primary_key "oid"
  belongs_to :owner, :class_name => 'Role', :foreign_key => 'datdba', :readonly => true

  def db_connection
    connection #FIXME
  end

  #Return table names
  def tables
    db_connection.tables
  end

end
