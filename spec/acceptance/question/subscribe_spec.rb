require_relative '../acceptance_helper'

feature 'Subscriptions', %q{
  In order to receive new answers
  As an authenticated user
  I want to subsribe to the question
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'Non-authenticated user' do
    before { visit question_path(question) }

    scenario 'cannot see link Subsribe', js: true do
      expect(page).to_not have_link 'Subscribe'
    end

    scenario 'cannot see link Unsubscribe', js: true do
      expect(page).to_not have_link 'Unsubscribe'
    end
  end

  describe 'Author of question' do
    before do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'does not see subscribe link in his question', js: true do
      expect(page).to_not have_button 'Subscribe'
    end

    scenario 'unsubscribes from his question', js: true do
      click_on 'Unsubscribe'

      expect(page).to have_button 'Subscribe'
    end
  end

  describe 'Non-author of question' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "see a link Subsribe to other's user question", js: true do
      expect(page).to have_button 'Subscribe'
    end

    scenario 'see link Unsubscribe if he is already subscribed to the question', js: true do
      click_on 'Subscribe'

      expect(page).to have_button 'Unsubscribe'
    end
  end
end
