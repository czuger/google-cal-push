require_relative 'google_cal'
require 'pp'

# This is the list of bases methods for calendars https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/CalendarV3/CalendarService

gc = GoogleCal.new

hours = []
title = nil
summary = nil
duration = nil

File.open( 'input.txt', 'r' ).readlines.each_with_index do |line, index|

  if index == 0
    title = line
  elsif index == 1
    summary = line
  elsif index == 2
    match_duration = line.match( /(\d+)[H|h](\d+)/ )
    duration = match_duration[1].to_i*60*60 + (20+match_duration[2].to_i)*60
  else
    line.split( ';' ).each do |hour|

      pp hour
      h_match = hour.match( /(\d+)\/(\d+) : ?(\d+)[H|h](\d+)/ )
      pp h_match
      h_ruby = Time.new( Time.now.year, h_match[2].to_i, h_match[1].to_i, h_match[3].to_i, h_match[4].to_i ).localtime
      next if h_ruby.hour >= 22

      hours << h_ruby - 10*60
    end
  end
end

hours.each do |hour|
  puts title, summary, hour, hour + duration
  puts
  gc.insert_event_into_private_calendar( title, summary, hour, hour + duration )
end