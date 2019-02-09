require_relative 'acceptance_helper'

feature 'Search', %q{
  In order to find information
  As user
  I want to search info in questions, answers, comments and users
} do

  given!(:user) { create(:user, email: "search@mail.ru") }
  given!(:question) { create(:question, user: user) }

  context 'User' do
    scenario 'sees search field with attributes' do
      visit root_path
      %w(Everywhere Question Answer Comment User).each do |category|
        expect(page).to have_content category
      end
    end
  end
end
