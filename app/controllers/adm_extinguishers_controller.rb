class AdmExtinguishersController < ApplicationController
    def index 
        if  Current.user && Current.user.level > 0 && Current.user.level < 3
            if params[:entity_id].present?
                @entity = Entity.find(params[:entity_id])
                @adm_extinguishers = AdmExtinguisher.where("entity_id = ?", params[:entity_id]).order(id: :desc)
            else 
                @entities = Entity.all
            end    
        elsif Current.user && Current.user.level == 3 
            @entity = Entity.find(Current.user.entity)
            @adm_extinguishers = AdmExtinguisher.where("entity_id = ?",Current.user.entity)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     
    end  
    
    def show
        @adm_extinguisher = AdmExtinguisher.find(params[:id])
        @extinguishers = Extinguisher.where("adm_extinguisher_id = ?", @adm_extinguisher.id) if @adm_extinguisher.present?
        @template = Template.where("format_number = ? and document_vigente = ?",61,1).last  
        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Evaluacion.xlsx"'
            }
        end    
    end  
    
    def ver_extinguisher
        @adm_extinguisher = AdmExtinguisher.find(params[:id])
        @extinguishers = Extinguisher.where("adm_extinguisher_id = ?", @adm_extinguisher.id) if @adm_extinguisher.present?
        @template = Template.where("format_number = ? and document_vigente = ?",61,1).last  

        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'ver_extinguisher',
                margin: {top: 10, bottom: 10, left: 10, right: 10 },
                disable_javascript: true,
                page_size: 'letter',
                footer: {
                    right: 'Página: [page] de [topage]'
                   }                
                       } 
        end
      
    end    


    def new
      @adm_extinguisher =  AdmExtinguisher.new
      @template = Template.where("format_number = ? and document_vigente = ?",61,1).last  
    end    

    def create
        @adm_extinguisher = AdmExtinguisher.new(adm_extinguisher_params)
        if @adm_extinguisher.save then
            redirect_to adm_extinguishers_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @adm_extinguisher = AdmExtinguisher.find(params[:id])
    end
    
    def update
        @adm_extinguisher = AdmExtinguisher.find(params[:id])
        if @adm_extinguisher.update(adm_extinguisher_params)
            redirect_to adm_extinguishers_path, notice: 'Inspección actualizada correctamente'
        else
            render :edit, adm_extinguishers: :unprocessable_entity
        end         
    end    

    def destroy
        @adm_extinguisher = AdmExtinguisher.find(params[:id])
        @adm_extinguisher.destroy
        redirect_to adm_extinguishers_path, notice: 'Inspección borrada correctamente', adm_extinguisher: :see_other
    end  
    
    def crear_item_extinguisher 
        @extinguisher = Extinguisher.new  
        @extinguishers = Extinguisher.where("adm_extinguisher_id = ?", params[:id]) if params[:id].present?
    end    

    def firmar_extinguisher 
        @adm_extinguisher = AdmExtinguisher.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @adm_extinguisher.user_id == Current.user.id.to_i
                redirect_to firmar_extinguisher_adm_extinguishers_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Representante Legal."
            end    
        end
    end 
    
    
    def extinguisher_adjunto
        @extinguisher = Extinguisher.find(params[:id])
    end       

    private

    def adm_extinguisher_params
        params.require(:adm_extinguisher).permit(:firm_user, :date_firm_user, :date_creation, :area, :user_id, :entity_id, :post)
    end 

end  



