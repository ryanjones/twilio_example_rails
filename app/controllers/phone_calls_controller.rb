class PhoneCallsController < ApplicationController

  before_filter :authenticate, :only => [:incoming]
  
  def new
    @phone_call = PhoneCall.new
  end
  
  def incoming
    # make sure to know the diff between the number voice URL and the app URL
      render :text => '<?xml version="1.0" encoding="UTF-8" ?>
      <Response>
          <Dial>
              <Client>RyanonRails</Client>
          </Dial>
      </Response>'
  end
  
  def authenticate
    # Twilio security here: http://www.twilio.com/docs/security
    # Just basic authentication for now
    authenticate_or_request_with_http_basic do |username, password|
      username == "twilio" && password == "legit"
    end
  end
  
end