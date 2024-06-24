class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
    data = params.permit(:vendor_check_box, :vendor_name, :po_check_box, :project_id, :po_vendor, :po_line_amount).to_h
    erp_seeder_service = ErpSeederService.new

    if erp_seeder_service.run(data.symbolize_keys)
      redirect_to project_path(data[:project_id])
    else
      render :new
    end
  end

  private

    def project_params
      params.fetch(:project, {})
    end
end
