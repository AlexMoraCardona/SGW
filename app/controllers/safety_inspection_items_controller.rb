class SafetyInspectionItemsController < ApplicationController
    def index 
        if  Current.user && Current.user.level == 1
            @safety_inspection_items = SafetyInspectionItem.all.order(:id)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')   
            session.delete(:user_id)   
        end           
    end  
    
    def new
      @safety_inspection_item = SafetyInspectionItem.new  
    end    

    def create
        @safety_inspection_item = SafetyInspectionItem.new(safety_inspection_item_params)

        if @safety_inspection_item.save then
            redirect_back fallback_location: root_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @safety_inspection_item = SafetyInspectionItem.find(params[:id])
    end
    
    def update
        @safety_inspection_item = SafetyInspectionItem.find(params[:id])
        @safety_inspection = SafetyInspection.find(@safety_inspection_item.safety_inspection_id) if @safety_inspection_item.present?

        if params[:photo_data].present?
            nom_foto = "foto"
            if params[:photo_name].present? 
                unless params[:photo_name].blank?
                    nom_foto = params[:photo_name].to_s.strip 
                end    
                unless nom_foto.match?(/\A[A-Za-zÁÉÍÓÚáéíóúÑñ0-9 _-]+\z/)
                    flash[:error] = "El nombre de la fotografía no es válido."
                    redirect_back(fallback_location: root_path)
                    return
                end 
            end

            image = params[:photo_data]

            image = image.sub(
              /^data:image\/jpeg;base64,/,
            ""
            )

            decoded = Base64.decode64(image)

            file = Tempfile.new(["foto", ".jpg"])

            file.binmode

            file.write(decoded)

            file.rewind

            @safety_inspection_item.inspection_evidences.attach(
            io: file,
            filename: nom_foto + ".jpg",
            content_type: "image/jpeg"
            )
 
            if @safety_inspection_item.save
                redirect_to  situacion_condicion_path(@safety_inspection_item.safety_inspection_id), notice: 'Fotografía guardada correctamente.'
            else
                render :situacion_foto
            end
        else
            if @safety_inspection_item.update(safety_inspection_item_params)
                #redirect_to edit_safety_inspection_item_path(@safety_inspection_item.id), notice: 'Inspección actualizada correctamente'
                redirect_to  situacion_condicion_path(@safety_inspection_item.safety_inspection_id), notice: 'Inspección actualizada correctamente'
            else
                render :edit, safety_inspections: :unprocessable_entity
            end         
        end
    end    

    def destroy
        @safety_inspection_item = SafetyInspectionItem.find(params[:id])
        @safety_inspection_item.destroy
        redirect_to safety_inspection_items_path, notice: 'Condición o situación borrada correctamente', safety_inspection_item: :see_other
    end    

    private

    def safety_inspection_item_params
        params.require(:safety_inspection_item).permit(:state_compliance, :observation, :safety_inspection_id, :situation_condition_id, 
                        :recommendations, :proposed_intervention, inspection_evidences: [])
    end  
end  

