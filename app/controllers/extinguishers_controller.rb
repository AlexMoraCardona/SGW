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
                session.delete(:user_id)  
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
        @entity = Entity.find(@extinguisher.adm_extinguisher.entity_id) if @extinguisher.present? 
    end

    def extinguisher_foto
        @extinguisher = Extinguisher.find(params[:id])
    end 

    
    def update
        ppppppp
        @extinguisher = Extinguisher.find(params[:id])
        @entity = Entity.find(@extinguisher.adm_extinguisher.entity_id) if @extinguisher.present?

        if params[:photo_data].present?

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

            @extinguisher.extinguisher_fotos.attach(
            io: file,
            filename: "foto.jpg",
            content_type: "image/jpeg"
            )

            if @extinguisher.save
                redirect_to  adm_extinguisher_path(@extinguisher.adm_extinguisher.id), notice: 'Fotografía guardada correctamente.'
            else
                render :extinguisher_foto
            end
        else
            if @extinguisher.update(extinguisher_params) 
                redirect_to  adm_extinguisher_path(@extinguisher.adm_extinguisher.id), notice: 'Extintor actualizado correctamente'
            else
                render :edit, extinguishers: :unprocessable_entity
            end         

        end

    end    

    def destroy
        @extinguisher = Extinguisher.find(params[:id])
        @extinguisher.destroy
        redirect_to adm_extinguisher_path(@extinguisher.adm_extinguisher_id), notice: 'Extintor borrado correctamente', extinguisher: :see_other 
    end 
    
    private

    def extinguisher_params
        params.require(:extinguisher).permit(:date_creation, :area, :nro, :type_extinguisher, :ability, :ring, :pressure_gauge, :barrette, :handle, :valve, :hose, :nozzle, :cylindrical_body, :decal, :medium, :signaling, :location, :area_location, :date_carga, :date_vec_carga, :observation, :firm_user, :date_firm_user, :user_id, :entity_id, :adm_extinguisher_id, extinguisher_fotos: [])
    end 

end  

