require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it {should have_and_belong_to_many(:projects)}
  it {should validate_presence_of(:email)}
  it {should validate_presence_of(:name)}
  it {should validate_uniqueness_of(:email).case_insensitive}

  describe "Sti behaviour" do
    it "create a type developer with type 'Developer'" do
      dev=Developer.create!(name:"haris",email:"haris@gmail.com",password:"password")
      expect(dev.type).to eq("Developer")
      expect(dev).to be_a(Developer)

    end
    it "creates a Manager record with type 'Manager'" do
    manager = Manager.create!(name: "umair", email: "umair@gmail.com", password: "password")
    expect(manager.type).to eq("Manager")
    expect(manager).to be_a(Manager)
    end
    it "creates a Qa record with type 'Qa'" do
    manager = Qa.create!(name: "haroonQA", email: "haroon@gmail.com", password: "password")
    expect(manager.type).to eq("Qa")
    expect(manager).to be_a(Qa)
    end

  end

end
