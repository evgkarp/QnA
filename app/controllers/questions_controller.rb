class QuestionsController < ApplicationController
  include Voted

  respond_to :html, :json, :js

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show update destroy]
  before_action :build_answer, only: :show
  before_action :set_subscription, only: :show

  after_action :publish_question, only: [:create]

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    gon.is_user_signed_in = user_signed_in?
    gon.current_user_id = current_user&.id
    gon.question_user_id = @question.user.id
    respond_with @question
  end

  def new
    @question = Question.new
    respond_with(@question.attachments.build)
  end

  def create
    @question = current_user.questions.build(question_params)
    @question.subscriptions.create!(user_id: current_user.id) if @question.save
    respond_with @question
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    @question.destroy if current_user.author_of?(@question)
    respond_with(@question, location: questions_url)
  end

  private

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'common/questions_list',
        locals: { question: @question }
      )
    )
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def set_subscription
    @subscription = Subscription.where(user: current_user, question: @question).first if user_signed_in?
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: %i[file id _destroy])
  end
end
