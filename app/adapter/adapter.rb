module Adapter
  class EventBriteAdapter
 +  include HTTParty
 +
 +  EB_TOKEN = ENV['EB_TOKEN']
 +  base_uri "eventbriteapi.com/v3/events/"
 +
 +  def event_search(keyword, location, start_date = DateTime.now.midnight)
 +    HTTParty.get('search', query: { token: "#{EB_TOKEN}",
                            q: keyword,
 +                          "location.address".to_sym => location,
 +                          "start_date.range_start".to_sym => start_date.to_s[0..-7],
 +                          "start_date.range_end".to_sym => (start_date + 1.day).to_s[0..-7] })["events"][0..9]
 +  end

    def price(event_id)
      # finds the first (cheapest) ticket class that is available for purchase
      HTTParty.get("#{event_id}/ticket_classes")["ticket_classes"].find { |ticket_class| ticket_class["on_sale_status"] == "AVAILABLE" }
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
