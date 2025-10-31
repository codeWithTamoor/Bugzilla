require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  include Devise::Test::IntegrationHelpers
  # include Devise::Test::ControllerHelpers
  include FactoryBot::Syntax::Methods

  let!(:manager)         { create_user(role: :manager) }
  let!(:other_manager)   { create_user(role: :manager) }
  let!(:developer)       { create_user(role: :developer) }
  let!(:qa)              { create_user(role: :qa) }


  let!(:own_project)     { create(:project, manager: manager) }
  let!(:foreign_project) { create(:project, manager: other_manager) }

  before do
    sign_in_user(manager)
    developer.projects << own_project
  end

  # ----------------------------------------------------
  describe '#index' do
    it 'shows only projects accessible to the signed-in manager' do
      get projects_path  

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(own_project.name)
      expect(response.body).not_to include(foreign_project.name)
    end
  end
  
end
