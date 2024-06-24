
class SeedsController < ApplicationController
  # Company ID of sandbox company
  SANDBOX_COMPANY_ID = 4264590
  def new
    @company = SANDBOX_COMPANY_ID
  end

  def create
    data = params.permit(:vendor_check_box, :vendor_name, :po_check_box, :project_id, :po_vendor, :po_line_amount).to_h
    erp_seeder_service = ErpSeederService.new

    if erp_seeder_service.run(data.symbolize_keys)
      redirect_to project_path(data[:project_id])
    else
      render :new
    end
  end
end
