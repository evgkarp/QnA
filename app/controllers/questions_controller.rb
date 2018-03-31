class QuestionsController < ApplicationController
  include Voted

  respond_to :html, :json, :js

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show update destroy]

  after_action :publish_question, only: [:create]


  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to @question, notice: 'Question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy if current_user.author_of?(@question)
    redirect_to questions_url
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

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: %i[file id _destroy])
  end
end
