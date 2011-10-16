require 'twilio-ruby'
require 'logger'

class SmsMessage < Object

  attr_accessor :phone_number, :content, :twilio_number, :available_numbers

  def initialize(attributes = nil)
    @phone_number = attributes[:phone_number] unless attributes.nil?
    @content = attributes[:content] unless attributes.nil?
    @twilio_number = attributes[:twilio_number] unless attributes.nil?
    
    @account_sid = 'AC93c2fb02b30b4519a375123963434361 '
    @auth_token = '5009e2c4fd8882407a4f0231f382d8db'
    
    # Get the number from twilio if the twilio number isn't passed in
    unless(@twilio_number)
      # Build the twilio client
      @client = Twilio::REST::Client.new(@account_sid, @auth_token)
    
      # Get list of numbers
      twilio_numbers_list = my_twilio_numbers
      
      # grab the first number in the list
      if (twilio_numbers_list[0] == nil)
        # You don't have a twilio number! Using the sandbox number
        # make sure to verify the number you're sending to
        @twilio_number = '+14155992671'
      else
        # Grab the first number in the list
        @twilio_number = twilio_numbers_list[0].phone_number
      end
      
    end
  end

  def send_msg
    # Send out a message
    @client.account.sms.messages.create(
      :from => @twilio_number,
      :to => "+1#{@phone_number}",
      :body => @content
    )
  end

  def my_twilio_numbers
    numbers = @client.account.incoming_phone_numbers.list
  end

end
