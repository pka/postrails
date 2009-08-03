class DbSchema < ActiveRecord::Base
  set_table_name "pg_namespace"
  set_primary_key "nspname" #active scaffold doesn't support primary_key 'oid'

  TABLES_SQL =
    'SELECT pg_class.*'+
    ' FROM pg_class,pg_namespace'+
    ' WHERE pg_class.relnamespace = pg_namespace.oid'+
    %q< AND relkind='r' AND pg_namespace.nspname='#{nspname}'>

  attr_writer :database

  def database
    @database ||= connected_database
  end

  # AR class for each database connection
  def ar_class
    if DbSchema.const_defined?(ar_class_name)
      "DbSchema::#{ar_class_name}".constantize
    else
      DbSchema.module_eval <<EOS
        class #{ar_class_name} < #{database.ar_class.name}
          set_table_name 'pg_namespace'
          set_primary_key 'nspname'
          belongs_to :owner, :class_name => 'Role', :foreign_key => 'nspowner', :readonly => true

          def self.find_by_name(name)
            find_by_nspname(name)
          end

          def name
            nspname
          end

          self
        end
EOS
        #  has_many :tables, :class_name => '#{tables_class.ar_class_name}', :finder_sql => %q<#{TABLES_SQL}>
    end
  end

  private

  def ar_class_name
    "Schema_#{@database.name}"
  end

  def connected_database
    config = self.class.connection.instance_eval { @config }
    Database.find_by_name(config[:database])
  end

end
