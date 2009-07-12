module DbSchemasHelper
  def owner_column(record)
    h(record.owner.rolname)
  end
end
