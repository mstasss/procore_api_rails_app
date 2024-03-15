
class SeedsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Company ID of sandbox company
  SANDBOX_COMPANY_ID = 4264590
  def new
   @company = SANDBOX_COMPANY_ID
  end

  def math
    # debugger
    num = params[:number]
    @result = num.to_i * 2
    render :new
  end

  def create
    render "/seeds/new"
    # if success
    #   puts 'success'
    # else
    #   puts 'failure'
    # end
  end

  def createa
    # TODO: How do we determine these properly?
    # company_id = params[:company_id]
    # project_id = params[:project_id]

    company_id = SANDBOX_COMPANY_ID
    project_id = nil

    project_seeder = ProjectSeeder.new(company_id: company_id, project_id: project_id)

    # we want to explicitly permit what data comes in
    # this is a security measure to prevent unwanted data from being processed
    # in Rails, this is done with the `params` object and its methods `require` and `permit`
    permitted_params = params.require(:data).permit(vendor: [:name])

    # convert the permitted params object to a regular Ruby hash, so
    # our `ProjectSeeder` doesn't have to worry about the `ActionController::Parameters` object
    data = permitted_params.to_h
    project_seeder.run(data)

    render json: { message: 'Success' }, status: :ok
  rescue => e # TODO: Rescue specific errors
    render json: { message: e.message }, status: :internal_server_error
  end


end
