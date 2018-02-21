class EventController < ApplicationController
  def welcome
    render json: {instructions: "Welcome to the Down For Whatever (DFW) API. Please reference the documentation found here: PLACEHOLDER, to help you make a decision on what fun events are going on in your area!"}
  end

  def whatever
    location = params[:location]
    keyword = params[:q]
    render json: {random_event: }
  end

  def eventbrite_adapter
    Adapter::EventBriteAdapter.new
  end

end
