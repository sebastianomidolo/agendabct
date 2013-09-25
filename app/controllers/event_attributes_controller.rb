class EventAttributesController < ApplicationController
  def index
    @event_attributes=EventAttribute.filtra_per_label(params[:attribute_label], params[:es])
  end
end
