class DbSchema < ActiveRecord::Base
  set_table_name "pg_namespace"
  set_primary_key "nspname" #real column needed by active scaffold

  has_many :tables, :foreign_key => 'relnamespace', :primary_key => 'oid', :readonly => true

  attr_writer :database

  def self.find_by_name(name)
    find_by_nspname(name)
  end

  def name
    nspname
  end

  def database
    @database ||= connected_database
  end

  # AR class for each database connection
  def ar_class
    if DbSchema.const_defined?(ar_class_name)
      "DbSchema::#{ar_class_name}".constantize
    else
      DbSchema.module_eval <<EOS
        class #{ar_class_name} < #{@database.ar_class.name}
          set_table_name 'pg_namespace'
          set_primary_key 'nspname'
          belongs_to :owner, :class_name => 'Role', :foreign_key => 'nspowner', :readonly => true
          has_many :tables, :readonly => true

          self
        end
EOS
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
