class EventController < ApplicationController
  def welcome
    render json: {instructions: "Welcome to the DFW API. Please reference the documentation found here: PLACEHOLDER, to help you make a decision on what fun events are in your area!"}.as_json
  end
end
