require 'rails_helper'

RSpec.describe Developer, type: :model do
 it { should have_many(:assigned_tickets) }
 it { should belong_to(:manager).optional }
end
