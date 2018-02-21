class EventController < ApplicationController
  def welcome
    render json: {instructions: "Welcome to the Down For Whatever (DFW) API. Please reference the documentation found here: PLACEHOLDER, to help you make a decision on what fun events are going on in your area!"}
  end

  def whatever
    location = params[:location]
    keyword = params[:q]
    render json: {random_event: eventbrite_adapter.random_event(keyword, location)}
  end

  def itinerary
    location = params[:location]
    keyword = params[:q]
    start_date = params[:start_date]
    end_date = params[:end_date]
    render json: { itinerary: eventbrite_adapter.itinerary(keyword, location, start_date, end_date) }
  end

  def eventbrite_adapter
    Adapter::EventBriteAdapter.new
  end

end
