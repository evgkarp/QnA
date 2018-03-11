class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(params[:id])
    @question = Question.find_by_id(@attachment.attachable.id)
    if @attachment.attachable_type == 'Question'
      @attachment.destroy if current_user.author_of?(@question)
    elsif @attachment.attachable_type == 'Answer'
      @answer = Answer.find_by_id(@attachment.attachable.id)
      @attachment.destroy if current_user.author_of?(@answer)
    end
  end
end
