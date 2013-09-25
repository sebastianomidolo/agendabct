class ExcelSheet < ActiveRecord::Base
  has_many :events

  def to_label
    "#{anno} (#{title})"
  end
end
