require 'rails_helper'

describe "New Match" do
  it 'should be show the link to create a new match' do
    visit root_path
    click_link('Start New Match')
    expect(page).to have_content('Team 1')
    expect(page).to have_content('Team 2')
    expect(page).to have_content('Game 1')
    expect(page).to have_content('Game 2')
  end
end
