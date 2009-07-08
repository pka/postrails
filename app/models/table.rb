class Table < ActiveRecord::Base
  set_table_name "posts"

  def self.change_table(name)
    set_table_name name
    reset_column_information
  end

end
