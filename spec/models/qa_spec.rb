require 'rails_helper'

RSpec.describe Qa, type: :model do
  it { should have_many(:reported_tickets) }
  it { should belong_to(:manager).optional }
end
