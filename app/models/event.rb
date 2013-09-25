class Event < ActiveRecord::Base
  attr_accessible :title, :description
  belongs_to :venue
  belongs_to :excel_sheet
  has_many :event_attributes

  def fonte_dati
    "#{self.excel_sheet.anno} #{self.excel_sheet.title}"
  end

  def split_extra_description
    return [] if self.extra_description.blank?
    d=[]
    i=[]
    self.extra_description.split("\n").each do |l|
      begin
        d << l.to_time
      rescue
        i << l
      end
    end
    [d,i.join("\n")]
  end
end
