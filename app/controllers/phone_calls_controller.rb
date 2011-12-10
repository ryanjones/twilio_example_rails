class PhoneCallsController < ApplicationController
  
  def new
    @phone_call = PhoneCall.new
  end
  
  def incoming
    num = params[:PhoneNumber]
    
    if num.is_a?(Numeric)
      # dialing via number!
      # build up a response
      response = Twilio::TwiML::Response.new do |r|
        r.Dial :callerId => '+13852186888' do |d|
          d.Number num
        end
      end
    elsif
      # dialing via name!
      # build up a response
      response = Twilio::TwiML::Response.new do |r|
        r.Dial :callerId => '+13852186888' do |d|
          d.Client num
        end
      end
    end
    Rails.logger.debug "Reponse " + response.text
    
    render :text => response.text
    # make sure to know the diff between the number voice URL = used for incoming 
    # app voice url = used for from browser
    # (from what i can tell)
  end
  
end