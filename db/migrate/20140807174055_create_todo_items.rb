class CreateTodoItems < ActiveRecord::Migration
  def change
    create_table :todo_items do |t|
      t.references :todo_list, index: true
      t.string :content
      t.integer :priority, default: 0
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
