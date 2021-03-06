class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :edit, :update, :destroy]

  # GET /organizations
  # GET /organizations.json
  def index
    authorize Organization
    @organizations = policy_scope(Organization)
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    authorize @organization
  end

  # GET /organizations/new
  def new
    authorize Organization
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit
    authorize @organization
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.new(organization_params)
    authorize @organization

    respond_to do |format|
      if @organization.save
        flash[:success] = t('flashes.create', model: Organization.model_name.human)
        format.html { redirect_to @organization}
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render :new }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    authorize @organization
    respond_to do |format|
      if @organization.update(organization_params)
        flash[:success] = t('flashes.update', model: Organization.model_name.human)
        format.html { redirect_to @organization}
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    authorize @organization
    @organization.destroy
    respond_to do |format|
      flash[:success] = t('flashes.destroy', model: Organization.model_name.human)
      format.html { redirect_to organizations_url}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_params
      params.require(:organization).permit(:name, :description)
    end
end
