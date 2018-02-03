class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:destroy]
  before_action :set_question, only: [:create]

  def create
    @answer = current_user.answers.build(answer_params)
    @answer.question = @question
    if @answer.save
      flash[:notice] = 'Answer successfully created.'
      redirect_to @question
    else
      render 'questions/show'
    end
  end

  def destroy
    @question = @answer.question
    if current_user.author_of?(@answer)
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
end
