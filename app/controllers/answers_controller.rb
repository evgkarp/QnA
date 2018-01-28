class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:show, :destroy]
  before_action :set_question, only: [:new, :create]

  def create
    @answer = current_user.answers.build(answer_params)
    @answer.question = @question
    @answer.save
    redirect_to @question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
