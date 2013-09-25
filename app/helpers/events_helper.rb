module EventsHelper
  def event_show_event_attributes(event)
    res=[]
    event.event_attributes.each do |a|
      res << content_tag(:tr,
                         content_tag(:td,
                                     link_to(a.attribute_label,
                                             event_attributes_path(:attribute_label=>a.attribute_label))) +
                         content_tag(:td, a.content))
    end
    content_tag(:table, res.join.html_safe)
  end

  def event_show_event(event)
    orari,info=event.split_extra_description
    altre_info=[]
    orari.each do |o|
      altre_info << o.to_s
    end
    
    lnk="SEDE: #{link_to(event.venue.name, venue_path(event.venue))}"
    content_tag(:h1, "#{event.title} [#{event.fonte_dati} (#{event.excel_source})]") +
      content_tag(:h2, event.description) +
      content_tag(:pre, altre_info.join("\n")) +
      content_tag(:h2, lnk.html_safe)
    
  end

end
