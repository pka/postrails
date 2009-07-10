class Table < ActiveRecord::Base
  set_table_name "applications"

  def self.change_table(name)
#    @ar_class ||= Class.new(ActiveRecord::Base) do
#       set_table_name name
#       set_primary_key 'id'
#    end
    set_table_name name
    reset_column_information
  end

end
