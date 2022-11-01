# frozen_string_literal: true

Pay.setup do |config|
  # For use in the receipt/refund/renewal mailers
  config.business_name = 'Bimaguide'
  config.business_address = '2121 Dwight Way'
  config.application_name = 'BimaGuide'
  config.support_email = 'abhinav.dhulipala@berkeley.edu'

  config.default_product_name = 'standard contribution'
  config.default_plan_name = 'standard insurance'

  config.automount_routes = true
  config.routes_path = '/pay' # Only when automount_routes is true
  # All processors are enabled by default. If a processor is already implemented in your application, you can omit it from this list and the processor will not be set up through the Pay gem.
  # config.enabled_processors = [:stripe]
  # All emails can be configured independently as to whether to be sent or not. The values can be set to true, false or a custom lambda to set up more involved logic. The Pay defaults are show below and can be modified as needed.
  # This example for subscription_renewing only applies to Stripe, therefor we supply the second argument of price
end
