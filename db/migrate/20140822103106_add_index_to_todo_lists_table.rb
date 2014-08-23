class AddIndexToTodoListsTable < ActiveRecord::Migration
  def change
  	add_index :todo_lists, :user_id
  end
end
