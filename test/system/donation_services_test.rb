# frozen_string_literal: true

require 'application_system_test_case'

class DonationServicesTest < ApplicationSystemTestCase
  setup do
    @donation_service = donation_services(:one)
  end

  test 'visiting the index' do
    visit donation_services_url
    assert_selector 'h1', text: 'Donation Services'
  end

  test 'creating a Donation service' do
    visit donation_services_url
    click_on 'New Donation Service'

    click_on 'Create Donation service'

    assert_text 'Donation service was successfully created'
    click_on 'Back'
  end

  test 'updating a Donation service' do
    visit donation_services_url
    click_on 'Edit', match: :first

    click_on 'Update Donation service'

    assert_text 'Donation service was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Donation service' do
    visit donation_services_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Donation service was successfully destroyed'
  end
end
