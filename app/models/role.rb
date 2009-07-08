class Role < ActiveRecord::Base
  set_table_name "pg_roles"
  set_primary_key "oid"
  has_many :databases, :foreign_key => 'datdba', :readonly => true
  has_many :db_schemas, :foreign_key => 'nspowner', :readonly => true
end
