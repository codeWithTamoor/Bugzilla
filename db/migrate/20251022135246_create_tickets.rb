class CreateTickets < ActiveRecord::Migration[8.0]
  def change
    create_table :tickets do |t|
      t.string :title
      t.string :type
      t.integer :status
      t.integer :developer_id
      t.integer :qa_id
      t.integer :project_id
      t.string :screenshot
      t.text :description
      t.date :deadline

      t.timestamps
    end
  end
end
