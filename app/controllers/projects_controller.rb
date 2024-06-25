class ProjectsController < ApplicationController
  before_action :set_project
  
  def show
  end

  def edit
  end

  def update
    if projects_service.seed_project(project_params.symbolize_keys)
      redirect_to company_project_path(@project[:company_id], @project[:id])
    else
      render :new
    end
  end

  private

  def project_params
    params.require(:project).permit(
      :external_id,
      :vendor_check_box,
      :vendor_name,
      :po_check_box,
      :po_vendor,
      :po_line_amount
    )
  end

  def set_project
    @project = projects_service.get_one_project(params[:id])
  end

  def projects_service
    @projects_service ||= ProjectsService.new(procore_api_client)
  end

  def procore_api_client
    @procore_api_client ||= Procore::ApiClient.new(
      company_id: params[:company_id],
      access_token: access_token,
      before_retry: ->(client) { client.access_token = refresh_token! }
    )
  end
end
