class Table < ActiveRecord::Base
  set_table_name "pg_class"
  set_primary_key 'oid'

  attr_accessor :table_name

  def connect_table(database, name)
    @database = database
    @table_name = name
    ar_class
  end

  #Each table record has it's own AR class for scaffolding
  def ar_class
    @ar_class ||= TableObject.module_eval <<EOS
      class #{ar_class_name} < #{@database.ar_class.name}
        set_table_name '#{@table_name}'
        set_primary_key 'id' #FIXME
        self
      end
EOS
  end

  def ar_class_name
    @table_name.camelize.singularize #FIXME: unique name not guaranteed
  end

end

#Namespace for dynamic table classes
module TableObject
end

