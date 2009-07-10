module ApplicationsHelper
 def name_column(record)
   if record.running?
     link_to(h(record.name), record.url('localhost'), :target => h(record.name))
   else
     h(record.name)
   end
  end

 def tables_form_column(record, input_name)
   select(:record, :tables, record.connection.tables, {}, { :size => 4, :multiple => 'multiple' })
 end

end
