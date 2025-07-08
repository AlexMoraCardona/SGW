class ResourcesController < ApplicationController
    def index 
        if  Current.user && Current.user.level > 0 && Current.user.level < 3
            if params[:entity_id].present?
                @entity = Entity.find(params[:entity_id])
                @resources = Resource.where("entity_id = ?", params[:entity_id]).order(id: :desc)
            else 
                @entities = Entity.all
            end    
        elsif Current.user && Current.user.level > 2 
            @entity = Entity.find(Current.user.entity)
            @resources = Resource.where("entity_id = ?",Current.user.entity)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     
    end  
    
    def show
        @resource = Resource.find(params[:id])
        @rep = User.find(@resource.user_legal_representative) if  @resource.user_legal_representative.present? && @resource.user_legal_representative > 0
        @adv = User.find(@resource.user_adviser_sst) if  @resource.user_adviser_sst.present? && @resource.user_adviser_sst > 0
        @res = User.find(@resource.user_responsible_sst) if  @resource.user_responsible_sst.present? && @resource.user_responsible_sst > 0
        @template = Template.where("format_number = ? and document_vigente = ?",30,1).last  

        @resource_items = ResourceItem.where("resource_id = ?", @resource.id) if @resource.present?
        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Evaluacion.xlsx"'
            }
        end    
    end  
    
    def ver_resource
        @resource = Resource.find(params[:id])
        @resource_items = ResourceItem.where("resource_id = ?", @resource.id) if @resource.present?
        @rep = User.find(@resource.user_legal_representative) if  @resource.user_legal_representative.present? && @resource.user_legal_representative > 0
        @adv = User.find(@resource.user_adviser_sst) if  @resource.user_adviser_sst.present? && @resource.user_adviser_sst > 0
        @res = User.find(@resource.user_responsible_sst) if  @resource.user_responsible_sst.present? && @resource.user_responsible_sst > 0
        @template = Template.where("format_number = ? and document_vigente = ?",30,1).last  

        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'ver_resource',
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
      @resource =  Resource.new
      @template = Template.where("format_number = ? and document_vigente = ?",30,1).last  

    end    

    def create
        @resource = Resource.new(resource_params)
        
        if @resource.save then
            redirect_to resources_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @resource = Resource.find(params[:id])
    end
    
    def update
        @resource = Resource.find(params[:id])
        if @resource.update(resource_params)
            redirect_to resources_path, notice: 'Recurso actualizado correctamente'
        else
            render :edit, resources: :unprocessable_entity
        end         
    end    

    def destroy
        @resource = Resource.find(params[:id])
        @resource.destroy
        redirect_to resources_path, notice: 'Recurso borrado correctamente', resource: :see_other
    end  
    
    def crear_item_resource 
        @resource_item = ResourceItem.new  
        @cant = 0
        @resource_items = ResourceItem.where("resource_id = ?", params[:id]) if params[:id].present?
        @cant = @resource_items.count if @resource_items.present?
        @cant = @cant + 1 
    end    

    def firmar_rep 
        @resource = Resource.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @resource.user_legal_representative.to_i == Current.user.id.to_i
                redirect_to firmar_rep_resources_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Representante Legal."
            end    
        end
    end    

    def firmar_adv
        @resource = Resource.find_by(id: params[:id].to_i)
        if params[:format].to_i == 2
            if  @resource.user_adviser_sst.to_i == Current.user.id.to_i
                redirect_to firmar_adv_resources_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Asesor en SST."
            end    
        end
    end    

    def firmar_res
        @resource = Resource.find_by(id: params[:id].to_i)
        if params[:format].to_i == 3
            if  @resource.user_responsible_sst.to_i == Current.user.id.to_i
                redirect_to firmar_res_resources_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Responsable en SST."
            end    
        end
    end    

    private

    def resource_params
        params.require(:resource).permit(:year, :user_legal_representative, :user_adviser_sst, 
        :user_responsible_sst, :entity_id, :version, :code, :date_firm_legal_representative, :date_firm_adviser_sst, 
        :date_firm_responsible_sst, :firm_legal_representative, :firm_adviser_sst, :firm_responsible_sst)
    end 
end  

