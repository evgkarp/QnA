module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_item, only: %i[reset_vote vote_for vote_against]
  end

  def vote_for
    if !current_user.author_of?(@item) && !@item.has_vote?(current_user)
      @item.vote_for(current_user)
      render json: { rating: @item.rating }
    end
  end

  def vote_against
    if !current_user.author_of?(@item) && !@item.has_vote?(current_user)
      @item.vote_against(current_user)
      render json: { rating: @item.rating }
    end
  end

  def reset_vote
    if !current_user.author_of?(@item) && @item.has_vote?(current_user)
      @item.reset_vote(current_user)
      render json: { rating: @item.rating }
    end
  end

  private

  def load_item
    @item = controller_name.classify.constantize.find(params[:id])
  end
end
