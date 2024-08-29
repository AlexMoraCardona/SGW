class MatrixProtectionsController < ApplicationController
    def index
        if params[:entity_id].present?
            @entity = Entity.find(params[:entity_id])
            @matrix_protections = MatrixProtection.where("entity_id = ?", params[:entity_id])
        else    
            if  Current.user && Current.user.level == 1
                @entities = Entity.all
                @matrix_protections = MatrixProtection.all
            else
                redirect_to new_session_path, alert: t('common.not_logged_in')    
                session.delete(:user_id)  
            end           
        end 
    end 
    
    def show
        @matrix_protection = MatrixProtection.find(params[:id])
        @matrix_protection_items = MatrixProtectionItem.where("matrix_protection_id = ?", @matrix_protection.id) if @matrix_protection.present?
        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Evaluacion.xlsx"'
            }
        end    
    end  
    
    def ver_matrix_protection
        @matrix_protection = MatrixProtection.find(params[:id])
        @matrix_protection_items = MatrixProtectionItem.where("matrix_protection_id = ?", @matrix_protection.id) if @matrix_protection.present?
        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'ver_matrix_protection',
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
      @matrix_protection = MatrixProtection.new  
      @template = Template.find(157)
    end    

    def create
        @matrix_protection = MatrixProtection.new(matrix_protection_params)

        if @matrix_protection.save then
            redirect_to matrix_protections_path, notice: t('.created') 
        else
            render :new, matrix_protections: :unprocessable_entity
        end    
    end    
 
    def edit
        @matrix_protection = MatrixProtection.find(params[:id])
    end
    
    def update
        @matrix_protection = MatrixProtection.find(params[:id])
        if @matrix_protection.update(matrix_protection_params)
            actualizar_fecha(@matrix_protection.id)
            redirect_to matrix_protections_path, notice: 'Matriz  actualizada correctamente'
        else
            render :edit, status: :unprocessable_entity
        end         
    end   
    
    def actualizar_fecha(id)
        @matrix_protection = MatrixProtection.find(id)
        @matrix_protection.date_firm_legal_representative = nil if @matrix_protection.firm_legal_representative.to_i == 0
        @matrix_protection.date_firm_adviser_sst = nil if @matrix_protection.firm_adviser_sst.to_i == 0
        @matrix_protection.date_firm_responsible_sst = nil if @matrix_protection.firm_responsible_sst.to_i == 0
        @matrix_protection.save
    end       

    def destroy
        @matrix_protection = MatrixProtection.find(params[:id])
        @matrix_protection.destroy
        redirect_to matrix_protections_path, notice: 'Matriz borrada correctamente', matrix_protection: :see_other
    end    

    def crear_item_protection
        @protection_elements = ProtectionElement.all
        @matrix_protection_item = MatrixProtectionItem.new  
        @cant = 0
        @matrix_protection_items = MatrixProtectionItem.where("matrix_protection_id = ?", params[:id]) if params[:id].present?
        @cant = @matrix_protection_items.count if @matrix_protection_items.present?
        @cant = @cant + 1 
    end    

    def firmar_rep 
        @matrix_protection = MatrixProtection.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @matrix_protection.user_legal_representative.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_rep_matrix_protections_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Representante Legal."
            end    
        end
    end    

    def firmar_adv
        @matrix_protection = MatrixProtection.find_by(id: params[:id].to_i)
        if params[:format].to_i == 2
            if  @matrix_protection.user_adviser_sst.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_adv_matrix_protections_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Asesor en SST."
            end    
        end
    end    

    def firmar_res
        @matrix_protection = MatrixProtection.find_by(id: params[:id].to_i)
        if params[:format].to_i == 3
            if  @matrix_protection.user_responsible_sst.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_res_matrix_protections_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Responsable en SST."
            end    
        end
    end    

    private

    def matrix_protection_params
        params.require(:matrix_protection).permit(:user_legal_representative, :user_adviser_sst, 
        :user_responsible_sst, :entity_id, :version, :code, :date_create, :date_update, :date_firm_legal_representative, :date_firm_adviser_sst, 
        :date_firm_responsible_sst, :firm_legal_representative, :firm_adviser_sst, :firm_responsible_sst)
    end 

end    