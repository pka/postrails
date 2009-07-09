module ApplicationsHelper
 def name_column(record)
    link_to(h(record.name), record.url('localhost'), :target => h(record.name))
  end
end
