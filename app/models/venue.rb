class Venue < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :events

  def eventi_in_agenda(ids)
    ids=[ids] if ids.class==Fixnum
    return [] if ids.class!=Array and ids.size==0
    sql=%Q{SELECT * from events where venue_id = #{self.id} and excel_sheet_id in (#{ids.join(',')})
            ORDER BY title;}
    Event.find_by_sql(sql)
  end
end
