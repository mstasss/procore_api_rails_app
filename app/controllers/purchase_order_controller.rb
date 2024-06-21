# class PurchaseOrderController < ApplicationController
#     skip_before_action :verify_authenticity_token
#     # before_action :set_vendor, only: %i[ show edit update destroy ]
#     # GET /purchase_orders or /purchase_orders.json
#     def index
#       @purchase_order = PurchaseOrder.all
#     end

#     # GET /purchase_orders/1 or /purchase_orders/1.json
#     def show
#     end

#     # GET /purchase_orders/new
#     def new
#       @purchase_order = PurchaseOrder.new
#     end

#     # GET /purchase_orders/1/edit
#     def edit
#     end

#     #PROJECT ID: 117418
#     #VENDOR ID: 2651489

#     # POST /purchase_orders or /purchase_orders.json
#     def create
#       @project_id = params[:project_id]
#       @vendor = params[:vendor]
#       client = Procore::ApiClient.new
#       response = client.create_purchase_order(@project_id,@vendor).with_indifferent_access
#       @purchase_order = PurchaseOrder.new(name: response["name"])
#       respond_to do |format|
#         if @purchase_order.save
#           format.html { redirect_to purchase_order_url(@purchase_order), notice: "PurchaseOrder was successfully created." }
#           format.json { render :show, status: :created, location: @purchase_order }
#         else
#           format.html { render :new, status: :unprocessable_entity }
#           format.json { render json: @purchase_order.errors, status: :unprocessable_entity }
#         end
#       end
#     end

#     # PATCH/PUT /purchase_orders/1 or /purchase_orders/1.json
#     def update
#       respond_to do |format|
#         if @purchase_order.update(purchase_order_params)
#           format.html { redirect_to purchase_order_url(@purchase_order), notice: "PurchaseOrder was successfully updated." }
#           format.json { render :show, status: :ok, location: @purchase_order }
#         else
#           format.html { render :edit, status: :unprocessable_entity }
#           format.json { render json: @purchase_order.errors, status: :unprocessable_entity }
#         end
#       end
#     end

#     # DELETE /purchase_orders/1 or /purchase_orders/1.json
#     def destroy
#       @purchase_order.destroy!

#       respond_to do |format|
#         format.html { redirect_to purchase_orders_url, notice: "PurchaseOrder was successfully destroyed." }
#         format.json { head :no_content }
#       end
#     end

#     private
#       # Use callbacks to share common setup or constraints between actions.
#       def set_purchase_order
#         @purchase_order = PurchaseOrder.find(params[:id])
#       end

#       # Only allow a list of trusted parameters through.
#       def purchase_order_params
#         params.fetch(:purchase_order, {})
#       end
#   end
