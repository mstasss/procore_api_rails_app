class ProjectsService
    def seed_project(data={})
        data[:vendor_check_box] ||= true #should remove these once checkboxes work
        data[:po_check_box] ||= true

        puts data
        # if vendor_check_box create_vendor(vendor_name)
        # if po_check_box create_po(:project_id, po_vendor, po_line_amount)
        #take params from seedscontroller
        #if vendor, just create a vendor
        #if just po info, just create a po
    end

    def create_vendor
    end

    def create_po
        response = api_client.create_purchase_order(@project_id, @vendor).with_indifferent_access
        @purchase_order = PurchaseOrder.new(name: response["name"])
    end

    def api_client
        #lazy initialize for api client apiclient.new, store api client in variable
        @api_client ||= Procore::ApiClient.new
    end
end