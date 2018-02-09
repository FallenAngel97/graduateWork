class ChangeNames < ActiveRecord::Migration[5.1]
  def change
    create_table :single_todos do |t|
      t.string :title
      t.string :expires_date
      t.timestamps null: false
    end
  end
end
