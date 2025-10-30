require 'rails_helper'

RSpec.describe Project, type: :model do
  it {should belong_to(:manager)}
  it {should have_and_belong_to_many(:users)}
  it {should have_many(:tickets)}
  it {should have_and_belong_to_many(:developers)}
  it {should have_and_belong_to_many(:qas)}
  it {should validate_presence_of(:name)}
  it {should validate_uniqueness_of(:name)}
  it {should validate_presence_of(:manager_id)}
  describe '#developer_ids=' do 
    let!(:dev1) { Developer.create!(name: 'Dev1', email: 'dev1@example.com', password: 'password') }
    let!(:dev2) { Developer.create!(name: 'Dev2', email: 'dev2@example.com', password: 'password') }
    let!(:dev3) { Developer.create!(name: 'Dev3', email: 'dev3@example.com', password: 'password') }
    it 'assigns only valid developers' do
      project=Project.new
      project.developer_ids=[dev1.id,'', dev2.id]
      expect(project.developers).to match_array([dev1,dev2])
    end
    it 'doesnt include developers not in the list' do
      project=Project.new
      project.developer_ids=[dev1.id]
      expect(project.developers).to eq([dev1])
      expect(project.developers).not_to include([dev2])
    end
  end
  describe '#qa_ids=' do
    let!(:qa1) { Qa.create!(name: 'QA1', email: 'qa1@example.com', password: 'password') }
    let!(:qa2) { Qa.create!(name: 'QA2', email: 'qa2@example.com', password: 'password') }

    it 'assigns only valid QAs and skips blanks' do
      project = Project.new
      project.qa_ids = [qa1.id, '', qa2.id]

      expect(project.qas).to match_array([qa1, qa2])
    end
  end
end
