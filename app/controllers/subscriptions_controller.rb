class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:create]
  before_action :set_subscribtion, only: [:destroy]

  respond_to :json, :js

  authorize_resource

  def create
    @subscription = current_user.add_subscription(@question)
    respond_with(@subscription, template: 'common/subscribe')
  end

  def destroy
    @question = @subscription.question
    @subscription.destroy if current_user.author_of?(@subscription)
    respond_with(@subscription, template: 'common/subscribe')
  end

  private

  def set_subscribtion
    @subscription = Subscription.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
