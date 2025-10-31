require 'rails_helper'

RSpec.describe TicketPolicy, type: :policy do
  include FactoryBot::Syntax::Methods
  def policy_for(user, record)
    described_class.new(user, record)
  end
  let!(:manager)        { create(:manager) }
  let!(:other_manager)  { create(:manager) }
  let!(:developer)      { create(:developer) }
  let!(:other_dev)      { create(:developer) }
  let!(:qa)             { create(:qa) }

  let!(:own_project)    { create(:project, manager: manager) }
  let!(:foreign_project){ create(:project, manager: other_manager) }

  let!(:own_ticket)     { create(:ticket, project: own_project, developer: developer, qa: qa, status: :new_ticket) }
  let!(:foreign_ticket) { create(:ticket, project: foreign_project, qa: qa, status: :new_ticket) }

  before do
    developer.projects << own_project
  end
  describe '#index?' do
    it 'allows everyone' do
      expect(policy_for(manager, Ticket).index?).to be true
      expect(policy_for(developer, Ticket).index?).to be true
      expect(policy_for(qa, Ticket).index?).to be true
    end
  end
  describe '#show?' do
    context 'when manager' do
      it 'can see tickets in their project' do
        expect(policy_for(manager, own_ticket).show?).to be true
      end

      it 'cannot see tickets in other projects' do
        expect(policy_for(manager, foreign_ticket).show?).to be false
      end
    end

    context 'when developer' do
      it 'can see tickets in assigned projects' do
        expect(policy_for(developer, own_ticket).show?).to be true
      end

      it 'cannot see tickets in unassigned projects' do
        expect(policy_for(developer, foreign_ticket).show?).to be false
      end
    end

    context 'when QA' do
      it 'can see all tickets' do
        expect(policy_for(qa, foreign_ticket).show?).to be true
      end
    end
  end
  describe '#create?' do
    it 'allows only QA' do
      expect(policy_for(qa, Ticket).create?).to be true
      expect(policy_for(manager, Ticket).create?).to be false
      expect(policy_for(developer, Ticket).create?).to be false
    end
  end
  describe '#update?' do
    context 'when manager' do
      it 'can update tickets in their project' do
        expect(policy_for(manager, own_ticket).update?).to be true
      end

      it 'cannot update tickets in others’ projects' do
        expect(policy_for(manager, foreign_ticket).update?).to be false
      end
    end

    context 'when developer' do
      it 'can update their own tickets in assigned projects' do
        expect(policy_for(developer, own_ticket).update?).to be true
      end

      it 'cannot update tickets not assigned to them' do
        expect(policy_for(other_dev, own_ticket).update?).to be false
      end
    end

    context 'when QA' do
      it 'can update tickets they created' do
        expect(policy_for(qa, own_ticket).update?).to be true
      end

      it 'cannot update tickets from other QA users' do
        another_qa = create(:qa)
        foreign_ticket = create(:ticket, project: own_project, qa: another_qa)
        expect(policy_for(qa, foreign_ticket).update?).to be false
      end
    end
  end

  describe '#destroy?' do
    it 'allows managers and QA' do
      expect(policy_for(manager, own_ticket).destroy?).to be true
      expect(policy_for(qa, own_ticket).destroy?).to be true
    end

    it 'denies developers' do
      expect(policy_for(developer, own_ticket).destroy?).to be false
    end
  end
  describe '#assign_to_self?' do
    let!(:unassigned_ticket) { create(:ticket, project: own_project, qa: qa, developer: nil) }

    it 'allows developer with project access and unassigned ticket' do
      expect(policy_for(developer, unassigned_ticket).assign_to_self?).to be true
    end

    it 'denies if already assigned' do
      expect(policy_for(developer, own_ticket).assign_to_self?).to be false
    end

    it 'denies manager and QA' do
      expect(policy_for(manager, unassigned_ticket).assign_to_self?).to be false
      expect(policy_for(qa, unassigned_ticket).assign_to_self?).to be false
    end
  end

  
  describe 'Scope' do
    subject(:scope) { described_class::Scope.new(user, Ticket.all).resolve }

    let!(:ticket1) { create(:ticket, project: own_project, qa: qa) }
    let!(:ticket2) { create(:ticket, project: foreign_project, qa: qa) }

    context 'for manager' do
      let(:user) { manager }

      it 'includes only tickets in their managed or participated projects' do
        expect(scope).to include(ticket1)
        expect(scope).not_to include(ticket2)
      end
    end

    context 'for developer' do
      let(:user) { developer }

      it 'includes only tickets in their assigned projects' do
        expect(scope).to include(ticket1)
        expect(scope).not_to include(ticket2)
      end
    end

    context 'for QA' do
      let(:user) { qa }

      it 'includes all tickets' do
        expect(scope).to include(ticket1, ticket2)
      end
    end
  end
end
