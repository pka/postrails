class Table < ActiveRecord::Base
  set_table_name "pg_roles"
  set_primary_key 'oid'

  attr_accessor :table_name

  def connect_table(name)
    @table_name = name
    @database = ActiveRecord::Base.connection.instance_eval { @config }[:database] #FIXME
    ar_class
  end

  #Each table record has it's own AR class for scaffolding
  def ar_class
    @ar_class ||= TableObject.module_eval <<EOS
      class #{ar_class_name} < ActiveRecord::Base #FIXME: inherit from database class -> share database connection
        set_table_name '#{@table_name}'

        def self.db_config
          config = ActiveRecord::Base.connection.instance_eval { @config }
          config.merge('database' => '#{@database}', :pool => 1)
        end

        establish_connection(db_config)

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

