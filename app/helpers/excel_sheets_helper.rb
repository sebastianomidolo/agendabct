module ExcelSheetsHelper
  def excel_sheets_index(fe)
    res=[]
    fe.each do |f|
      res << content_tag(:tr,
                         content_tag(:td, f.anno) +
                         content_tag(:td, f.title) +
                         content_tag(:td, link_to(f.filename, venues_path(:es=>[f.id]))))
    end
    content_tag(:table, res.join.html_safe)
  end
end
