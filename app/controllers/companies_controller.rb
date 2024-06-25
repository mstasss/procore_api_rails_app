class CompaniesController < ApplicationController
  def index
    @companies = procore_api_client.list_companies.map(&:symbolize_keys)
  end

  def show
    # We can potentially add a Company model to store company data
    # @company = Company.find(external_id: params[:id]) || Company.create(access_token.get("/rest/v1.0/companies/#{params[:id]}").parsed)
    @company = { id: params[:id] }
    @projects = projects_service.get_all_projects
  end

  private
  def projects_service
    @projects_service ||= ProjectsService.new(procore_api_client)
  end

  def procore_api_client
    @procore_api_client ||= Procore::ApiClient.new(
      company_id: params[:id],
      access_token: access_token,
      before_retry: ->(client) { client.access_token = refresh_token! }
    )
  end
end
