require 'rails_helper'

RSpec.describe "Tickets", type: :request do
  include Devise::Test::IntegrationHelpers
  include FactoryBot::Syntax::Methods

  let!(:manager)        { create(:manager) }
  let!(:other_manager)  { create(:manager) }
  let!(:developer)      { create(:developer) }
  let!(:other_dev)      { create(:developer) }
  let!(:qa)             { create(:qa) }

  let!(:own_project)    { create(:project, manager: manager) }
  let!(:foreign_project) { create(:project, manager: other_manager) }

  let!(:ticket)         { create(:ticket, project: own_project, qa: qa, developer: developer, status: :new_ticket) }
  let!(:foreign_ticket) { create(:ticket, project: foreign_project, qa: qa, status: :new_ticket) }

  before do
    developer.projects << own_project
  end

  # -------------------------------
  # INDEX
  # -------------------------------
  describe "GET /tickets" do
    context "when signed in as QA" do
      before { sign_in qa }

      it "returns all tickets" do
        get tickets_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(ticket.title)
      end
    end
  end

  # -------------------------------
  # SHOW
  # -------------------------------
  describe "GET /tickets/:id" do
    context "when QA signed in" do
      before { sign_in qa }

      it "shows the ticket" do
        get ticket_path(ticket)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(ticket.title)
      end
    end

    context "when manager from another project" do
      before { sign_in other_manager }

      it "denies access" do
        get ticket_path(ticket)
        expect(response).to have_http_status(:forbidden).or have_http_status(:redirect)
      end
    end
  end

  # -------------------------------
  # NEW / CREATE
  # -------------------------------
  describe "POST /tickets" do
    let(:valid_params) do
      {
        ticket: {
          title: 'New Bug',
          type: 'Bug',
          status: 'new_ticket',
          project_id: own_project.id,
          description: 'Bug description'
        }
      }
    end

    let(:invalid_params) do
      {
        ticket: {
          title: '',
          type: 'Bug',
          project_id: own_project.id
        }
      }
    end

    context "when QA signed in" do
      before { sign_in qa }

      it "creates a new ticket" do
        expect {
          post tickets_path, params: valid_params
        }.to change(Ticket, :count).by(1)
        expect(response).to redirect_to(ticket_path(Ticket.last))
        follow_redirect!
        expect(response.body).to include('New Bug')
      end

      it "fails with invalid params" do
        post tickets_path, params: invalid_params
        expect(response).to have_http_status(:ok).or have_http_status(:unprocessable_entity)
        expect(response.body).to include('error').or include('Title')
      end
    end

    context "when developer signed in" do
      before { sign_in developer }

      it "denies access" do
        post tickets_path, params: valid_params
        expect(response).to have_http_status(:forbidden).or have_http_status(:redirect)
      end
    end
  end

  # -------------------------------
  # UPDATE
  # -------------------------------
  describe "PATCH /tickets/:id" do
    let(:valid_update) { { ticket: { title: 'Updated Ticket Title' } } }
    let(:invalid_update) { { ticket: { title: '' } } }

    context "when manager owns the project" do
      before { sign_in manager }

      it "updates the ticket" do
        patch ticket_path(ticket), params: valid_update
        expect(response).to redirect_to(ticket_path(ticket))
        follow_redirect!
        ticket.reload
        expect(ticket.title).to eq('Updated Ticket Title')
      end
    end

    context "when invalid params" do
      before { sign_in manager }

      it "does not update the ticket" do
        patch ticket_path(ticket), params: invalid_update
        expect(response).to have_http_status(:ok).or have_http_status(:unprocessable_entity)
        ticket.reload
        expect(ticket.title).not_to eq('')
      end
    end

    context "when manager does not own project" do
      before { sign_in other_manager }

      it "denies access" do
        patch ticket_path(ticket), params: valid_update
        expect(response).to have_http_status(:forbidden).or have_http_status(:redirect)
      end
    end
  end

  # -------------------------------
  # DESTROY
  # -------------------------------
  describe "DELETE /tickets/:id" do
    context "when QA signed in" do
      before { sign_in qa }

      it "deletes the ticket" do
        delete ticket_path(ticket)
        expect(response).to redirect_to(tickets_path)
        expect(Ticket.exists?(ticket.id)).to be false
      end
    end

    context "when developer signed in" do
      before { sign_in developer }

      it "denies access" do
        delete ticket_path(ticket)
        expect(response).to have_http_status(:forbidden).or have_http_status(:redirect)
      end
    end
  end

  # -------------------------------
  # ASSIGN TO SELF
  # -------------------------------
  describe "PATCH /tickets/:id/assign_to_self" do
    let!(:unassigned_ticket) { create(:ticket, project: own_project, qa: qa, developer: nil, status: :new_ticket) }

    context "when developer signed in" do
      before { sign_in developer }

      it "assigns the ticket to the developer" do
        patch assign_to_self_ticket_path(unassigned_ticket)
        expect(response).to redirect_to(ticket_path(unassigned_ticket))
        unassigned_ticket.reload
        expect(unassigned_ticket.developer).to eq(developer)
        expect(unassigned_ticket.status).to eq('started')
      end
    end
  end
end
