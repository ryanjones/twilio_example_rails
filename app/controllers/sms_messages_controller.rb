class SmsMessagesController < ApplicationController

  before_filter :authenticate, :only => [:incoming, :status]

  def new
    @sms_message = SmsMessage.new
  end

  def create
    if params['commit'] == 'Submit Message'
       # Create sms_message
       sms_message = SmsMessage.new(params[:sms_message])
       
       # Send the Request via gem
       sms_message.send_msg
    end
    
    # Go back to send another message
    render :action => :new
  end
  
  def incoming
    # Receive a message from the user!
    message = params[:Body]
    from_number = params[:From].to_s.sub('+1', '')
    
    # Check if the message contains a specific word
    if /waffles/i.match(message)
      # Create sms_message
      sms_message = SmsMessage.new({ :phone_number => params[:From].to_s.sub('+1', ''),
                                      :content => 'I heard you like waffles...'})
                                      
      # Reply to waffles
      sms_message.send_msg
      
      # Render an empty Response
      render :text => '<?xml version="1.0" encoding="UTF-8"?><Response></Response>'
    elsif /ninja/i.match(message)
      # Reply to Ninja by building the Repsonse via xml
      render :text => '<?xml version="1.0" encoding="UTF-8"?>
                       <Response>
                        <Sms>Ninja attack!</Sms>
                       </Response>'
    end
  end
  
  def status
    
  end

  def authenticate
    # Twilio security here: http://www.twilio.com/docs/security
    # Just basic authentication for now
    authenticate_or_request_with_http_basic do |username, password|
      username == "twilio" && password == "legit"
    end
  end

end
