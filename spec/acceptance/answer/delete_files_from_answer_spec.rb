require_relative '../acceptance_helper'

feature 'Delete files from answer', %q{
  In order to be able to delete files from my answer
  As an author of answer
  I want to be able delete files
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:attachment) { create(:attachment, attachable: answer) }
  given(:second_user) { create(:user) }

  describe 'Author of answer' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'deletes file when he edits answer', js: true do
      within '.answers' do
        click_on 'Edit'
        click_on 'Delete attachment'

        expect(page).to_not have_content attachment.file.identifier
      end
    end
  end

  scenario "Authenticated user can not see link Delete attachment from other user's question" do
    sign_in(second_user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
      expect(page).to_not have_link 'Delete attachment'
    end
  end

  scenario "Unauthenticated user can not see link Delete attachment from other user's question" do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
      expect(page).to_not have_link 'Delete attachment'
    end
  end
end
