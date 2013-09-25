class EventAttribute < ActiveRecord::Base
  attr_accessible :content_class, :attribute_label, :content, :event_id
  belongs_to :event

  def EventAttribute.filtra_per_label(label,excel_sheets_ids=nil)
    label=EventAttribute.connection.quote(label)
    join=where=''
    if excel_sheets_ids.class==Array and excel_sheets_ids.size>0
      join="join events e on(e.id=ea.event_id) join excel_sheets s on(e.excel_sheet_id=s.id)"
      where="s.id in (#{excel_sheets_ids.join(',')}) and"
    end
    sql=%Q{select attribute_label,content,count(*) from event_attributes ea
       #{join}
       where #{where} attribute_label = #{label}
        group by attribute_label,content order by lower(content)}
    EventAttribute.find_by_sql(sql)
  end
end
