class VenuesController < ApplicationController
  def index
    es=params[:es]
    if es.class==Array and es.size>0
      sql=%Q{select v.id,v.name,count(*) from venues v join events e on(e.venue_id=v.id) join excel_sheets x on(e.excel_sheet_id=x.id) where x.id in (#{es.join(',')}) group by v.id,v.name order by v.name;}
    else
      sql=%Q{select v.id,v.name,count(*) from venues v join events e on(e.venue_id=v.id) group by v.id,v.name order by v.name;}
    end
    @venues=Venue.find_by_sql(sql)
  end
  def show
    @venue=Venue.find(params[:id])
    if params[:es].class==Array and params[:es].size>0
      @events=@venue.eventi_in_agenda(params[:es])
    else
      @events=@venue.events.order('title')
    end
  end
end
