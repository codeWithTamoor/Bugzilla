require 'rails_helper'

RSpec.describe Manager, type: :model do
 it { should have_many(:subordinates) }
 it { should have_many(:created_projects) }
end
