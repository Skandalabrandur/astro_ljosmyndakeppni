class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  def index
    if current_user
        @users = User.all
    else
        redirect_to "/error"
    end
  end

  # GET /users/1
  def show
      redirect_to error_path, notice: 'Ólöglegt.'
  end

  def change_password
	if current_user
		render :new_password
	else
		redirect_to error_path, notice: 'Ólöglegt!'
	end
  end

  def change_password_post
	if params[:password]
		x = User.find(current_user.id)
		x.password_digest = BCrypt::Password.create(params[:password])
		if x.save
			redirect_to error_path, notice: "Lykilorði breytt"
		else
			redirect_to error_path, notice: "Eitthvað fór úrskeiðis. Hafðu samband við vefstjóra"
		end
	else
		redirect_to error_path, notice: "Lykilorð má ekki vera tómt"
	end
  end
		

  # GET /users/new
  def new
      redirect_to error_path, notice: 'Ólöglegt.'
  end

  # GET /users/1/edit
  def edit
      redirect_to error_path, notice: 'Ólöglegt.'
  end

  # POST /users
  def create
    redirect_to error_path, notice: 'Ólöglegt.'
    #@user = User.new(user_params)

    #@user.judge = false
    #@user.admin = false

    #if @user.save
    #  redirect_to root_path, notice: 'User was successfully created.'
    #else
    #  render :new
    #end
  end

  # PATCH/PUT /users/1
  def update
    if true
      redirect_to error_path, notice: 'Ólöglegt.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    #@user.destroy
    redirect_to error_path, notice: 'Ólöglegt.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
