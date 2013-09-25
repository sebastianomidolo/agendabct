module VenuesHelper
  def venues_index(venues)
    res=[]
    venues.each do |v|
      res << content_tag(:tr,
                         content_tag(:td, link_to(v.name, venue_path(v, :es=>params[:es]))) +
                         content_tag(:td, v.count))
    end
    content_tag(:table, res.join.html_safe)
  end
end
