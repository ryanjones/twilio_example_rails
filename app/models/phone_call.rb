require 'twilio-ruby'
require 'logger'

class PhoneCall < Object

  attr_accessor :phone_number, :twilio_number, :capability_token

  def initialize(attributes = nil)
    @phone_number = attributes[:phone_number] unless attributes.nil?
    @twilio_number = attributes[:twilio_number] unless attributes.nil?
    
    @account_sid = 'AC93c2fb02b30b4519a375123963434361'
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
    
    # Setup capability token
    gen_capability_token
  end

private 

  def my_twilio_numbers
    numbers = @client.account.incoming_phone_numbers.list
  end
  
  def gen_capability_token
    # Create capability token class
    capability = Twilio::Util::Capability.new(@account_sid, @auth_token)
    
    # Enable outgoing calls in our app (NOT our account, note the AP in this ID)
    capability.allow_client_outgoing 'AP1b66ab4d812f4ac1b48fb4de24cc626b'
    
    # allow incoming calls to user RyanonRails
    capability.allow_client_incoming 'RyanonRails'
   
    # generate the token string
    @capability_token = capability.generate
  end

end
