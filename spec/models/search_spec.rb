require 'rails_helper'

 RSpec.describe Search do
  describe '.search' do
    %w(Question Answer Comment User).each do |category|
      it "gets param #{category}" do
        expect(category.classify.constantize).to receive(:search).with('text')
        Search.search('text', category)
      end
    end

     %w(Everywhere '').each do |category|
      it "gets param #{category}" do
        expect(ThinkingSphinx).to receive(:search).with('text')
        Search.search('text', category)
      end
    end
  end
end
