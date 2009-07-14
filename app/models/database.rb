class Database < ActiveRecord::Base
  set_table_name "pg_database"
  set_primary_key "datdba"

  belongs_to :owner, :class_name => 'Role', :foreign_key => 'datdba', :readonly => true

  default_scope :order => 'datname'

  def self.find_by_name(db_name)
    find_by_datname(db_name)
  end

  def name
    datname
  end

  def schemas
    schema = DbSchema.new(:database => self)
    schema.ar_class.all
  end

  def db_connection
    ar_class.connection
  end

  #Return table names
  def tables
    db_connection.tables.sort
  end

  #Each database record has it's own AR class with a connection
  def ar_class
    if Database.const_defined?(ar_class_name)
      "Database::#{ar_class_name}".constantize
    else
      Database.module_eval <<EOS
        class #{ar_class_name} < ActiveRecord::Base

          def self.db_config
            config = ActiveRecord::Base.connection.instance_eval { @config }
            config.merge('database' => '#{name}', :pool => 1)
          end

          establish_connection(db_config)

          self
        end
EOS
    end
  end

  private

  def ar_class_name
    "Dbconn_#{name}"
  end

end
