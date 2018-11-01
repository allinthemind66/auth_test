
# The simple command gem is an easy way to create services.
# Its role is similar to the role of a helper, but it instead
# facilitates the connection between the controller and the model,
# rather than the controller and the view.
# In this way, we can shorten the code in the models and controllers.


# the alias methods of the simple_command can be easily used in a class
# by writing prepend SimpleCommand.
class AuthenticateUser
  prepend SimpleCommand

  def initialize(email, password)
    #this is where parameters are taken when the command is called
    @email = email
    @password = password
  end

  def call

    #this is where the result gets returned
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  attr_accessor :email, :password

  def user
    user = User.find_by_email(email)
    return user if user && user.authenticate(password)

    errors.add :user_authentication, 'invalid credentials'
    nil
  end
end
