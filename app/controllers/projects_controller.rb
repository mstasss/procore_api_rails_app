class ProjectsController < ApplicationController
  def index
    @projects = []
  end

  def show
  end

  def edit
  end

  def update
    projects_service = ProjectsService.new

    if projects_service.seed_project(project_params.symbolize_keys)
      redirect_to project_path(data[:project_id])
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
end
