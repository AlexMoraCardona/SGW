class ExtinguishersController < ApplicationController
    def index
        if params[:entity_id].present?
            @entity = Entity.find(params[:entity_id])
            @extinguishers = Extinguisher.where("entity_id = ?", params[:entity_id])
        else    
            if  Current.user && Current.user.level == 1
                @entities = Entity.all
                @extinguishers = Extinguisher.all
            else
                redirect_to new_session_path, alert: t('common.not_logged_in')      
            end           
        end 
         
    end    

    def new
      @extinguisher = Extinguisher.new  
    end    

    
    def create
        @extinguisher = Extinguisher.new(extinguisher_params)
        @adm_extinguisher = AdmExtinguisher.find(@extinguisher.adm_extinguisher_id) if @extinguisher.present?

        if @extinguisher.save then
            redirect_to adm_extinguishers_path(entity_id: @adm_extinguisher.entity_id), notice: 'Inspección de extintor creado correctamente'
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @extinguisher = Extinguisher.find(params[:id])
        @entity = Entity.find(@extinguisher.entity_id) if @extinguisher.present?
    end
    
    def update
        @extinguisher = Extinguisher.find(params[:id])
        @entity = Entity.find(@extinguisher.entity_id) if @extinguisher.present?
        if @extinguisher.update(extinguisher_params)
            redirect_to adm_extinguishers_path(entity_id: @adm_extinguisher.entity_id), notice: 'Inspección de botiquín de primeros auxilios actualizada correctamente'
        else
            render :edit, extinguishers: :unprocessable_entity
        end         
    end    

    def destroy
        @extinguisher = Extinguisher.find(params[:id])
        @extinguisher.destroy
        redirect_to extinguishers_path, notice: 'Inspección de botiquín de primeros auxilios borrada correctamente', extinguisher: :see_other
    end 
    
    def matrix_prevention
        @template = Template.find(169)
        @extinguisher = Extinguisher.find(params[:id])
        @form_preventions = FormPrevention.where("extinguisher_id = ?", @extinguisher.id) if @extinguisher.present?
        @entity = Entity.find(@extinguisher.entity_id) if @extinguisher.present?
        @cant = 0
    end    
    
    def matrix_vista
        @template = Template.find(169)
        @extinguisher = Extinguisher.find(params[:id])
        @form_preventions = FormPrevention.where("extinguisher_id = ?", @extinguisher.id) if @extinguisher.present?
        @entity = Entity.find(@extinguisher.entity_id) if @extinguisher.present?
        @cant = 0
        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'matrix_vista',
                margin: {top: 10, bottom: 10, left: 10, right: 10 },
                disable_javascript: true,
                page_size: 'letter',
                footer: {
                    right: 'Página: [page] de [topage]'
                   }                
                       } 
        end
    end      

    private

    def extinguisher_params
        params.require(:extinguisher).permit(:date_creation, :area, :nro, :type_extinguisher, :ability, :ring, :pressure_gauge, :barrette, :handle, :valve, :hose, :nozzle, :cylindrical_body, :decal, :medium, :signaling, :location, :area_location, :date_carga, :date_vec_carga, :observation, :firm_user, :date_firm_user, :user_id, :entity_id, :adm_extinguisher_id, extinguisher_fotos: [])
    end 

end  

