class AddExpiresDateToSingleTodos < ActiveRecord::Migration[5.1]
  def change
    add_column :single_todos, :expires_date, :string
  end
end
