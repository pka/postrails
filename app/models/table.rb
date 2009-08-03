class Table < ActiveRecord::Base
  set_table_name "pg_class"
  set_primary_key 'relname' #active scaffold doesn't support primary_key 'oid'

  #belongs_to :db_schema, :foreign_key => 'relnamespace', :readonly => true

  attr_accessor :database
  attr_accessor :schema
  attr_accessor :table_name

  #Each table record has it's own AR class for scaffolding
  def ar_class
    if Table.const_defined?(ar_class_name)
      "Table::#{ar_class_name}".constantize
    else
      Table.module_eval <<EOS
        class #{ar_class_name} < #{database.ar_class.name}
          self.connection.schema_search_path = '#{schema}'
          set_table_name '#{table_name}'
          if column_names.include?('id')
            set_primary_key 'id'
          else
            set_primary_key column_names.first #ActiveScaffold needs primary key
          end
          self
        end
EOS
    end
  end

  private

  def ar_class_name
    table_name.camelize.singularize #FIXME: unique name not guaranteed
  end

end
