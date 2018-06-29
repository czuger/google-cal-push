require_relative 'google_cal'
require 'pp'

class Odyssee
end

gc = GoogleCal.new

# Fetch the next 10 events for the user
calendar_id = 'primary'
response = gc.service.list_events(calendar_id,
                               max_results: 10,
                               single_events: true,
                               order_by: 'startTime',
                               time_min: Time.now.iso8601)
puts 'Upcoming events:'
puts 'No upcoming events found' if response.items.empty?
response.items.each do |event|
  start = event.start.date || event.start.date_time
  puts "- #{event.summary} (#{start})"
end

# This is the list of bases methods for calendars https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/CalendarV3/CalendarService

# pp gc.service.list_calendar_lists

p gc.private_calendar_id

pp gc.service.get_calendar( gc.private_calendar_id )