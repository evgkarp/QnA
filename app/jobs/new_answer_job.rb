class NewAnswerJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    answer.question.subscriptions.includes(:user).each do |subscription|
      NewAnswerMailer.notification(subscription.user, answer).try(:deliver_later) unless subscription.user.author_of?(answer)
    end
  end
end
