# Down For Whatever API

The Down For Whatever API is designed to help eliminate indecisiveness, while still giving users freedom to explore their interests.

## Documentation

* [Event of the Day](#whatever)
* [Itinerary](#itinerary)
* [Tasklist](#todo)

### Whatever

Not sure what to do for tonight? Just say you're down for whatever.
```
GET dfweb-api.herokuapp.com/whatever
```

Parameters:

|  Attributes   |  Type   |  Required  |  Description                                 |
|---------------|---------|------------|----------------------------------------------|
|  q            | string  |    no      |  Returns events matching the given keyword   |
|  location     | string  |    yes     |  Returns events near a matching address      |
|  start_time   | datetime|    no      |  Look for events that start past a certain time (defaults to current time) |

#### Example Response 

```json
// https://dfweb-api.herokuapp.com/whatever?q=music&location=SF
{
    "random_event": {
        "name": "The Infinite Wrench",
        "url": "https://www.eventbrite.com/e/the-infinite-wrench-tickets-42717662679?aff=ebapi",
        "start_time": "2018-02-23T21:30:00.000+00:00",
        "end_time": "2018-02-23T23:00:00.000+00:00",
        "price": 18
    }
}
```
### Itinerary

Traveling to foreign places for a few days? Quickly plan a list of activities before you go! Returns a collection of events for each day of your itinerary. Each day's events are sorted in chronological order by start time, with a minimum one hour interval between each event to account for travel time.
```
GET dfweb-api.herokuapp.com/itinerary
```
Parameters:

|  Attributes   |  Type   |  Required  |  Description                                 |
|---------------|---------|------------|----------------------------------------------|
|    q          | string  |    no      |  Returns events matching the given keyword   |
|  location     | string  |    yes     |  Returns events near a matching address      |
|  start_date   | datetime|    yes      |  The first day of your itinerary |
| end_date |  datetime | yes | The last day of your itinerary |
| daily_limit | integer | no | The maximum amount of events per day of your itinerary (default: 2) |

#### Example Response

```json
// https://dfweb-api.herokuapp.com/itinerary?q=music&location=New%20York&start_date=2018-02-23T04:54:26&end_date=2018-02-25T04:54:26
{
    "itinerary": [
        {
            "date": "2018-02-23",
            "events": [
                {
                    "name": "NYC Kids Learning and Fun Tour",
                    "url": "https://www.eventbrite.com/e/nyc-kids-learning-and-fun-tour-tickets-39797278732?aff=ebapi",
                    "start_time": "2018-02-23T10:00:00.000+00:00",
                    "end_time": "2018-02-26T13:00:00.000+00:00",
                    "price": "Tickets unavailable"
                },
                {
                    "name": "Good Life After Work Friday's at Jimmy's NYC",
                    "url": "https://www.eventbrite.com/e/good-life-after-work-fridays-at-jimmys-nyc-tickets-42261402994?aff=ebapi",
                    "start_time": "2018-02-23T16:00:00.000+00:00",
                    "end_time": "2018-02-23T23:00:00.000+00:00",
                    "price": 0
                }
            ]
        },
        ...
        {
            "date": "2018-02-25",
            "events": [
                {
                    "name": "Wellness & Organic Wine Tasting",
                    "url": "https://www.eventbrite.com/e/wellness-organic-wine-tasting-tickets-42969148881?aff=ebapi",
                    "start_time": "2018-02-25T13:00:00.000+00:00",
                    "end_time": "2018-02-25T15:00:00.000+00:00",
                    "price": 28.45
                },
                {
                    "name": "The Industry Brunch ft. Media & TV Host Mouse Jones",
                    "url": "https://www.eventbrite.com/e/the-industry-brunch-ft-media-tv-host-mouse-jones-tickets-42586890536?aff=ebapi",
                    "start_time": "2018-02-25T14:00:00.000+00:00",
                    "end_time": "2018-02-25T17:00:00.000+00:00",
                    "price": 0
                }
            ]
        }
    ]
}
```


### TODO:

- Implement cost feature for trips, to better balance budget
- Create persistent models in ActiveRecord for users to record preferred events
- Clean up EventBriteAdapter (use deserializers and refactor)
- Create test suite
- OAuth and better integration with EventBrite users
- Add example responses to documentation 
