require 'integration/integration_spec_helper'

feature 'Vehicle management', type: :feature do
  let!(:existing_vehicle) { create :vehicle,
                                   license_state: 'NY',
                                   license_number: 'ZZZZZZ',
                                   description: 'Runs good!',
                                   contact_name: 'Jamie Smith',
                                   contact_phone: '555-5555' }

  scenario 'Viewing all vehicles' do
    visit root_path
    click_on 'Vehicles'

    within dom_id_selector(existing_vehicle) do
      expect(page).to have_content "ZZZZZZ | NY"
      expect(page).to have_content "Runs good!"
      expect(page).to have_content "Jamie Smith"
      expect(page).to have_content "555-5555"
    end
  end

  scenario 'Adding a new vehicle' do
    visit vehicles_path
    click_on 'Add New Vehicle'

    select 'Pennsylvania', from: 'State'
    fill_in 'Number', with: 'ABC123'
    fill_in 'Description', with: 'Red Make Model'
    fill_in 'Name', with: 'Alex Jones'
    fill_in 'Phone', with: '(123) 456-7890'
    click_on 'Save Vehicle'

    # redirected to vehicle show page
    expect(page).to have_content "The vehicle was successfully created"

    within 'h1' do
      expect(page).to have_content "ABC123 | PA"
    end

    expect(page).to have_content "Red Make Model"
    expect(page).to have_content "Alex Jones"
    expect(page).to have_content "(123) 456-7890"
  end

  scenario 'Editing an existing vehicle' do
    visit vehicle_path(existing_vehicle)
    click_on 'Edit this Vehicle'

    select 'New Jersey', from: 'State'
    fill_in 'Number', with: 'YYYY'
    fill_in 'Description', with: 'Needs work!'
    fill_in 'Name', with: 'J. Jones'
    fill_in 'Phone', with: '111-1111'
    click_on 'Save Vehicle'

    # redirected to vehicle show page
    expect(page).to have_content "The vehicle was successfully updated"

    within 'h1' do
      expect(page).to have_content "YYYY | NJ"
    end

    expect(page).to have_content "Needs work!"
    expect(page).to have_content "J. Jones"
    expect(page).to have_content "111-1111"
  end

  scenario 'Deleting an existing vehicle' do
    visit vehicle_path(existing_vehicle)
    click_on 'Delete this Vehicle'

    # redirected to vehicle index page
    expect(page).to have_content "The vehicle was successfully destroyed"

    within 'h1' do
      expect(page).to have_content "Vehicles"
    end

    expect(page).not_to have_content "ZZZZZZ | NY | Runs good!"
    expect(page).not_to have_content "Jamie Smith"
    expect(page).not_to have_content "555-5555"
  end
end
