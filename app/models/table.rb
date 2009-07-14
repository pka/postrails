class Table < ActiveRecord::Base
  set_table_name "pg_class"
  set_primary_key 'oid'

  attr_accessor :schema
  attr_accessor :table_name

  def connect_table(database, name)
    @database = database
    @table_name = name
    ar_class
  end

  #Each table record has it's own AR class for scaffolding
  def ar_class
    @ar_class ||= Table.module_eval <<EOS
      class #{ar_class_name} < #{@database.ar_class.name}
        set_table_name '#{@table_name}'
        if column_names.include?('id')
          set_primary_key 'id'
        else
          set_primary_key column_names.first #ActiveScaffold needs primary key
        end
        self
      end
EOS
  end

  def ar_class_name
    @table_name.camelize.singularize #FIXME: unique name not guaranteed
  end

end
