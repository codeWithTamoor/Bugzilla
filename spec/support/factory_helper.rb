module FactoryHelpers
  def create_user(role: :manager)
    case role
    when :manager then create(:manager)
    when :developer then create(:developer)
    when :qa then create(:qa)
    end
  end
end
