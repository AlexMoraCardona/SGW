class MatrixDangerRisksController < ApplicationController
    def index
        if params[:entity_id].present?
            @entity = Entity.find(params[:entity_id])
            @matrix_danger_risk = MatrixDangerRisk.find_by(entity_id: params[:entity_id])
            @matrix_danger_items = MatrixDangerItem.where(matrix_danger_risk_id: @matrix_danger_risk.id).order(:consecutive) if @matrix_danger_risk.present?

            @total_items = 0
            @uno = 0
            @dos = 0
            @tres = 0
            @cuatro = 0
            if @matrix_danger_items.present? 
                @matrix_danger_items.each do |item| 
                    @total_items += 1 
                    if item.risk_level_interpretation.to_s == 'I No Aceptable' ; @uno += 1
                    elsif item.risk_level_interpretation.to_s == 'II No Aceptable' ; @dos += 1
                    elsif item.risk_level_interpretation.to_s == 'III Aceptable' ; @tres += 1
                    elsif item.risk_level_interpretation.to_s == 'IV Aceptable' ; @cuatro += 1    
                    end
                end    
            end 

        else    
            if  Current.user && Current.user.level == 1
                @entities = Entity.all
                @matrix_danger_risks = MatrixDangerRisk.all
            else
                redirect_to new_session_path, alert: t('common.not_logged_in')   
                session.delete(:user_id)   
            end           
        end 
         
    end    

    def new
      @matrix_danger_risk = MatrixDangerRisk.new  
      @template = Template.find(94)
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
    end
    
    def update
        @matrix_danger_risk = MatrixDangerRisk.find(params[:id])

        if (params[:matrix_danger_risk][:firm_legal_representative] != nil  && @matrix_danger_risk.user_legal_representative.to_i != Current.user.id.to_i )
            redirect_to matrix_danger_risks_path, alert: "Su usuario no esta autorizado para actualizar la firma del Representante Legal."
        elsif (params[:matrix_danger_risk][:firm_adviser_sst] != nil  && @matrix_danger_risk.user_adviser_sst.to_i != Current.user.id.to_i )
            redirect_to matrix_danger_risks_path, alert: "Su usuario no esta autorizado para actualizar la firma del Asesor en SST."
        elsif (params[:matrix_danger_risk][:firm_responsible_sst] != nil  && @matrix_danger_risk.user_responsible_sst.to_i != Current.user.id.to_i )
            redirect_to matrix_danger_risks_path, alert: "Su usuario no esta autorizado para actualizar la firma del Responsable en SST."
        else     
            if @matrix_danger_risk.update(matrix_danger_risk_params)
                actualizar_fecha(@matrix_danger_risk.id)
                redirect_to matrix_danger_risks_path, notice: 'Matriz actualizada correctamente'
            else
                render :edit, matrix_danger_risks: :unprocessable_entity
            end 
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
        redirect_to matrix_danger_risks_path, notice: 'Matriz borrada correctamente', matrix_danger_risk: :see_other
    end    

    def crear_item 
        @matrix_danger_item = MatrixDangerItem.new  
        @cant = 0
        @matrix_danger_items = MatrixDangerItem.where("matrix_danger_risk_id = ?", params[:id]) if params[:id].present?
        @cant = @matrix_danger_items.count if @matrix_danger_items.present?
        @cant = @cant + 1 
    end    

    def show
        @matrix_danger_risk = MatrixDangerRisk.find_by(id: params[:id].to_i)
        @matrix_danger_items = MatrixDangerItem.where(matrix_danger_risk_id: params[:id].to_i).order(:consecutive)
        @template = Template.find(94)
        @entity = Entity.find(@matrix_danger_risk.entity_id) if @matrix_danger_risk.present?
    end

    def total_items
        @matrix_danger_items = MatrixDangerItem.where(matrix_danger_risk_id: params[:id]).order(:consecutive) if params[:id].present?
    end    

    def firmar_rep 
        @matrix_danger_risk = MatrixDangerRisk.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @matrix_danger_risk.user_legal_representative.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_rep_matrix_danger_risks_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Representante Legal."
            end    
        end
    end    

    def firmar_adv
        @matrix_danger_risk = MatrixDangerRisk.find_by(id: params[:id].to_i)
        if params[:format].to_i == 2
            if  @matrix_danger_risk.user_adviser_sst.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_adv_matrix_danger_risks_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Asesor en SST."
            end    
        end
    end    

    def firmar_res
        @matrix_danger_risk = MatrixDangerRisk.find_by(id: params[:id].to_i)
        if params[:format].to_i == 3
            if  @matrix_danger_risk.user_responsible_sst.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_res_matrix_danger_risks_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Responsable en SST."
            end    
        end
    end    


    def resumen_pdf
        @matrix_danger_risk = MatrixDangerRisk.find(params[:id])
        @matrix_danger_items = MatrixDangerItem.where("matrix_danger_risk_id = ?", @matrix_danger_risk.id).order(:consecutive) if @matrix_danger_risk.present?
        @entity = Entity.find(@matrix_danger_risk.entity_id)  if @matrix_danger_risk.present?
        @template = Template.find(94)

        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'resumen_pdf',
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

    def matrix_danger_risk_params
        params.require(:matrix_danger_risk).permit(:user_legal_representative, :user_adviser_sst, 
        :user_responsible_sst, :version, :code, :entity_id, :date_create, :date_update, :date_firm_legal_representative, 
        :date_firm_adviser_sst, :date_firm_responsible_sst, :firm_legal_representative, :firm_adviser_sst, 
        :firm_responsible_sst )
    end 

end  