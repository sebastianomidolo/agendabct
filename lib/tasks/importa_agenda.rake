# -*- coding: utf-8 -*-
# -*- mode: ruby;-*-
# lastmod 2 settembre 2013

desc 'Importa agenda trimestrale'

SOURCE_SHEETS = [
                 'Centrale',
                 'Bonhoeffer',
                 'Calvino',
                 'Carluccio',
                 'Marchesa',
                 'Cognasso',
                 'Falchera',
                 'Geisser',
                 'Levi',
                 'Mirafiori',
                 'Passerin',
                 'Pavese',
                 'ToCentro',
                 'Amoretti',
                 'D\'Annunzio',
                 'Musicale',
                 'MAUSOLEO'
                ]

XSOURCE_SHEETS = [
                 'Centrale',
                ]

SOURCE_FIELDS = {
  :title       => 42,
  :description => 43,
}

def column_get_value(sheet,column_number,tag)
  sheet.column(column_number)[SOURCE_FIELDS[tag]-1]
end

def sanifica_nome_attributo(s)
  encoding_options = {
    :invalid           => :replace,
    :undef             => :replace,
    :replace           => '',
    :universal_newline => true
  }
  s.encode(Encoding.find('ASCII'), encoding_options).downcase.gsub(/-|\.|'| |\\|\//,'_').squeeze('_').gsub(/_$/,'')
end

def analizza_foglio(foglio,s,excel_sheet)
  # puts "#{foglio}: #{s.last_column} colonne"
  venue=Venue.find_or_create_by_name(foglio)
  label={}
  cnt=0
  s.column(1).each do |t|
    cnt+=1
    next if t.blank?
    label[cnt]=sanifica_nome_attributo(t)
    # puts "#{cnt}: #{t}"
  end

  numero_eventi=0
  col_index={};i=0;('A'..'ZZ').each {|x| i+=1;col_index[i]=x}

  (s.first_row+1..s.last_row).each do |cn|
    event=Event.new(:title=>column_get_value(s,cn,:title))
    # event.excel_source = "#{foglio}-#{format('%2s', col_index[cn]).sub(' ','_')}"
    event.excel_source = "#{foglio}/#{col_index[cn]}"
    event.excel_sheet=excel_sheet

    next if event.title.blank?
    numero_eventi+=1
    if event.title.class==String
      event.title.strip!
    else
      puts "Attenzione: event.title.class #{event.title.class}"
    end
    event.venue=venue
    event.description=column_get_value(s,cn,:description)
    puts %Q{\n---\n#{foglio} => evento numero #{numero_eventi}: "#{event.title}"}
    cnt=0
    extra_description=[]
    event_attributes=[]
    s.column(cn).each do |t|
      cnt+=1
      next if t.blank?
      t.strip! if t.class==String
      if cnt>SOURCE_FIELDS[:description]
        t = t.to_s if t.class==DateTime
        # puts "#{cnt} #{label[cnt]} [#{t.class}] => #{t}" 
        extra_description << t
      end
      if cnt<SOURCE_FIELDS[:title]
        # puts "#{cnt} #{label[cnt]} [#{t.class}] => #{t}" 
        event_attributes << {:content_class=>t.class.to_s, :attribute_label=>label[cnt], :content=>t} if !label[cnt].blank?
      end
    end
    if extra_description.size>0
      event.extra_description=extra_description.join("\n")
    end
    event.save!
    # puts event.inspect
    event_attributes.each do |a|
      a[:event_id]=event.id
      # puts a.inspect
      EventAttribute.create(a)
    end
  end
  numero_eventi
end

def analizza_excel(e, excel_sheet)
  totale=0
  e.sheets.each do |s|
    next if !SOURCE_SHEETS.include?(s)
    totale += analizza_foglio(s,e.sheet(s), excel_sheet)
  end
  puts "\n\n FINE ELABORAZIONE ==> totale eventi: #{totale} <=="
end

def imposta_excel_sheet(filename)
  return nil if (filename =~ /^AGENDA iniziative culturali ((.*)2...)\.xls/).nil?
  # return nil if (filename != "AGENDA iniziative culturali 2010.xls").nil?
  m1,m2,anno=$1.split
  h={
    'gennaio marzo' => [1, 'gen-mar'],
    'aprile giugno' => [2, 'apr-giu'],
    'luglio settembre' => [3, 'lug-set'],
    'ottobre dicembre' => [4, 'ott-dic']
  }
  mesi="#{m1} #{m2}"
  numseq,trimestre=h[mesi]
  puts "anno #{anno} - trimestre: #{trimestre} (numseq #{numseq})"
  return nil if trimestre.nil? or anno.nil?
  return nil if (f=ExcelSheet.find_or_create_by_anno_and_filename(anno, filename)).nil?
  f.numseq=numseq
  f.title=trimestre
  f.save
  f
end

def mainloop(basedir)
  entries=Dir.entries(basedir).delete_if {|z| ['.','..'].include?(z)}.sort
  entries.each do |entry|
    file_or_dir=File.join(basedir,entry)
    if File.directory?(file_or_dir)
      # puts "questa e' una directory: #{file_or_dir}"
      mainloop(file_or_dir)
    else
      # next if (entry =~ /^AGENDA iniziative culturali ((.*)2...)\.xls/).nil?
      next if (excel_sheet=imposta_excel_sheet(entry)).nil?
      # puts "foglio: #{excel_sheet.inspect}"
      puts "entry #{entry}"
      fname=File.join(basedir,entry)
      begin
        e=Roo::Excel.new(fname)
        analizza_excel(e, excel_sheet)
      rescue
        puts "Errore: #{$!}"
        exit
      end
    end
  end
end

task :importa_agenda => :environment do
  mainloop('/home/seb/BCT/wca22014/linux64/BiblAgenda')
end

