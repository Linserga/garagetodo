class TodoItemsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_todo_list
  
  def new
    @todo_item = @todo_list.todo_items.new
  end

  # GET /todo_items/1/edit
  def edit
    @todo_item = @todo_list.todo_items.find(params[:id])
  end

  # POST /todo_items
  # POST /todo_items.json
  def create
    @todo_item = @todo_list.todo_items.new(todo_item_params)

    respond_to do |format|
      if @todo_item.save
        flash[:success] = 'Todo item was successfully created.'
        format.html { redirect_to root_path}
        format.json { render :show, status: :created, location: @todo_item }
      else
        flash[:error] = 'Error occured'
        format.html { redirect_to :back}
        format.json { render json: @todo_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todo_items/1
  # PATCH/PUT /todo_items/1.json
  def update
    @todo_item = @todo_list.todo_items.find(params[:id])
    respond_to do |format|
      if @todo_item.update(todo_item_params)
        flash[:success] = 'Todo item was successfully updated.'
        format.html { redirect_to root_path}
        format.json { render :show, status: :ok, location: @todo_item }
      else
        flash.now[:error] = 'Error occured'
        format.html { render :edit }
        format.json { render json: @todo_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todo_items/1
  # DELETE /todo_items/1.json
  def destroy
    @todo_item = @todo_list.todo_items.find(params[:id])
    @todo_item.destroy
    respond_to do |format|
      flash.now[:success] = 'Todo item was successfully destroyed.'
      format.html { redirect_to root_path}
      format.js   {}
      format.json { head :no_content }
    end
  end

  def increment_priority
    @todo_item = @todo_list.todo_items.find(params[:id])
    if @todo_item.update_attribute(:priority, @todo_item.priority += 1)
      flash[:success] = 'Priority changed'
      redirect_to root_url
    else
      flash[:error] = 'Something went wrong'
      redirect_to root_url
    end
  end

  private

    def set_todo_list
      @todo_list = current_user.todo_lists.find(params[:todo_list_id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def todo_item_params
      params.require(:todo_item).permit(:references, :content, :completed_at)
    end
end
