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
        start_date += 1.day
      end
      itinerary
    end

    def one_day(keyword, location, start_date, daily_events = 2)
      day = []
      # TODO: implement optional value to change start time 
      current_time = start_date.midnight + 8.hour # initial value is events starting at 8 AM
      increment = 16.0 / daily_events # time window of search shrinks with more daily events
      while day.length < events_per_day && !next_day?(start_date, current_time)
        random_event = random_event(keyword, location, current_time, current_time + increment.hours)
        day << random_event
        time = event[:end_time].to_datetime + 1.hour # give minimum one hour between events
      end
      day
    end

    def random_event(keyword, location, start_date = DateTime.now, end_date = next_midnight(start_date))
      event = HTTParty.get('/search', query: {
                                       q: keyword,
                                       "location.address".to_sym => location,
                                       "start_date.range_start".to_sym => start_date.to_s[0..-7],
                                       "start_date.range_end".to_sym => end_date.to_s[0..-7] })["events"].sample
      parse_event_details(event)
    end

    private

    def next_midnight(date) # advances the date to the next closest midnight
      (date+1.day).midnight
    end

    def parse_event_details(event)
      id = event["id"]
      details = { name: event["name"]["text"],
                  url: event["url"],
                  start_time: event["start"]["local"].to_datetime,
                  end_time: event["end"]["local"].to_datetime,
                  price: ticket_price(id.to_i),
                  }
    end

    def ticket_price(event_id)
      # finds the first (cheapest) ticket class that is available for purchase
      ticket_info = HTTParty.get("/#{event_id}/ticket_classes")["ticket_classes"].find { |ticket_class| ticket_class["on_sale_status"] == "AVAILABLE" }
      price = 0
      if !ticket_info || ticket_info["free"] # if ticket info does not exist, or if there exists a "free" key within ticket info response
        return price
      else
        cost = ticket_info["cost"]["major_value"].to_f
        fee = ticket_info["fee"]["major_value"].to_f
        price = cost + fee
      end
      return price
    end

    def next_day?(start_date, current_date)
      return current_date.day > start_date.day || current_date.month > start_date.month || current_date.year > start_date.year
    end

    def days_difference(start_date, end_date)
      return (end_date - start_date).to_i
    end

  end
end
