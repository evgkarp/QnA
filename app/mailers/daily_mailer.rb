class DailyMailer < ApplicationMailer
  def digest(user, questions)
    @greeting = "Hi, #{user.email}!"
    @questions = questions
    mail to: user.email
  end
end
