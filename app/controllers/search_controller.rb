class SearchController < ApplicationController
  skip_authorization_check

  def search
    @query = params[:query]
    @category = params[:category]
    @results = Search.search(@query, @category) if @query.present?
  end
end
