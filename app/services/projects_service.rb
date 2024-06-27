class ProjectsService
  def initialize(api_client)
    @api_client = api_client
  end

  def seed_project(data = {})
    data[:vendor_check_box] ||= true #should remove these once checkboxes work
    data[:po_check_box] ||= true

    puts data
    # if vendor_check_box create_vendor(vendor_name)
    # if po_check_box create_po(:project_id, po_vendor, po_line_amount)
    #take params from seedscontroller
    #if vendor, just create a vendor
    #if just po info, just create a po
  end

  def get_all_projects
    response = api_client.list_projects
    response.map(&:symbolize_keys)
  end

  def get_one_project(project_id)
    response = api_client.list_projects(filters: { id: project_id })
    response.sole.symbolize_keys
  end

  def create_vendor
  end

  def create_po
    response = api_client.create_purchase_order(@project_id, @vendor).with_indifferent_access
    @purchase_order = PurchaseOrder.new(name: response["name"])
  end

  private
  attr_reader :api_client
end
