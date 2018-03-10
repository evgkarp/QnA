class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(params[:id])
    @question = Question.find_by_id(@attachment.attachable.id)
    @attachment.destroy if current_user.author_of?(@question)
  end
end
