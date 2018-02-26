require_relative '../acceptance_helper'

feature 'Choice best answer', %q{
  In order to stimulate users
  As an author of question
  I want to be able to choice best answer
} do
  given!(:user) { create(:user) }
  given!(:second_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: second_user)}
  given!(:second_answer) { create(:answer, question: question, user: second_user)}

  describe 'Author of question', js: true do
    before do
      sign_in(user)
      visit question_path(question)
      within "#answer-id-#{answer.id}" do
        check 'Best answer'
        click_on 'Choice'
      end
    end

    scenario 'choices best answer', js: true do
      within "#answer-id-#{answer.id}" do
        expect(page).to have_css('.best-answer')
        expect(page).to have_checked_field('answer_best_answer')
      end
    end

    scenario 'choices another one best answer', js: true do
      within "#answer-id-#{second_answer.id}" do
        check 'Best answer'
        click_on 'Choice'

        expect(page).to have_css('.best-answer')
        expect(page).to have_checked_field('answer_best_answer')
      end

      within "#answer-id-#{answer.id}" do
        expect(page).to_not have_css('.best-answer')
        expect(page).to have_unchecked_field('answer_best_answer')
      end
      expect(find('.answers').first('div')).to have_css('.best-answer')
    end
  end

  scenario "Authenticated user choices best answer of other user's question", js: true do
    sign_in(second_user)
    visit question_path(question)

    expect(page).to_not have_link('Choice')
  end

  scenario "Unauthenticated user choices best answer of other user's question", js: true do
    visit question_path(question)

    expect(page).to_not have_link('Choice')
  end
end
