class NewAnswerMailer < ApplicationMailer
  def notification(user, answer)
    @greeting = "Hi, #{user.email}!"
    @answer = answer
    mail to: user.email
  end
end
