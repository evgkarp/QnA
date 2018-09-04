class NewAnswerJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    answer.question.subscribers.each do |subscriber|
      NewAnswerMailer.notification(subscriber, answer).try(:deliver_later) unless subscriber.author_of?(answer)
    end
  end
end
