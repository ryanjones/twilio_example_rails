class PhoneCallsController < ApplicationController
  
  def new
    debugger
    if params[:client]
      # Load the client's name or whatever from the and put it as the client name
      @phone_call = PhoneCall.new({:client_name => params[:client]})
      @client = @phone_call.client_name 
    else
      # Load the client's name or whatever from the and put it as the client name
      @phone_call = PhoneCall.new({:client_name => 'NoClient'})
      @client = @phone_call.client_name 
    end
  end
  
  def incoming
    num = params[:PhoneNumber]

    # Check for number
    if /^[\d]+(\.[\d]+){0,1}$/ === num
      # dialing via number!
      # build up a response
      response = Twilio::TwiML::Response.new do |r|
        r.Dial :callerId => '+13852186888' do |d|
          d.Number num
        end
      end
    else
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