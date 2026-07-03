class MatrixDangerRisksController < ApplicationController
    def index  
        if  Current.user && Current.user.level > 0 && Current.user.level < 4
                @entity = Entity.find(Current.user.entity)
                @matrix_danger_risks = MatrixDangerRisk.where("entity_id = ?",@entity.id) if @entity.present?
                @cargos = CompanyPosition.listar_cargo(@entity.id) if @entity.id.present?
        elsif Current.user && Current.user.level > 3 
            @entity = Entity.find(Current.user.entity)
            @matrix_danger_risk = MatrixDangerRisk.find_by(entity_id: Current.user.entity.to_i).last
            @matrix_danger_items_total = MatrixDangerItem.where(matrix_danger_risk_id: @matrix_danger_risk.id).order(:id) if @matrix_danger_risk.present?
            @total_items = 0
            @uno = 0
            @dos = 0
            @tres = 0
            @cuatro = 0
            @cargos = CompanyPosition.listar_cargo(@entity.id) if @entity.id.present?

            if @matrix_danger_items_total.present? 
                @matrix_danger_items_total.each do |item| 
                    @total_items += 1 
                    if item.risk_level_interpretation.to_s == 'I No Aceptable' ; @uno += 1
                    elsif item.risk_level_interpretation.to_s == 'II No Aceptable' ; @dos += 1
                    elsif item.risk_level_interpretation.to_s == 'III Aceptable' ; @tres += 1
                    elsif item.risk_level_interpretation.to_s == 'IV Aceptable' ; @cuatro += 1    
                    end
                end    
            end 
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     
    end    

    def new
      @matrix_danger_risk = MatrixDangerRisk.new  
      @template = Template.where("format_number = ? and document_vigente = ?",31,1).last  
    end    

    def create
        @matrix_danger_risk = MatrixDangerRisk.new(matrix_danger_risk_params)

        if @matrix_danger_risk.save then
            redirect_to matrix_danger_risks_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @matrix_danger_risk = MatrixDangerRisk.find(params[:id])
        @template = Template.where("format_number = ? and document_vigente = ?",31,1).last  
    end
    
    def update
        @matrix_danger_risk = MatrixDangerRisk.find(params[:id])

            if @matrix_danger_risk.update(matrix_danger_risk_params)
                actualizar_fecha(@matrix_danger_risk.id)
                redirect_to matrix_danger_risk_path(@matrix_danger_risk.id), notice: 'Matriz actualizada correctamente'
            else
                render :edit, matrix_danger_risks: :unprocessable_entity
            end 
    end    

    def actualizar_fecha(id)
        @matrix_danger_risk = MatrixDangerRisk.find(id)
        @matrix_danger_risk.date_firm_legal_representative = nil if @matrix_danger_risk.firm_legal_representative.to_i == 0
        @matrix_danger_risk.date_firm_adviser_sst = nil if @matrix_danger_risk.firm_adviser_sst.to_i == 0
        @matrix_danger_risk.date_firm_responsible_sst = nil if @matrix_danger_risk.firm_responsible_sst.to_i == 0
        @matrix_danger_risk.save
    end    


    def destroy
        @matrix_danger_risk = MatrixDangerRisk.find(params[:id])
        @matrix_danger_risk.destroy
        redirect_to matrix_danger_risks_path(entity_id: @matrix_danger_risk.entity_id), notice: 'Matriz borrada correctamente', matrix_danger_risk: :see_other
    end    

    def crear_item 
        @matrix_danger_item = MatrixDangerItem.new  
        @cant = 0
        @matrix_danger_items = MatrixDangerItem.where("matrix_danger_risk_id = ?", params[:id]).order(:id) if params[:id].present?
        @cant = @matrix_danger_items.count if @matrix_danger_items.present?
        @cant = @cant + 1 
    end   
    
    def duplicar_item
        matrix_danger_item = MatrixDangerItem.find(params[:id].to_i) if params[:id].present?
        MatrixDangerRisk.duplicar_item(matrix_danger_item) if matrix_danger_item.present?
        redirect_to matrix_danger_risk_path(matrix_danger_item.matrix_danger_risk_id), notice: 'Peligro/Riesgo duplicado correctamente'
    end   
    
    def ver_matrix_danger_risk
        @matrix_danger_risk = MatrixDangerRisk.find_by(id: params[:id].to_i)
        @matrix_danger_items = MatrixDangerItem.where(matrix_danger_risk_id: params[:id].to_i).order(:id)
        @template = Template.where("format_number = ? and document_vigente = ?",31,1).last  
        @entity = Entity.find(@matrix_danger_risk.entity_id) if @matrix_danger_risk.present?
        @rep = User.find(@matrix_danger_risk.user_legal_representative) if  @matrix_danger_risk.user_legal_representative.present? && @matrix_danger_risk.user_legal_representative > 0
        @adv = User.find(@matrix_danger_risk.user_adviser_sst) if  @matrix_danger_risk.user_adviser_sst.present? && @matrix_danger_risk.user_adviser_sst > 0
        @res = User.find(@matrix_danger_risk.user_responsible_sst) if  @matrix_danger_risk.user_responsible_sst.present? && @matrix_danger_risk.user_responsible_sst > 0

    end    

    def show
        @matrix_danger_risk = MatrixDangerRisk.find_by(id: params[:id].to_i)
        @entity = Entity.find(@matrix_danger_risk.entity_id) if @matrix_danger_risk.present?
        @matrix_danger_items = MatrixDangerItem.where(matrix_danger_risk_id: @matrix_danger_risk.id).order(:id) if @matrix_danger_risk.present?
        @template = Template.where("format_number = ? and document_vigente = ?",31,1).last  
        @rep = User.find(@matrix_danger_risk.user_legal_representative) if  @matrix_danger_risk.user_legal_representative.present? && @matrix_danger_risk.user_legal_representative > 0
        @adv = User.find(@matrix_danger_risk.user_adviser_sst) if  @matrix_danger_risk.user_adviser_sst.present? && @matrix_danger_risk.user_adviser_sst > 0
        @res = User.find(@matrix_danger_risk.user_responsible_sst) if  @matrix_danger_risk.user_responsible_sst.present? && @matrix_danger_risk.user_responsible_sst > 0
        @cargos = CompanyPosition.listar_cargo(@entity.id) if @entity.present?
                @matrix_danger_items_total = MatrixDangerItem.where(matrix_danger_risk_id: @matrix_danger_risk.id).order(:id) if @matrix_danger_risk.present?
                if params[:cargo].present?
                    if params[:cargo].to_i == 1
                        @matrix_danger_items = MatrixDangerItem.where("matrix_danger_risk_id = ?",@matrix_danger_risk.id).order(:id) if params[:id].present?      
                    else    
                       @matrix_danger_items = MatrixDangerItem.where("matrix_danger_risk_id = ? and type_cargo = ?",@matrix_danger_risk.id,params[:cargo]).order(:id) if params[:id].present?      
                    end   
                elsif params[:danger_intervened].present?
                    if params[:danger_intervened].to_s == 'NO'
                       @matrix_danger_items = MatrixDangerItem.where("matrix_danger_risk_id = ? and danger_intervened = ?",@matrix_danger_risk.id,0).order(:id) if params[:danger_intervened].present?      
                    elsif params[:danger_intervened].to_s == 'SI'
                       @matrix_danger_items = MatrixDangerItem.where("matrix_danger_risk_id = ? and danger_intervened = ?",@matrix_danger_risk.id,1).order(:id) if params[:danger_intervened].present?       
                    else
                        @matrix_danger_items = MatrixDangerItem.where("matrix_danger_risk_id = ?",@matrix_danger_risk.id).order(:id) if params[:danger_intervened].present?          
                    end    
                elsif params[:risk_level_interpretation].present?
                    if params[:risk_level_interpretation].to_s == 'I No Aceptable'
                       @matrix_danger_items = MatrixDangerItem.where("matrix_danger_risk_id = ? and risk_level_interpretation = ?",@matrix_danger_risk.id,'I No Aceptable').order(:id) if params[:risk_level_interpretation].present?      
                    elsif params[:risk_level_interpretation].to_s == 'II No Aceptable'
                       @matrix_danger_items = MatrixDangerItem.where("matrix_danger_risk_id = ? and risk_level_interpretation = ?",@matrix_danger_risk.id,'II No Aceptable').order(:id) if params[:risk_level_interpretation].present?       
                    elsif params[:risk_level_interpretation].to_s == 'III Aceptable'
                       @matrix_danger_items = MatrixDangerItem.where("matrix_danger_risk_id = ? and risk_level_interpretation = ?",@matrix_danger_risk.id,'III Aceptable').order(:id) if params[:risk_level_interpretation].present?       
                    elsif params[:risk_level_interpretation].to_s == 'IV Aceptable'
                       @matrix_danger_items = MatrixDangerItem.where("matrix_danger_risk_id = ? and risk_level_interpretation = ?",@matrix_danger_risk.id,'IV Aceptable').order(:id) if params[:risk_level_interpretation].present?       
                    else
                        @matrix_danger_items = MatrixDangerItem.where("matrix_danger_risk_id = ?",@matrix_danger_risk.id).order(:id) if params[:risk_level_interpretation].present?          
                    end    
                else   
                   @matrix_danger_items = MatrixDangerItem.where(matrix_danger_risk_id: @matrix_danger_risk.id).order(:id) if @matrix_danger_risk.present?
                end    
                @total_items = 0
                @uno = 0
                @dos = 0
                @tres = 0
                @cuatro = 0
                if @matrix_danger_items_total.present? 
                    @matrix_danger_items_total.each do |item| 
                        @total_items += 1 
                        if item.risk_level_interpretation.to_s == 'I No Aceptable' ; @uno += 1
                        elsif item.risk_level_interpretation.to_s == 'II No Aceptable' ; @dos += 1
                        elsif item.risk_level_interpretation.to_s == 'III Aceptable' ; @tres += 1
                        elsif item.risk_level_interpretation.to_s == 'IV Aceptable' ; @cuatro += 1    
                        end
                    end    
                end 

    end

    def total_items
        @matrix_danger_items = MatrixDangerItem.where(matrix_danger_risk_id: params[:id]).order(:id) if params[:id].present?
    end    

    def firmar_rep 
        @matrix_danger_risk = MatrixDangerRisk.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @matrix_danger_risk.user_legal_representative.to_i == Current.user.id.to_i
                redirect_to firmar_rep_matrix_danger_risks_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Representante Legal."
            end    
        end
    end    

    def firmar_adv
        @matrix_danger_risk = MatrixDangerRisk.find_by(id: params[:id].to_i)
        if params[:format].to_i == 2
            if  @matrix_danger_risk.user_adviser_sst.to_i == Current.user.id.to_i
                redirect_to firmar_adv_matrix_danger_risks_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Asesor en SST."
            end    
        end
    end    

    def firmar_res
        @matrix_danger_risk = MatrixDangerRisk.find_by(id: params[:id].to_i)
        if params[:format].to_i == 3
            if  @matrix_danger_risk.user_responsible_sst.to_i == Current.user.id.to_i
                redirect_to firmar_res_matrix_danger_risks_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Responsable en SST."
            end    
        end
    end    

    def duplicar_mpr
        @duplicado =  MatrixDangerRisk.duplicar_mpr(params[:id].to_i)
        if  @duplicado.present?
                redirect_to matrix_danger_risks_path(entity_id: @duplicado.entity_id), notice: 'Matriz duplicada  correctamente'   
        else
                redirect_back fallback_location: root_path, alert: "Se presentó un error en la creación de la matriz."
        end    
    end    


    def resumen_pdf
        @matrix_danger_risk = MatrixDangerRisk.find(params[:id])
        @matrix_danger_items = MatrixDangerItem.where("matrix_danger_risk_id = ?", @matrix_danger_risk.id).order(:id) if @matrix_danger_risk.present?
        @entity = Entity.find(@matrix_danger_risk.entity_id)  if @matrix_danger_risk.present?
        @template = Template.where("format_number = ? and document_vigente = ?",31,1).last  
        @rep = User.find(@matrix_danger_risk.user_legal_representative) if  @matrix_danger_risk.user_legal_representative.present? && @matrix_danger_risk.user_legal_representative > 0
        @adv = User.find(@matrix_danger_risk.user_adviser_sst) if  @matrix_danger_risk.user_adviser_sst.present? && @matrix_danger_risk.user_adviser_sst > 0
        @res = User.find(@matrix_danger_risk.user_responsible_sst) if  @matrix_danger_risk.user_responsible_sst.present? && @matrix_danger_risk.user_responsible_sst > 0

        nombre_evidencia = @template.reference.to_s + '.pdf'

        respond_to do |format| 
            format.html
            format.pdf {
                pdf = WickedPdf.new.pdf_from_string(
                    render_to_string('resumen_pdf'),
                    orientation: 'Landscape',
                    zoom: 0.40,
                    disable_javascript: true,
                    margin: {top: 10, bottom: 10, left: 5, right: 5 },
                    page_size: 'letter',
                    footer: {right: '[page] de [topage]'}
                    
                  )  
                  send_data(pdf, filename: nombre_evidencia, disposition: 'attachment')      
            }
        end    
      
    end   
    
    def cargar_archivompr
       matrix_danger_risk = MatrixDangerRisk.find(params[:id]) 
       archivo = params[:archivo]

       if archivo.nil?
         redirect_back fallback_location: root_path, alert: "Debe seleccionar un archivo."
         return
       end

       MatrixDangerRisk.cargar_archivompr(archivo, matrix_danger_risk) if matrix_danger_risk.present?       
       redirect_to matrix_danger_risk_path(matrix_danger_risk.id), notice: 'Archivo importado correctamente.'
    end    

    def seleccionar_archivompr
        @matrix_danger_risk = MatrixDangerRisk.find(params[:id])
    end    

    private

    def matrix_danger_risk_params
        params.require(:matrix_danger_risk).permit(:user_legal_representative, :user_adviser_sst, 
        :user_responsible_sst, :version, :code, :entity_id, :date_create, :date_update, :date_firm_legal_representative, 
        :date_firm_adviser_sst, :date_firm_responsible_sst, :firm_legal_representative, :firm_adviser_sst, 
        :firm_responsible_sst )
    end 

end  