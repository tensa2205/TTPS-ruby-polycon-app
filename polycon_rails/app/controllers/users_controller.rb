class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    redirect_if_not_logged_or_not_admin
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    redirect_if_not_logged_or_not_admin
  end

  # GET /users/new
  def new
    redirect_if_not_logged_or_not_admin
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    redirect_if_not_logged_or_not_admin
  end

  # POST /users or /users.json
  def create
    redirect_if_not_logged_or_not_admin
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    redirect_if_not_logged_or_not_admin
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    redirect_if_not_logged_or_not_admin
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :password, :role_id)
    end

    def redirect_if_not_logged_or_not_admin
      if session[:user_id].nil?
        redirect_to login_path
      else current_user.role.name != "Administracion"
        redirect_to_root_path
      end
    end
end
