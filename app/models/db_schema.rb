class DbSchema < ActiveRecord::Base
  set_table_name "pg_namespace"
  set_primary_key "nspname"

  attr_accessor :database

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

          self
        end
EOS
    end
  end

  private

  def ar_class_name
    "Schema_#{@database.name}"
  end

end
