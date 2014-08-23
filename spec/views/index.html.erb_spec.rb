require 'rails_helper'

describe 'Tasks' do

	let!(:user){FactoryGirl.create(:user)}
	let!(:todo_list){TodoList.create(title: 'Grocery', user_id: user.id)}

	before do
		visit login_path
		fill_in 'Email', with: user.email
		fill_in 'Password', with: user.password
		click_button 'Sign in'
	end

	describe 'Todo List' do
		describe 'Create Todo List' do
			it 'creates new todo_list with valid params' do
				click_on 'Add TODO List'
				fill_in 'Title', with: 'Grocery'
				click_on 'Create Todo list'

				expect(page).to have_content('Grocery')
				expect(page).to have_selector('div.alert.alert-success')
			end

			it 'does not create todo_list with invalid params' do
				
				click_on 'Add TODO List'
				fill_in 'Title', with: ''
				click_on 'Create Todo list'

				expect(page).to have_selector('div.alert.alert-error')
			end
		end

		describe 'Edit Todo List' do

			it 'should edit todo list with valid params' do
				
				click_link '', href: edit_todo_list_path(todo_list)
				fill_in 'Title', with: 'Grocery2'
				click_on 'Update Todo list'

				expect(page).to have_content('Grocery2')
				expect(page).to have_selector('div.alert.alert-success')
				#save_and_open_page
			end

			it 'should not edit dodo list with invalid params' do
				
				click_link '', href: edit_todo_list_path(todo_list)
				fill_in 'Title', with: ''
				click_on 'Update Todo list'

				todo_list.reload
				expect(todo_list.title).to eq('Grocery')
				expect(page).not_to have_content('Grocery2')
				expect(page).to have_selector('div.alert.alert-error')
			end
		end

		describe 'Delete Todo list' do
			it 'should delete todo list' do
								
				expect do
					click_link '', href: todo_list_path(todo_list)
				end.to change(TodoList, :count).by(-1)
				expect(page).not_to have_content('Grocery')
			end
		end
	end

	describe 'Todo items' do

		describe 'Create todo item' do
		
			it 'creates new todo_item witn valid params' do
					
				fill_in 'todo_item_content', with: 'New item'
				click_on 'Add Task'
				expect(page).to have_content 'New item'
			end

			it 'does not create todo_item with invalid params' do
					
				fill_in 'todo_item_content', with: ''
				click_on 'Add Task'

				expect(page).not_to have_content 'New item'
				expect(page).to have_selector('div.alert.alert-error')
			end
		end

		describe 'Edit todo item' do

			let!(:todo_item){TodoItem.create(content: 'New item', todo_list_id: todo_list.id, priority: 0, completed: 0)}

			it 'successfully edits todo item with valid params' do
				visit root_path
				click_link '', href: edit_todo_list_todo_item_path(todo_list, todo_item)
				fill_in 'Content', with: 'New item2'
				click_on 'Update Todo item'

				expect(page).to have_content('New item2')
				expect(page).to have_selector('div.alert.alert-success')
				#save_and_open_page
			end

			it 'should not edit todo item with invalid params' do
				visit root_path
				click_link '', href: edit_todo_list_todo_item_path(todo_list, todo_item)
				fill_in 'Content', with: ''
				click_on 'Update Todo item'

				expect(page).not_to have_content('New item2')
				expect(page).to have_selector('div.alert.alert-error')
				#save_and_open_page
			end			
		end

		describe 'Delete todo item' do
			let!(:todo_item){TodoItem.create(content: 'New item', todo_list_id: todo_list.id, priority: 0, completed: 0)}
			
			it 'should delete todo item' do
				visit root_path
				expect{
					click_link '', href: todo_list_todo_item_path(todo_list, todo_item)
				}.to change(TodoItem, :count).by(-1)
			end
		end
	end
end