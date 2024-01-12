class MatrixLegalsController < ApplicationController
    def index 
        if params[:entity_id].present?
            @entity = Entity.find(params[:entity_id])
            @matrix_legal = MatrixLegal.find_by(entity_id: params[:entity_id])
            @matrix_legal_items = MatrixLegalItem.where(matrix_legal_id: @matrix_legal.id).order(:consecutive) if @matrix_legal.present?
            @total_items = 0
            @no = 0
            @parcial = 0
            @si = 0
            if @matrix_legal_items.present?
                @matrix_legal_items.each do |item| 
                    @total_items += 1 
                    if item.meets.to_i == 0 ; @no += 1
                    elsif item.meets.to_i == 1 ; @parcial += 1
                    elsif item.meets.to_i == 2 ; @si += 1
                    end
                end
            end     
        else    
            if  Current.user && Current.user.level == 1
                @entities = Entity.all
                @matrix_legals = MatrixLegal.all
            else
                redirect_to new_session_path, alert: t('common.not_logged_in')      
            end           
        end 
    end  
    
    def show
        @matrix_legal = MatrixLegal.find(params[:id])
        @matrix_legal_items = MatrixLegalItem.where("matrix_legal_id = ?", @matrix_legal.id) if @matrix_legal.present?
        @entity = Entity.find(@matrix_legal.entity_id) if @matrix_legal.present?
    end      

    def total_items
        @matrix_legal_items = MatrixLegalItem.where(matrix_legal_id: params[:id]).order(:consecutive) if params[:id].present?
    end    
    def new
      @matrix_legal =  MatrixLegal.new
    end    

    def create
        @matrix_legal = MatrixLegal.new(matrix_legal_params)
        @matrix_legal.date_create = Time.now
        @matrix_legal.date_update = Time.now
        if @matrix_legal.save then
            redirect_to matrix_legals_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @matrix_legal = MatrixLegal.find(params[:id])
    end
    
    def update
        @matrix_legal = MatrixLegal.find(params[:id])

        if (params[:matrix_legal][:firm_legal_representative] != nil  && @matrix_legal.user_legal_representative.to_i != Current.user.id.to_i )
            redirect_to matrix_legals_path, alert: "Su usuario no esta autorizado para actualizar la firma del Representante Legal."
        elsif (params[:matrix_legal][:firm_adviser_sst] != nil  && @matrix_legal.user_adviser_sst.to_i != Current.user.id.to_i )
            redirect_to matrix_legals_path, alert: "Su usuario no esta autorizado para actualizar la firma del Asesor en SST."
        elsif (params[:matrix_legal][:firm_responsible_sst] != nil  && @matrix_legal.user_responsible_sst.to_i != Current.user.id.to_i )
            redirect_to matrix_legals_path, alert: "Su usuario no esta autorizado para actualizar la firma del Responsable en SST."
        else
            if @matrix_legal.update(matrix_legal_params)
                actualizar_fecha(@matrix_legal.id)
                redirect_to matrix_legals_path, notice: 'Actualizado correctamente'
            else
                render :edit, matrix_legals: :unprocessable_entity
            end         
        end    
    end 
    
    def actualizar_fecha(id)
        @matrix_legal = MatrixLegal.find(id)
        @matrix_legal.date_firm_legal_representative = nil if @matrix_legal.firm_legal_representative.to_i == 0
        @matrix_legal.date_firm_adviser_sst = nil if @matrix_legal.firm_adviser_sst.to_i == 0
        @matrix_legal.date_firm_responsible_sst = nil if @matrix_legal.firm_responsible_sst.to_i == 0
        @matrix_legal.save
    end    

    def destroy
        @matrix_legal = MatrixLegal.find(params[:id])
        @matrix_legal.destroy
        redirect_to matrix_legals_path, notice: 'Matriz borrada correctamente', matrix_legal: :see_other
    end  
    
    def crear_item 
        @matrix_legal_item = MatrixLegalItem.new  
        @cant = 0
        @matrix_legal_items = MatrixLegalItem.where("matrix_legal_id = ?", params[:id]) if params[:id].present?
        @cant = @matrix_legal_items.count if @matrix_legal_items.present?
        @cant = @cant + 1 
    end    

    def crear_historia 
        @matrix_legal = MatrixLegal.find_by(id: params[:format].to_i)
        @matrix_legal_items = MatrixLegalItem.where(matrix_legal_id: params[:format].to_i)
        MatrixLegal.new_history(@matrix_legal, @matrix_legal_items)
    
        redirect_to matrix_legals_path, notice: "Finalizo la copia de la matriz legal, por favor validar"
    end  

    def ver_history 
        @history_matrix_legals = HistoryMatrixLegal.where(matrix_legal_id: params[:id]) if params[:id].present?
    end

    def firmar_rep
        @matrix_legal = MatrixLegal.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @matrix_legal.user_legal_representative.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_rep_matrix_legals_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Representante Legal."
            end    
        end
    end    

    def firmar_adv
        @matrix_legal = MatrixLegal.find_by(id: params[:id].to_i)
        if params[:format].to_i == 2
            if  @matrix_legal.user_adviser_sst.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_adv_matrix_legals_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Asesor en SST."
            end    
        end
    end    

    def firmar_res
        @matrix_legal = MatrixLegal.find_by(id: params[:id].to_i)
        if params[:format].to_i == 3
            if  @matrix_legal.user_responsible_sst.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_res_matrix_legals_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Responsable en SST."
            end    
        end
    end    

    def show_history
        @matrix_legal = HistoryMatrixLegal.find_by(id: params[:id].to_i)
        @matrix_legal_items = HistoryMatrixLegalItem.where(history_matrix_legal_id: params[:id].to_i)
    end   

    private

    def matrix_legal_params
        params.require(:matrix_legal).permit(:date_create, :date_update,
         :user_legal_representative, :user_adviser_sst, :user_responsible_sst,
         :entity_id, :date_firm_legal_representative, :date_firm_adviser_sst, :date_firm_responsible_sst, 
         :firm_legal_representative, :firm_adviser_sst, :firm_responsible_sst, :version, :code )
    end 

end  

