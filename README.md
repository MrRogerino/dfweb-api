# Down For Whatever API

The Down For Whatever API is designed to help eliminate indecisiveness, while still giving users freedom to explore their interests.

## Documentation

* [Event of the Day](#Whatever)
* [Itinerary](#Itinerary)
* [Tasklist](#TODO)

### Whatever

Not sure what to do for tonight? Just say you're down for whatever.
```
GET dfw-eb.herokuapp.com/whatever
```

Parameters:

|  Attributes   |  Type   |  Required  |  Description                                 |
|---------------|---------|------------|----------------------------------------------|
|  keyword      | string  |    no      |  Returns events matching the given keyword   |
|  location     | string  |    yes     |  Returns events near a matching address      |
|  start_time   | datetime|    no      |  Look for events that start past a certain time (defaults to current time) |


### Itinerary

Traveling to foreign places for a few days? Quickly plan a list of activities before you go!
```
GET dfw-eb.herokuapp.com/itinerary
```
Parameters:

|  Attributes   |  Type   |  Required  |  Description                                 |
|---------------|---------|------------|----------------------------------------------|
|  keyword      | string  |    no      |  Returns events matching the given keyword   |
|  location     | string  |    yes     |  Returns events near a matching address      |
|  start_date   | datetime|    yes      |  The first day of your itinerary |
| end_date |  datetime | yes | The last day of your itinerary |
| daily_limit | integer | no | The maximum amount of events per day of your itinerary (default: 2) |

### TODO:

- Implement cost feature for trips, to better balance budget
- Create persistent models in ActiveRecord for users to record preferred events
- Clean up EventBriteAdapter (use deserializers and refactor)
- Create test suite
- OAuth and better integration with EventBrite users
- Add example responses to documentation 
