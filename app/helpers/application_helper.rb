# -*- coding: utf-8 -*-
module ApplicationHelper
  def html_title
    es=params[:es]
    if es.class==Array and es.size>0
      r=[]
      ExcelSheet.find(es).each do |s|
        r << s.to_label
      end
      r.join(', ')
    else
      "Agenda iniziative culturali BCT"
    end
  end

  def horizontal_menu
    res=[]
    items=[
           ['/venues?', 'Sedi'],
           ['/event_attributes?attribute_label=destinatari', 'Destinatari'],
           ['/event_attributes?attribute_label=canale_web', 'Canali web'],
           ['/event_attributes?attribute_label=tipologia_attivita', 'Tipologia attività'],
           ['/event_attributes?attribute_label=tematiche', 'Tematiche'],
           ['/event_attributes?attribute_label=collaborazioni', 'Collaborazioni'],
           ['/event_attributes?attribute_label=utenze', 'Utenze'],
           ['/events?', 'Lista eventi'],
          ]

    res << content_tag(:li, link_to('Agende',excel_sheets_url))
    es=params[:es]
    es=es.join(',') if es.class==Array
    limit = es.blank? ? '' : "&es[]=#{es}"
    items.each do |i|
      lnk = limit.blank? ? i[0] : lnk=i[0] + "#{limit}"
      res << content_tag(:li, link_to(i[1],lnk))
    end

    content_tag(:ul, res.join.html_safe)
  end

end
