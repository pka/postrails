class Database < ActiveRecord::Base
  set_table_name "pg_database"
  set_primary_key "datdba"

  belongs_to :owner, :class_name => 'Role', :foreign_key => 'datdba', :readonly => true

  default_scope :order => 'datname'

  def self.find_by_name(name)
    find_by_datname(name)
  end

  def find_schema_by_name(name)
    db_schema = schema_class.find_by_nspname(name)
    unless db_schema.respond_to?(:tables)
      #Hackish: has_many :tables relation has to be defined after schema_class instanciation, because
      # tables_class requires the schema name
      tables_class = Table.new(:database => self, :schema => name,
        :table_name => 'pg_class')
      DbSchema.module_eval <<EOS
         class #{schema_class.name} < #{ar_class.name}
           has_many :tables, :class_name => '#{tables_class.ar_class.name}', :finder_sql => %q<#{DbSchema::TABLES_SQL}>
         end
EOS
    end
    db_schema
  end

  def name
    datname
  end

  def schemas
    schema_class.all
  end

  def schema_class
    schema = DbSchema.new(:database => self)
    schema.ar_class
  end

  def db_connection
    ar_class.connection
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
            config.merge(:database => '#{name}', :pool => 1)
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
