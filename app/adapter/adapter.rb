module Adapter
  class EventBriteAdapter
    include HTTParty

    EB_TOKEN = ENV['EB_TOKEN']
    base_uri "https://eventbriteapi.com/v3/events/"
    headers Authorization: "Bearer #{EB_TOKEN}"

    def generate_itinenary(keyword, location, start_date, end_date, events_per_day = 2)
      days = days_difference(start_date, end_date)
      itinerary = []
      i = 0
      while i < days_difference
        day = {"day{#{i+1}}": one_day(keyword, location, start_date, events_per_day)}
        itinerary << day
        i += 1
      end
      itinerary
    end

    def one_day(keyword, location, start_date, events_per_day)
      day = []
      start_time = start_date.midnight
      while day.length < events_per_day
        event = random_event(keyword, location, start_time)
        day << random_event
        start_time = event.start_time.to_datetime + 1.hour
      end
      day
    end

    def random_event(keyword, location, start_date = DateTime.now)
      event = HTTParty.get('search', query: {
                                       q: keyword,
                                       "location.address".to_sym => location,
                                       "start_date.range_start".to_sym => start_date.to_s[0..-7],
                                       "start_date.range_end".to_sym => (start_date + 1.day.midnight).to_s[0..-7] })["events"].sample
      return parse_event_details(event)
    end

    private

    def parse_event_details(event)
      id = event["id"]
      details = { name: event["name"],
                  url: event["url"],
                  start_time: event["start"]["local"].strftime("%I:%M:%S %p"),
                  end_time: event["end"]["local"].strftime("%I:%M:%S %p"),
                  price: ticket_price(id.to_i),
                  }
    end

    def ticket_price(event_id)
      # finds the first (cheapest) ticket class that is available for purchase
      ticket_info = HTTParty.get("#{event_id}/ticket_classes")["ticket_classes"].find { |ticket_class| ticket_class["on_sale_status"] == "AVAILABLE" }
      price = 0
      if ticket_info["free"] # checks for presence of "free" key
        return price
      else
        cost = ticket_info["cost"]["display"]
        fee = ticket_info["fee"]["display"]
        price = cost + fee
      end
      return price
    end

    def days_difference(start_date, end_date)
      return (end_date - start_date).to_i
    end


  end
end
