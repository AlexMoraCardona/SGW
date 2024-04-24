class EntitiesController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @entities = Entity.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           

    end    

    def new
      @entity = Entity.new  
    end    

    def create 
        @entity = Entity.new(entity_params) 

        if @entity.save then
            redirect_to entities_path, notice: t('.created') 
        else
            render :news, status: :unprocessable_entity, alert: 'Se presento error en la creación de la entidad'
        end   
        
    end    
 
    def edit
        @entity = Entity.find(params[:id])
        @locations = Location.where(entity_id: @entity.id)
    end
    
    def update
        @entity = Entity.find(params[:id])
        
        if @entity.update(entity_params)
            
            redirect_to entities_path, notice: 'Empresa actualizada correctamente'
        else
            
            render :edit, status: :unprocessable_entity
        end         
    end    

    def destroy
        @entity = Entity.find(params[:id])
        @entity.destroy
        redirect_to entities_path, notice: 'Empresa borrada correctamente', entity: :see_other
    end    

    private

    def entity_params
        params.require(:entity).permit(:email_entity, :kind_person, :business_name, :first_name,
         :second_name, :surname, :second_surname, :economic_activity, :tax_regime, :identification_number,
          :verification_digit, :document_type_legal_representative, :document_number_legal_representative,
           :first_name_legal_representative, :second_name_legal_representative, :surname_legal_representative,
            :second_surname_legal_representative, :email_legal_representative, :phone_number_entity, :cell_entity,
             :entity_address, :entity_location_code, :entity_zone, :entity_arl, :number_workers, :risk_classification,
              :license, :logo, :agricultural_unit, :responsible_sst, :external_consultant, :pay_entity)
    end 

end  