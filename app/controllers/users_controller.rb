class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_organizations, only: [:new, :create, :edit, :update]

  # GET /users
  # GET /users.json
  def index
    authorize User
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    authorize @user
    set_user_roles
  end

  # GET /users/new
  def new
    authorize User
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    authorize @user
  end

  # POST /users
  # POST /users.json
  def create
    authorize User
    @user = User.new(user_params)
    if @user.active == false
    end

    respond_to do |format|
      if @user.save
        flash[:success] = t('flashes.create', model: User.model_name.human)
        format.html { redirect_to @user}
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
    authorize @user
    respond_to do |format|
      if @user.update(user_params)
        flash[:success] = t('flashes.update', model: User.model_name.human)
        format.html { redirect_to @user}
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
    authorize User
    @user.destroy
    respond_to do |format|
      flash[:success] = t('flashes.destroy', model: User.model_name.human)
      format.html { redirect_to users_url}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def set_organizations
      @organizations = Organization.all.order(:name)
    end

    def set_user_roles
      @roles = @user.roles
      user_roles_names = @roles.map{|role| role.name.to_sym}
      @allowed_roles = User.roles.keys.select{|role_name| user_roles_names.exclude?(role_name) }
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :phone, :job, :description, :organization_id, :department,
                                  :email, :password, :password_confirmation, :active)
    end
end
