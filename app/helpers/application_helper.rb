module ApplicationHelper

 def full_title(page_title)
  base_title = "Faktury"
  if page_title.empty?
    base_title
  else
    "#{page_title} | #{base_title}"
  end
 end


 def bootstrap_class_for flash_type
   case flash_type
   when "success"
       "alert-success" # Green
     when "error"
       "alert-danger" # Red
     when "alert"
       "alert-warning" # Yellow
     when "notice"
       "alert-info" # Blue
     else
       flash_type.to_s
   end
 end

 def sortable(column, title = nil)
   title ||= column.titleize
   css_class = column == sort_column ? "current #{sort_direction}" : nil
   direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
   link_to title, params.merge(:sort => column, :direction => direction, :page => nil), { :class => css_class }
 end

 def link_to_add_invoice_item(name, f, association)
   new_object = f.object.send(association).klass.new
   id = new_object.object_id
   fields = f.fields_for(association, new_object, child_index: id) do |builder|
     render(association.to_s.singularize + "_fields", f: builder)
   end
   link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
 end
end
