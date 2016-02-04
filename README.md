# lita-build-notifications

This extension allows you to register for status changes of build events. It furthermore adds a HTTP POST endpoint
to Lita to inform about any build status changes.

## Installation

Add lita-build-notifications to your Lita instance's Gemfile:

``` ruby
gem "lita-build-notifications"
```

## Configuration
not required

## Usage
### Commands
```
build notify <me|room-id> - notify you or the given room on build events
build list receivers      - list all ids of who will be notified
build clear receivers     - remove all receivers of build events
```

### HTTP Endpoints
Post a JSON in the following form to `http://yourlita/build/notify`:
```
{
  "id":"build name or id", 
  "status": "build satatus (e.g. success)"
}
```
