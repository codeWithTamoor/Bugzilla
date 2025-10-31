# spec/support/devise_sti_helpers.rb
module DeviseStiHelpers
  def sign_in_user(user)
    sign_in(user, scope: :user)
  end
end

RSpec.configure do |config|
  config.include DeviseStiHelpers, type: :controller
  config.include DeviseStiHelpers, type: :request
end
