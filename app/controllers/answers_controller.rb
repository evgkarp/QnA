class AnswersController < ApplicationController
  include Voted

  respond_to :html, :json, :js

  before_action :authenticate_user!
  before_action :set_answer, only: %i[update destroy make_best]
  before_action :set_question, only: [:create]

  after_action :publish_answer, only: [:create]

  authorize_resource

  def create
    @answer = current_user.answers.build(answer_params)
    @answer.question = @question
    NewAnswerJob.perform_later(@answer) if @answer.save
    respond_with @answer
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    respond_with @answer
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
    respond_with @answer
  end

  def make_best
    @answer.set_best if current_user.author_of?(@question)
  end

  private

  def publish_answer
    return if @answer.errors.any?
    attachments = @answer.attachments.map do |attach|
      { id: attach.id, filename: attach.file.filename, url: attach.file.url }
    end
    data = @answer.as_json(include: :attachments).merge(answer: @answer,
                                                        has_vote: @answer.has_vote?(current_user),
                                                        rating: @answer.rating)

    ActionCable.server.broadcast("questions/#{@question.id}", data: data)
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: %i[file id _destroy])
  end

  def set_answer
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
