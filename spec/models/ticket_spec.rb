require 'rails_helper'

RSpec.describe Ticket, type: :model do
  let(:manager) {Manager.create!(name:"arslan",email:"arslan@gmail.com",password:"password")}
  let(:project) { Project.create!(name: "Test Project",manager:manager) }
  let(:qa) { Qa.create!(email: "qa@example.com", name: "QA Tester", password: "password") }

  it {should belong_to(:project)}
  it {should belong_to(:developer).optional}
  it {should belong_to(:qa)}
  it {should have_one_attached(:screenshot)}
  it {should validate_presence_of(:title)}
  it {should validate_uniqueness_of(:title).scoped_to(:project_id)}
  it {should validate_presence_of(:status)}
  it {should validate_presence_of(:qa_id)}
  it {should validate_presence_of(:type)}
  it {should validate_presence_of(:project_id)}

  describe 'status enums' do
    it 'defines correct enum values' do
      expect(Ticket.statuses.keys).to contain_exactly('new_ticket','started','resolved','completed')
      expect(Ticket.statuses.values).to contain_exactly(0,1,2,3)
    end
  end

  describe 'validations' do
    let(:ticket) do
      Ticket.new(
        title: "Bug Screenshot Test",
        status: :new_ticket,
        type: "Bug",    
        qa: qa,
        project: project
      )
    end

    context 'when screenshot is PNG' do
      it 'is valid' do
        file = fixture_file_upload(Rails.root.join('spec/fixtures/files/test.png'), 'image/png')
        ticket.screenshot.attach(file)

        expect(ticket).to be_valid
      end
    end

    context 'when screenshot is a GIF' do
      it 'is valid' do
        file = fixture_file_upload(Rails.root.join('spec/fixtures/files/test.gif'), 'image/gif')
        ticket.screenshot.attach(file)

        expect(ticket).to be_valid
      end
    end

    context 'when screenshot is not an image' do
      it 'is invalid' do
        file = fixture_file_upload(Rails.root.join('spec/fixtures/files/test.pdf'), 'application/pdf')
        ticket.screenshot.attach(file)

        expect(ticket).not_to be_valid
        expect(ticket.errors[:screenshot]).to include('must be a PNG or GIF image')
      end
    end

    context 'when screenshot is not attached' do
      it 'is valid (skips screenshot validation)' do
        expect(ticket).to be_valid
      end
    end
  end
end
