class CompaniesController < ApplicationController
  def index
    @companies = companies_service.get_all_companies
  end

  def show
    # We can potentially add a Company model to store company data
    # @company = Company.find(external_id: params[:id]) || Company.create(access_token.get("/rest/v1.0/companies/#{params[:id]}").parsed)

    # We could also fetch the company data from the Procore API,
    # but let's cut out an unnecessary API call for now
    @company = { id: params[:id] }
    @projects = projects_service.get_all_projects
  end

  private

  def current_company_id
    params[:id]
  end

  def companies_service
    @companies_service ||= CompaniesService.new(procore_api_client)
  end

  def projects_service
    @projects_service ||= ProjectsService.new(procore_api_client)
  end
end
