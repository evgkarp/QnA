class Search
  CATEGORIES = %w(Question Answer Comment User)

   def self.search(query, category = nil)
    secure_query = ThinkingSphinx::Query.escape(query)
    if CATEGORIES.include?(category)
      category.classify.constantize.search secure_query
    else
      ThinkingSphinx.search secure_query
    end
  end
end
