# Preview all emails at http://localhost:3000/rails/mailers/new_answer_mailer
class NewAnswerMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/new_answer_mailer/notification
  def notification
    NewAnswerMailerMailer.notification
  end

end
