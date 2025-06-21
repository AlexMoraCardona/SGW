class ProvidesProtectionsController < ApplicationController
    def index
        if  Current.user && Current.user.level > 0 && Current.user.level < 3
            if params[:entity_id].present?
                @entity = Entity.find(params[:entity_id])
                @provides_protections = ProvidesProtection.where("entity_id = ?", params[:entity_id]).order(id: :desc)
            else 
                @entities = Entity.all
            end    
        elsif Current.user && Current.user.level == 3 
            @entity = Entity.find(Current.user.entity)
            @provides_protections = ProvidesProtection.where("entity_id = ?",Current.user.entity)
        elsif Current.user && Current.user.level > 3 
            @entity = Entity.find(Current.user.entity)
            @provides_protections = ProvidesProtection.where("entity_id = ? and user_colaborador = ?",Current.user.entity, Current.user.id)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     
    end  
    
    def show
        @template = Template.where("format_number = ? and document_vigente = ?",53,1).last  
        @provides_protection = ProvidesProtection.find(params[:id])
        @provides_protection_items = ProvidesProtectionItem.where("provides_protection_id = ?", @provides_protection.id) if @provides_protection.present?
        @colaborador = User.find(@provides_protection.user_colaborador)  if    @provides_protection.user_colaborador.to_i > 0
        @responsable = User.find(@provides_protection.user_responsible)  if    @provides_protection.user_responsible.to_i > 0
        @entity = Entity.find(@provides_protection.entity_id) if @provides_protection.present?
        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Evaluacion.xlsx"'
            }
        end    
    end  
    
    def ver_info_provide
        @template = Template.where("format_number = ? and document_vigente = ?",53,1).last  
        @provides_protection = ProvidesProtection.find(params[:id])
        @provides_protection_items = ProvidesProtectionItem.where("provides_protection_id = ?", @provides_protection.id) if @provides_protection.present?
        @colaborador = User.find(@provides_protection.user_colaborador)  if    @provides_protection.user_colaborador.to_i > 0
        @responsable = User.find(@provides_protection.user_responsible)  if    @provides_protection.user_responsible.to_i > 0
        @entity = Entity.find(@provides_protection.entity_id) if @provides_protection.present?

        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'ver_provides_protection',
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
      @provides_protection = ProvidesProtection.new  
      @template = Template.where("format_number = ? and document_vigente = ?",53,1).last  
    end    

    def create
        @provides_protection = ProvidesProtection.new(provides_protection_params)
        @user_colaborador  = User.find(@provides_protection.user_colaborador.to_i) if @provides_protection.user_colaborador.present?
        @provides_protection.post_colaborador = User.label_activity(@user_colaborador.activity) if @user_colaborador.present?
        @provides_protection.unit_colaborador = User.label_area_employee(@user_colaborador.area_employee) if @user_colaborador.present?

        if @provides_protection.save then
            redirect_to provides_protections_path(entity_id: Current.user.entity.to_i), notice: t('.created') 
        else
            render :new, provides_protections: :unprocessable_entity
        end    
    end    
 
    def edit
        @provides_protection = ProvidesProtection.find(params[:id])
    end
    
    def update
        @provides_protection = ProvidesProtection.find(params[:id])
        if @provides_protection.update(provides_protection_params)
            actualizar_fecha(@provides_protection.id)
            redirect_to provides_protections_path(entity_id: Current.user.entity.to_i), notice: 'Formato  actualizado correctamente'
        else
            render :edit, status: :unprocessable_entity
        end         
    end 
    
    def actualizar_fecha(id)
        @provides_protection = ProvidesProtection.find(id)
        @provides_protection.date_firm_colaborador = nil if @provides_protection.firm_colaborador.to_i == 0
        @provides_protection.date_firm_responsible = nil if @provides_protection.firm_responsible.to_i == 0
        @provides_protection.save
    end    
    

    def destroy 
        @provides_protection = ProvidesProtection.find(params[:id])
        @provides_protection.destroy
        redirect_to provides_protections_path, notice: 'Formato borrado correctamente', provides_protection: :see_other
    end    

    def crear_item_provide
        @protection_elements = ProtectionElement.all
        @provides_protection_item = ProvidesProtectionItem.new  
        @cant = 0
        @provides_protection_items = ProvidesProtectionItem.where("provides_protection_id = ?", params[:id]) if params[:id].present?
        @cant = @provides_protection_items.count if @provides_protection_items.present?
        @cant = @cant + 1 
    end    


    def firmar_colaborador
        @provides_protection = ProvidesProtection.find_by(id: params[:id].to_i)
        if params[:format].to_i == 2
            if  @provides_protection.user_colaborador.to_i == Current.user.id.to_i 
                redirect_to firmar_colaborador_provides_protections_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Colaborador en SST."
            end    
        end
    end    

    def firmar_responsable
        @provides_protection = ProvidesProtection.find_by(id: params[:id].to_i)
        if params[:format].to_i == 3
            if  @provides_protection.user_responsible.to_i == Current.user.id.to_i
                redirect_to firmar_responsable_provides_protections_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Responsable en SST."
            end    
        end
    end    

    private

    def provides_protection_params
        params.require(:provides_protection).permit(:user_colaborador, :user_responsible, :version, :code, :date_firm_colaborador, :date_firm_responsible, :firm_colaborador, :firm_responsible, :post_colaborador, :unit_colaborador, :entity_id)
    end 

end    

