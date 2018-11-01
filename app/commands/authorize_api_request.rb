# check if a token that's been appended to a request is valid.

class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def call
    user
  end

  private

  attr_reader :headers
# the order is from bottom up


# In the first line, the ||= operator is used to assign @user by assigning "if not nil".
# Basically, if the User.find() returns an empty set or decoded_auth_token returns false,
# @user will be nil.
#
# Moving to the second line, the user method will either return the user or throw an error.
# In Ruby, the last line of the function is implicitly returned, so the command ends up returning
# the user object.
  def user
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
    @user || errors.add(:token, 'Invalid token') && nil
  end


# The previous method in the chain is decoded_auth_token,
# which decodes the token received from http_auth_headerand retrieves the user's ID.
  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end


# The last method in the chain, http_auth_header,
# extracts the token from the authorization header received in the
# initialization of the class
  def http_auth_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    else
      errors.add(:token, 'Missing token')
    end
    nil
  end
end
