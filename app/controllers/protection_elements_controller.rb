class ProtectionElementsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @protection_elements = ProtectionElement.all 
        else
             redirect_to new_session_path, alert: t('common.not_logged_in')  
             session.delete(:user_id)    
         end           
    end    

    def new
      @protection_element = ProtectionElement.new  
    end    

    def create
        @protection_element = ProtectionElement.new(protection_element_params)

        if @protection_element.save then
            redirect_to protection_elements_path, notice: t('.created') 
        else
            render :new, protection_elements: :unprocessable_entity
        end    
    end    
 
    def edit
        @protection_element = ProtectionElement.find(params[:id])
    end
    
    def update
        @protection_element = ProtectionElement.find(params[:id])
        if @protection_element.update(protection_element_params)
            redirect_to protection_elements_path, notice: 'Elemento de protección actualizado correctamente'
        else
            render :edit, status: :unprocessable_entity
        end         
    end    

    def destroy
        @protection_element = ProtectionElement.find(params[:id])
        @protection_element.destroy
        redirect_to protection_elements_path, notice: 'Elemento de protección borrado correctamente', protection_element: :see_other
    end    

    private

    def protection_element_params
        params.require(:protection_element).permit(:name, :body_protect, :rule_protection, :durability, 
        :date_sheet, :delivery_format, :personal_induction, :state_protection, :img_elem, :cost_element, 
        :cant_person_use, :prom_person_use, :total_anual_person, :stok_min, :proveedor_element, :technical_sheet, :entity)
    end 

end    

