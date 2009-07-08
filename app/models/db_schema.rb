class DbSchema < ActiveRecord::Base
  set_table_name "pg_namespace"
  set_primary_key "oid"
  belongs_to :owner, :class_name => 'Role', :foreign_key => 'nspowner', :readonly => true
end
