require "test_helper"

class DonationServicesControllerTest < ActionDispatch::IntegrationTest
  setup do 
    @donation = donation_service(:one)
  end
end
