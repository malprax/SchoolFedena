class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  layout :choose_layout
  def choose_layout
    return 'login' if action_name == 'login' or action_name == 'set_new_password'
    return 'forgotpw' if action_name == 'forgot_password'
    return 'dashboard' if action_name == 'dashboard'
    
  end
  
  
  
  def login
    @user = User.new(params[:user])
    user = User.active.find_by(username: @user.username)
    if user.present? and User.authenticate?(@user.username, @user.password)
      authenticated_user = user
    end
    if authenticated_user.present?
      successful_user_login(authenticated_user) and return
    elsif authenticated_user.blank? and request.post?
      flash[:notice] = "Invalid username or password combination"
    end
    
  end
  
  def forgot_password
    # if request.post? and params[:reset_password]
    
  end
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :first_name, :last_name, :email, :admin, :student, :employee, :hashed_password, :salt, :reset_password_code, :reset_password_code_until)
    end
end
