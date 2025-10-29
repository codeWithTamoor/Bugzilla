class MigrateUserRolesToType < ActiveRecord::Migration[8.0]
  def up
    User.reset_column_information

    User.where(role: 1).update_all(type: 'Manager')
    User.where(role: 2).update_all(type: 'Developer')
    User.where(role: 3).update_all(type: 'Qa')
  end

  def down
    User.where(type: 'Manager').update_all(role: 1)
    User.where(type: 'Developer').update_all(role: 2)
    User.where(type: 'Qa').update_all(role: 3)
  end
end
