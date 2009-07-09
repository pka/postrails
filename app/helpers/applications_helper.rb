module ApplicationsHelper
 def name_column(record)
   if record.running?
     link_to(h(record.name), record.url('localhost'), :target => h(record.name))
   else
     h(record.name)
   end
  end
end
