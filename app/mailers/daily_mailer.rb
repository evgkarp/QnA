class DailyMailer < ApplicationMailer
  def digest(user)
    @greeting = "Hi, #{user.email}!"
    @questions = Question.last_day
    mail to: user.email
  end
end
