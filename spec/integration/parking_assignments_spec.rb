require 'integration/integration_spec_helper'

describe 'Parking Assignment management', type: :feature do

  feature 'Assigning a vehicle to a space' do
    let!(:space) { create :space, floor: 1, section: 'A', number: 1 }
    let!(:vehicle) { create :vehicle, license_state: 'PA', license_number: 'ZZZZZ', description: 'Red' }

    scenario 'selecting a vehicle for an available space' do
      visit root_path
      click_on "Park Next Vehicle"

      select 'ZZZZZ | PA | Red', from: 'Vehicle'
      click_on 'Create Parking Assignment'

      expect(page).to have_content "The parking assignment was successfully created"

      within "#active-parking-assignments" do
        expect(page).to have_content "1A-1"
        expect(page).to have_content "ZZZZZ | PA | Red"
        expect(page).to have_link "Check Out"
      end
    end

    scenario 'forgetting to select a vehicle for an available space' do
      visit root_path
      click_on "Park Next Vehicle"

      click_on 'Create Parking Assignment'

      expect(page).to have_content "There was a problem with creating the parking assignment"

      # still on form page with error
      expect(page).to have_content "New Parking Assignment for 1A-1"
    end

    scenario 'selecting a vehicle for an unavailable space' do
      create :parking_assignment, space: space, vehicle: vehicle
      visit space_parking_assignments_new_path(space)

      select 'ZZZZZ | PA | Red', from: 'Vehicle'
      click_on 'Create Parking Assignment'

      expect(page).to have_content "The parking assignment could not be created because the space is no longer be available"

      # back on the dashboard
      expect(page.current_path).to eq root_path
    end
  end

  feature 'Archiving an active parking assignment' do
    let!(:space) { create :space, floor: 1, section: 'A', number: 1 }
    let!(:vehicle) { create :vehicle, license_state: 'PA', license_number: 'ZZZZZ', description: 'Red' }
    let!(:parking_assignment) { create :parking_assignment, space: space, vehicle: vehicle }

    scenario 'checking out from the dashboard' do
      visit root_path

      within dom_id_selector(parking_assignment) do
        click_on 'Check Out'
      end

      # On the parking assignment's show page
      expect(page).to have_content "Parking Assignment for 1A-1"

      click_on 'Archive this Parking Assignment'

      expect(page).to have_content "The parking assignment was successfully archived"

      # back on the dashboard & the space is not listed as a current assignment
      expect(page.current_path).to eq root_path

      within '#active-parking-assignments' do
        expect(page).not_to have_content space.identifier
      end

      # check that the record was actually updated
      parking_assignment.reload

      expect(parking_assignment.ended_at).not_to be_nil
    end

    scenario 'attempting to checkout an archived parking assignment' do
      # open the page
      visit parking_assignment_path(parking_assignment)

      # before you hit the archive button, it's archived elsewhere
      parking_assignment.update_attribute(:ended_at, Time.zone.now)

      # now you try to click the archive button
      click_on 'Archive this Parking Assignment'

      expect(page).to have_content "There was a problem archiving the parking assignment. Ensure that the vehicle was not already checked out"

      # back on the dashboard & the space is not listed as a current assignment
      expect(page.current_path).to eq root_path
      within '#active-parking-assignments' do
        expect(page).not_to have_content space.identifier
      end

    end
  end
end

