class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable

  after_action :publish_comment

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      render json: { body: @comment.body }
    else
      render json: @comment.errors.full_messages
    end
  end

  private

  def publish_comment
    return if @comment.errors.any?

    data = {
      commentable_id: @commentable.id,
      commentable_type: @comment.commentable_type.underscore,
      comment: @comment
    }

    ActionCable.server.broadcast("comments_#{@comment.commentable_type == 'Question' ? @commentable.id : @commentable.question_id}",
     data)
  end

  def set_commentable
    @commentable = Question.find(params[:question_id]) if (params[:question_id]).present?
    @commentable = Answer.find(params[:answer_id]) if (params[:answer_id]).present?
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
