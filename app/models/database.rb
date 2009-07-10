class Database < ActiveRecord::Base
  set_table_name "pg_database"
  set_primary_key "datdba"
  belongs_to :owner, :class_name => 'Role', :foreign_key => 'datdba', :readonly => true

  def db_connection
    ar_class.connection
  end

  #Return table names
  def tables
    db_connection.tables
  end

  private

  #Each database record has it's own AR class with a connection
  def ar_class
    @ar_class ||= DatabaseObject.module_eval <<EOS
      class #{ar_class_name} < ActiveRecord::Base
        set_table_name "pg_database"
        set_primary_key "datdba"

        def self.db_config
          config = ActiveRecord::Base.connection.instance_eval { @config }
          config.merge('database' => '#{datname}', :pool => 1)
        end

        establish_connection(db_config)

        self
      end
EOS
  end

  def ar_class_name
    "Db_#{datname}"
  end

end

#Namespace for dynamic database classes
module DatabaseObject
end
