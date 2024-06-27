module Procore
  class ApiClient
    DEFAULT_API_VERSION = 'v1.0'

    attr_reader :company_id
    attr_accessor :access_token

    def initialize(company_id:, access_token:, refresh_token:)
      @company_id = company_id
      @access_token = access_token
      @refresh_token = refresh_token
    end

    # https://developers.procore.com/reference/rest/v1/me?version=1.0
    def list_me
      list('me')
    end

    # https://developers.procore.com/reference/rest/v1/companies?version=1.0
    def list_companies
      list('companies')
    end

    # https://developers.procore.com/reference/rest/v1/projects?version=1.1
    def list_projects(**options)
      list('projects', company_id: company_id, **options)
    end

    # Alternate to above
    # https://developers.procore.com/reference/rest/v1/company-projects?version=1.0
    # def list_projects
    #   list("companies/#{company_id}/projects")
    # end

    # https://developers.procore.com/reference/rest/v1/project-vendors?version=1.1
    def list_vendors
      list('vendors', company_id: company_id)
    end

    def create_vendor(name)
      create('vendors', { name: name, company_id: company_id })
    end

    # https://developers.procore.com/reference/rest/v1/cost-codes?version=1.0
    def list_cost_codes(project_id)
      list('cost_codes', project_id: project_id)
    end

    # https://developers.procore.com/reference/rest/v1/purchase-order-contracts?version=1.0
    def list_purchase_order(project_id)
      list('purchase_order_contracts', project_id: project_id)
    end

    def create_purchase_order(title, project_id, vendor_id)
      create(
        'purchase_order_contracts',
        project_id: project_id,
        company_id: company_id,
        purchase_order_contract: {
          vendor_id: vendor_id,
          title: title
        }
      )
    end

    # Purchase Order Contract Line Items
    # https://developers.procore.com/reference/rest/v1/purchase-order-contract-line-items?version=1.0#create-purchase-order-contract-line-item
    # POST /rest/v1.0/purchase_order/{purchase_order_contract_id}/line_items
    def create_purchase_order_contract_line_item (amount,cost_code_id,po_id,project_id)
      create(
        "purchase_order_contracts/#{po_id}/line_items",
        project_id: project_id,
        line_item: {
          amount: amount,
          cost_code_id: cost_code_id
        }
      )
    end

    # Commitments (purchase order)
    # DEPRECATED https://developers.procore.com/reference/rest/v1/commitments?version=1.0
    # /work_order_contracts or /purchase_order can be used as a replacement
    def list_commitments
      raise 'Deprecated - use /work_order_contracts or /purchase_order instead'
    end

    # Work Order Contracts
    # https://developers.procore.com/reference/rest/v1/work-order-contracts?version=1.0
    # GET /rest/v1.0/work_order_contracts
    def list_work_order_contracts
      list('work_order_contracts')
    end

    # Commitment Change Orders
    # https://developers.procore.com/reference/rest/v1/commitment-change-orders?version=1.0
    # GET /rest/v1.0/projects/{project_id}/commitment_change_orders
    def list_commitment_change_orders
    end

    # Requisitions (subcontractor invoices)
    # https://developers.procore.com/reference/rest/v1/requisitions-subcontractor-invoices?version=1.0
    # GET /rest/v1.0/requisitions
    #
    # Parameters
    # project_id              integer*        Unique identifier for the project.
    # page                    integer         Page
    # per_page                integer         Elements per page
    # filters[id]             array[integer]  Return item(s) with the specified IDs.
    # filters[commitment_id]  integer         Commitment ID. Returns item(s) with the specified Commitment ID.
    # filters[period_id]      integer         Billing Period ID. Returns item(s) with the specified Billing Period ID.
    # filters[status]         string          Return item(s) with the specified Requisition (Subcontractor Invoice) status. Allowed values: draft under_review revise_and_resubmit approved approved_as_noted pending_owner_approval
    # filters[created_at]     string          Return item(s) created within the specified ISO 8601 datetime range.
    # filters[updated_at]     string          Return item(s) last updated within the specified ISO 8601 datetime range.
    # filters[origin_id]      string          Origin ID. Returns item(s) with the specified Origin ID.
    def list_requisitions(project_id:, page: 1, per_page: 100, filters: {})
      list(
        'requisitions',
        project_id: project_id,
        page: page,
        per_page: per_page,
        filters: filters
      )
    end

    def create_requisition(project_id:, commitment_id:, period_id:, origin_id:)
      create(
        'requisitions',
        project_id: project_id,
        requisition: {
          commitment_id: commitment_id,
          period_id: period_id,
          origin_id: origin_id,
        }
      )
    end

    # Prime Contracts
    # https://developers.procore.com/reference/rest/v1/prime-contracts?version=1.0
    # GET /rest/v1.0/prime_contract
    def list_prime_contracts
    end

    # Prime Contract Change Orders
    def list_prime_contract_change_orders
    end

    # Prime Change Orders
    # https://developers.procore.com/reference/rest/v1/prime-change-orders?version=1.0
    # GET /rest/v1.0/projects/{project_id}/prime_change_orders
    # Returns all Prime Change Orders for the specified Project. This endpoint currently only supports projects using 1 and 2 tier change order configurations.
    #
    # Parameters
    # sort                       string   Direction (asc/desc) can be controlled by the presence or absence of '-' before the sort parameter. Allowed values: id, created_at
    # filters[id]                integer  Filter results by Change Order ID
    # filters[batch_id]          integer  Filter results by Change Order Batch ID
    # filters[legacy_package_id] integer  Filter results by legacy Change Order Package ID
    # filters[contract_id]       integer  Filter results by Contract ID
    def list_prime_change_orders(project_id:, **options)
    end

    def list(endpoint, api_version: DEFAULT_API_VERSION, **query_params)
      request(
        :get,
        endpoint,
        params: query_params,
        api_version: api_version
      )
    end

    def create(endpoint, body, api_version: DEFAULT_API_VERSION)
      request(
        :post,
        endpoint,
        body: body,
        api_version: api_version
      )
    end

    private

    def request(method, endpoint, api_version: DEFAULT_API_VERSION, **options)
      path = "/rest/#{api_version}/#{endpoint}".squeeze('/')
      options[:headers] = { 'Procore-Company-Id' => @company_id }

      response = with_retry do
        @access_token.request(method, path, options)
      end

      JSON.parse(response.body)
    end

    def with_retry
      yield
    rescue OAuth2::Error => e
      raise unless e.response.status == 401

      @access_token = @refresh_token.call
      yield
    end
  end
end
