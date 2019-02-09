class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  before_action :set_question, only: %i[index create]

  def index
    respond_with @question.answers.sorted
  end

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer
  end

  def create
    @answer = current_resource_owner.answers.build(answer_params)
    @answer.question = @question
    @answer.save
    respond_with @answer
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
