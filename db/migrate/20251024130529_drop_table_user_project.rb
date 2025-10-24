class DropTableUserProject < ActiveRecord::Migration[8.0]
  def change
    drop_table :user_projects
  end
end
