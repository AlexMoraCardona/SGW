class KitsController < ApplicationController
    def index
        if  Current.user && Current.user.level > 0 && Current.user.level < 3
            if params[:entity_id].present?
                @entity = Entity.find(params[:entity_id])
                @kits = Kit.where("entity_id = ?", params[:entity_id]).order(id: :desc)
            else 
                @entities = Entity.all
            end    
        elsif Current.user && Current.user.level == 3 
            @entity = Entity.find(Current.user.entity)
            @kits = Kit.where("entity_id = ?",Current.user.entity)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     
       
    end    

    def new
      @kit = Kit.new  
    end    

    
    def create
        @kit = Kit.new(kit_params)

        if @kit.save then
            redirect_to kits_path, notice: 'Inspección de botiquín de primeros auxilios creada correctamente', calendar: :see_other
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @kit = Kit.find(params[:id])
        @entity = Entity.find(@kit.entity_id) if @kit.present?
    end
    
    def update
        @kit = Kit.find(params[:id])
        if @kit.update(kit_params)
            actualizar_fecha(@kit.id) 
            redirect_to kits_path(entity_id: @kit.entity_id), notice: 'Inspección de botiquín de primeros auxilios actualizada correctamente'
        else
            render :edit, kits: :unprocessable_entity
        end         
    end    

    def destroy
        @kit = Kit.find(params[:id])
        @kit.destroy
        redirect_to kits_path, notice: 'Inspección de botiquín de primeros auxilios borrada correctamente', kit: :see_other
    end 
    
    def firmar_kit
        @kit = Kit.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @kit.user_id.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_kit_kits_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Representante Legal."
            end    
        end


    end

    def show
        @kit = Kit.find(params[:id])
        @template = Template.where("format_number = ? and document_vigente = ?",60,1).last  
    end    

    def kit_adjunto
        @kit = Kit.find(params[:id])
    end    

    def kit_pdf
        @kit = Kit.find(params[:id])
        @template = Template.where("format_number = ? and document_vigente = ?",60,1).last  
        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'kit_pdf',
                margin: {top: 10, bottom: 10, left: 10, right: 10 },
                disable_javascript: true,
                page_size: 'letter',
                footer: {
                    right: 'Página: [page] de [topage]'
                   }                
                       } 
        end
    end

    def actualizar_fecha(id)
        @kit = Kit.find(id)
        @kit.date_firm_user = nil if @kit.firm_user.to_i == 0
        @kit.save
    end       


    private

    def kit_params
        params.require(:kit).permit(:date_creation, :area, :type_kit, :clasification_kit, :gauze, :gauze_obs, :sticking_plaster, :sticking_plaster_obs, :tongue_depressor, :tongue_depressor_obs, :gloves, :gloves_obs, :elastic_bandage25, :elastic_bandage25_obs, :elastic_bandage55, :elastic_bandage55_obs, :sell_cotton35, :sell_cotton35_obs, :sell_cotton55, :sell_cotton55_obs, :soap, :soap_obs, :saline_solution, :saline_solution_obs, :thermometer, :thermometer_obs, :alcohol, :alcohol_obs, :sterile_gauze, :sterile_gauze_obs, :dressing, :dressing_obs, :scissors, :scissors_obs, :flashlight, :flashlight_obs, :batteries, :batteries_obs, :spinal_board, :spinal_board_obs, :adult_cervical_collar, :adult_cervical_collar_obs, :child_cervical_collar, :child_cervical_collar_obs, :adult_immobilizers_top, :adult_immobilizers_top_obs, :adult_immobilizers_lower, :adult_immobilizers_lower_obs, :child_immobilizers_top, :child_immobilizers_top_obs, :child_immobilizers_lower, :child_immobilizers_lower_obs, :disposable_cups, :disposable_cups_obs, :lood_pressure_monitor, :lood_pressure_monitor_obs, :stethoscope, :stethoscope_obs, :mask_rcp, :mask_rcp_obs, :firm_user, :date_firm_user, :post, :user_id, :recomendaciones, :entity_id, kit_fotos: [])
    end 

end  

