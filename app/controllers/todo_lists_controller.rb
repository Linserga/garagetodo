class TodoListsController < ApplicationController
  
  before_action :authenticate_user!
  before_action :set_todo_list, only: [:edit, :update, :destroy]

  # GET /todo_lists
  # GET /todo_lists.json
  def index
    @todo_lists = current_user.todo_lists
  end

  # GET /todo_lists/new
  def new
    @todo_list = current_user.todo_lists.new
  end

  def edit
  end

  # POST /todo_lists
  # POST /todo_lists.json
  def create
    @todo_list = current_user.todo_lists.new(todo_list_params)
    respond_to do |format|
      if @todo_list.save
        flash[:success] = 'Todo list was successfully created.'
        format.html { redirect_to root_path }
        format.json { render :show, status: :created, location: @todo_list }
      else
        flash[:error] = 'Error'
        format.html { render :new }
        format.json { render json: @todo_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todo_lists/1
  # PATCH/PUT /todo_lists/1.json
  def update
    respond_to do |format|
      if @todo_list.update(todo_list_params)
        flash[:success] = 'Todo list was successfully updated.'
        format.html { redirect_to root_path }
        format.json { render :show, status: :ok, location: @todo_list }
      else
        flash[:error] = 'Error'
        format.html { render :edit }
        format.json { render json: @todo_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todo_lists/1
  # DELETE /todo_lists/1.json
  def destroy
    @todo_list.destroy
    flash.now[:success] = 'Todo list was successfully destroyed.'
    respond_to do |format|
      format.html { redirect_to todo_lists_url }
      format.js   { @todo_list}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo_list
      @todo_list = current_user.todo_lists.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def todo_list_params
      params[:todo_list].permit(:title)
    end
end
