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
  describe '#index' do
    it 'shows only projects accessible to the signed-in manager' do
      get projects_path  

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(own_project.name)
      expect(response.body).not_to include(foreign_project.name)
    end
  end

  describe '#show' do
  context 'when the manager is authorized' do
    it 'renders the project details successfully' do
      get project_path(own_project)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(own_project.name)
      expect(response.body).to include(own_project.desc) if own_project.desc.present?
    end
  end

  
end
describe '#create' do
  let(:valid_params) do
    { project: { name: 'New Project', desc: 'Project Description' } }
  end

  let(:invalid_params) do
    { project: { name: '', desc: '' } }
  end

  context 'when params are valid' do
    it 'creates a new project and redirects to the project page' do
      expect {
        post projects_path, params: valid_params
      }.to change(Project, :count).by(1)

      expect(response).to redirect_to(Project.last)
      follow_redirect!

      expect(response.body).to include('New Project')
    end
  end

  context 'when params are invalid' do
    it 'does not create a project and re-renders the new form' do
      expect {
        post projects_path, params: invalid_params
      }.not_to change(Project, :count)

      expect(response).to have_http_status(:unprocessable_entity).or have_http_status(:ok)
      expect(response.body).to include('error').or include('Name')
    end
  end

  
end


  
end
