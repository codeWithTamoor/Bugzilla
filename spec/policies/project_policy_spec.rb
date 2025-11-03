require 'rails_helper'

RSpec.describe ProjectPolicy, type: :policy do
  include FactoryBot::Syntax::Methods
  def policy_for(user, record)
    described_class.new(user, record)
  end
  let!(:manager) { create(:manager) }
  let!(:developer) { create(:developer) }
  let!(:qa) { create(:qa) }
  let!(:other_manager) { create(:manager) }
  let!(:own_project) { create(:project, manager: manager) }
  let!(:foreign_project) { create(:project, manager: other_manager) }

  before do
    developer.projects<<own_project
  end

  describe '#index?' do
    it 'allows everyone' do
      expect(policy_for(manager, Project).index?).to be true
      expect(policy_for(developer, Project).index?).to be true
      expect(policy_for(qa, Project).index?).to be true
    end
  end
  describe '#show?' do
    context 'when manager' do
      it 'allow access to own project' do
        expect(policy_for(manager, own_project).show?).to be true
      end
      it 'denies access to others project' do
        expect(policy_for(manager, foreign_project).show?).to be false
      end
    end
    context 'when developer' do
      it 'allows access to assigned projects' do
        expect(policy_for(developer, own_project).show?).to be true
      end
      it 'denies access if not assigned to ' do
         expect(policy_for(developer, foreign_project).show?).to be false
      end
    end
    context 'when qa' do
      it 'allows to access to every project' do
        expect(policy_for(qa, foreign_project).show?).to be true
      end
    end
  end
  describe '#create?' do
    it 'allows only managers' do
      expect(policy_for(manager, Project).create?).to be true
      expect(policy_for(developer, Project).create?).to be false
      expect(policy_for(qa, Project).create?).to be false
    end
  end
  describe '#update?' do
    it 'allows manager of project' do
      expect(policy_for(manager, own_project).update?).to be true
    end

    it 'denies other managers' do
      expect(policy_for(other_manager, own_project).update?).to be false
    end
  end
  describe '#destroy?' do
    it 'allows manager of project' do
      expect(policy_for(manager, own_project).destroy?).to be true
    end

    it 'denies other managers' do
      expect(policy_for(other_manager, own_project).destroy?).to be false
    end
  end
  describe '#add_remove_users?' do
    it 'allows only project manager' do
      expect(policy_for(manager, own_project).add_remove_users?).to be true
      expect(policy_for(other_manager, own_project).add_remove_users?).to be false
      expect(policy_for(developer, own_project).add_remove_users?).to be false
    end
  end
  describe 'Scope' do
    subject(:scope) { described_class::Scope.new(user, Project.all).resolve }
    let!(:manager_project)   { Project.create!(name: "Manager Project", manager: manager) }
    let!(:other_project)     { Project.create!(name: "Other Project", manager: other_manager) }
    let!(:developer_project) { Project.create!(name: "Developer Project", manager: other_manager) }

    before do
      developer.projects << developer_project
    end
    context 'for manager' do
      let(:user) { manager }
      it 'includes only project they manage or thet are assigned to' do
        expect(scope).to include(manager_project)
        expect(scope).not_to include(other_project)
      end
    end
    context 'for developer' do
      let(:user) { developer }
      it 'include project ther are assigned' do
        expect(scope).to include(developer_project)
        expect(scope).not_to include(other_project)
      end
    end
    context 'for QA' do
      let(:user) { qa }

      it 'includes all projects' do
        expect(scope).to include(manager_project, other_project, developer_project)
      end
    end
  end
end
