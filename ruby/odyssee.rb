require_relative 'google_cal'
require 'pp'

# This is the list of bases methods for calendars https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/CalendarV3/CalendarService

class Odyssee
end

gc = GoogleCal.new

start = ( Time.now + 60 ).to_datetime.rfc3339
end_t = ( Time.now + 120 ).to_datetime.rfc3339

start_google_format = Google::Apis::CalendarV3::EventDateTime.new( date_time: start )
end_google_format = Google::Apis::CalendarV3::EventDateTime.new( date_time: end_t )

event = Google::Apis::CalendarV3::Event.new( summary: 'summary test', description: 'description test',
                                             start: start_google_format, end: end_google_format )

pp gc.service.get_calendar( gc.private_calendar_id )

gc.service.insert_event( gc.private_calendar_id, event )