module Procore
  class ApiClient
    # Service Account Credentials
    # SA_CLIENT_ID = ENV['SA_CLIENT_ID']
    # SA_CLIENT_SECRET = ENV['SA_CLIENT_SECRET']
    SA_CLIENT_ID="672393d553d917cd401af97d43bfb34ac356575aed2ff99d5eb2017319f81a2b"
    SA_CLIENT_SECRET="7d74b89d4fab3ad5e919985409cf63441ce72b3acf9730bca0a513f0aef75654"
    COMPANY_ID=4264590

    attr_reader :company_id

    # OAuth URL
    OAUTH_URL = 'https://sandbox.procore.com/oauth/token'

    BASE_API_URL = 'https://sandbox.procore.com/rest/'
    DEFAULT_API_VERSION = 'v1.0'

    def initialize(company_id=COMPANY_ID)
      @company_id = company_id
    end

    def list_projects
      list('projects')
    end

    def list_vendors
      list('vendors',company_id: company_id)
    end


    def create_vendor(name)
      create('vendors', { name: name, company_id: company_id })
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

    # Purchase Order Contracts
    # https://developers.procore.com/reference/rest/v1/purchase-order-contracts?version=1.0
    # GET /rest/v1.0/purchase_order
    def list_purchase_order(project_id)
      list('purchase_order_contracts', project_id: project_id)
    end

    # def list(endpoint, **query_params)
    #   url = build_url(endpoint)
    #   http_client.get(url, query_params)
    # end

    #PROJECT ID: 117418
    #VENDOR ID: 2651489
    #
    #

    def list_cost_codes(project_id=117418)
      list('cost_codes',project_id: project_id)
    end
    # origin code
    def create_purchase_order(title,amount,cost_code_id=6112963, project_id=117418, vendor_id=2651489)
      response = create('purchase_order_contracts', project_id: project_id, company_id: company_id,
        purchase_order_contract: {
          vendor_id: vendor_id,
          title: title
        }
      )
      po_id = response["id"]
      create_purchase_order_contract_line_item(amount,cost_code_id,po_id,project_id)
    end

    #ΤΟ ADD: line items/cost codes, title

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
      list('requisitions', {
        project_id: project_id,
        page: page,
        per_page: per_page,
        filters: filters
      })
    end

    def create_requisition(project_id:, commitment_id:, period_id:, origin_id:)
      create('requisitions', {
        project_id: project_id,
        requisition: {
          commitment_id: commitment_id,
          period_id: period_id,
          origin_id: origin_id,
        }
      })
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

    def list(endpoint, **query_params)
      url = build_url(endpoint)
      http_client.get(url, query_params)
    end

    def create(endpoint, body)
      url = build_url(endpoint)
      http_client.post(url, body)
    end

    private

    def http_client
      @http_client ||= HttpClient.new(
        OAUTH_URL,
        {
          grant_type: 'client_credentials',
          client_id: SA_CLIENT_ID,
          client_secret: SA_CLIENT_SECRET
        },
        {
          'Procore-Company-Id' => @company_id
        }
      )
    end

    def build_url(endpoint, base_url: BASE_API_URL, api_version: DEFAULT_API_VERSION)
      path = "#{api_version}/#{endpoint}"
      "#{base_url.chomp('/')}/#{path.squeeze('/')}"
    end
  end
end
