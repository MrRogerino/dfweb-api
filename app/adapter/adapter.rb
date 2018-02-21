module Adapter
  class EventBriteAdapter
 +  include HTTParty
 +
 +  EB_TOKEN = ENV['EB_TOKEN']
 +  base_uri "eventbriteapi.com/v3/events/"
 +
 +  def event_search(keyword, location, start_date = DateTime.now.midnight)
 +    @events = HTTParty.get('search', query: { token: "#{EB_TOKEN}",
                            q: keyword,
 +                          "location.address".to_sym => location,
 +                          "start_date.range_start".to_sym => start_date.to_s[0..-7],
 +                          "start_date.range_end".to_sym => (start_date + 1.day).to_s[0..-7] })["events"]
 +  end

    private
    
    def parse_event_details(event)
      id = event["id"]
      details = { name: event["name"],
                  url: event["url"],
                  start_time: event["start"]["local"].strftime("%I:%M:%S %p"),
                  end_time: event["end"]["local"].strftime("%I:%M:%S %p"),
                  price: price(id.to_i),
                  }

    def price(event_id)
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
end
