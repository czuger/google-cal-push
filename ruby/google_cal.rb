require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

class GoogleCal

  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
  APPLICATION_NAME = 'Google Calendar API Ruby Quickstart'.freeze
  CLIENT_SECRETS_PATH = 'data/client_secrets.json'.freeze
  CREDENTIALS_PATH = 'data/token.yaml'.freeze
  SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR
  PRIVATE_CALENDAR_PATH = 'data/calendar_id.txt'

  attr_reader :service, :private_calendar_id

  def initialize
    # Initialize the API
    @service = Google::Apis::CalendarV3::CalendarService.new
    @service.client_options.application_name = APPLICATION_NAME
    @service.authorization = authorize

    @private_calendar_id = File.read( PRIVATE_CALENDAR_PATH )
  end

  def insert_event_into_private_calendar( title, summary, start_time, end_time )
    start = start_time.to_datetime.rfc3339
    end_t = end_time.to_datetime.rfc3339

    start_google_format = Google::Apis::CalendarV3::EventDateTime.new( date_time: start )
    end_google_format = Google::Apis::CalendarV3::EventDateTime.new( date_time: end_t )

    event = Google::Apis::CalendarV3::Event.new( summary: title, description: summary,
                                                 start: start_google_format, end: end_google_format )

    @service.insert_event( @private_calendar_id, event )
  end

  private
  ##
  # Ensure valid credentials, either by restoring from the saved credentials
  # files or intitiating an OAuth2 authorization. If authorization is required,
  # the user's default browser will be launched to approve the request.
  #
  # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
  def authorize
    client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
    user_id = 'default'

    credentials = authorizer.get_credentials(user_id)

    if credentials.nil?
      url = authorizer.get_authorization_url(base_url: OOB_URI)
      puts 'Open the following URL in the browser and enter the ' \
         "resulting code after authorization:\n" + url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id, code: code, base_url: OOB_URI
      )
    end

    credentials
  end

end