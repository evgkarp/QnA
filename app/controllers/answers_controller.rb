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

  def destroy
    @question = @answer.question
    if verify_user
      @answer.destroy
      redirect_to @question, notice: 'Answer successfully deleted.'
    else
      redirect_to @question
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def verify_user
    current_user.author_of?(@answer)
  end
end
