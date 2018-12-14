require 'jwt'

class ApplicationController < ActionController::API

def get_current_user
  token = request.headers['Authorization']
  decoded_token = decode_token(token)
  puts "heres the token"
  puts token
  puts "heres the decoded token"
  puts decoded_token
  user_id = decoded_token[0]['data']['id']
  puts "user id::::"
  puts user_id
  User.find_by(id: user_id)
end

def issue_token(data)
  JWT.encode({data: data}, secret)
end

def decode_token(token)
  begin
    JWT.decode(token,secret)
  rescue JWT::DecodeError
    [{e:'helep'}]
  end
end

def secret
  "I will fork you up!"
end

end
