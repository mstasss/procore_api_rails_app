class CompaniesService
  def initialize(api_client)
    @api_client = api_client
  end

  def get_all_companies
    api_client.list_companies.map(&:symbolize_keys)
  end

  private
  attr_reader :api_client
end
