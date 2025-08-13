class MatrixConditionsController < ApplicationController
    def index
        if  Current.user && Current.user.level > 0 && Current.user.level < 3
            if params[:entity_id].present?
                @entity = Entity.find(params[:entity_id].to_i)
                @matrix_condition = MatrixCondition.find_by(entity_id: params[:entity_id].to_i)
                indicador_matrix_condition(@matrix_condition.id) if @matrix_condition.present?
            else 
                @entities = Entity.all
            end    
        elsif Current.user && Current.user.level > 2 
            @entity = Entity.find(Current.user.entity)
            @matrix_condition = MatrixCondition.find_by(entity_id: Current.user.entity)
            indicador_matrix_condition(@matrix_condition.id) if @matrix_condition.present?
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     
    end 


    
    def show
        @matrix_condition = MatrixCondition.find(params[:id])
        @matrix_unsafe_items = MatrixUnsafeItem.where("matrix_condition_id = ?", @matrix_condition.id) if @matrix_condition.present?
        @template = Template.where("format_number = ? and document_vigente = ?",65,1).last  
        @adv = User.find(@matrix_condition.user_representante) if  @matrix_condition.user_representante.present? && @matrix_condition.user_representante > 0
        @res = User.find(@matrix_condition.user_responsible) if  @matrix_condition.user_responsible.present? && @matrix_condition.user_responsible > 0
        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Evaluacion.xlsx"'
            }
        end    
    end  
    
    def condition_pdf
        @matrix_condition = MatrixCondition.find(params[:id])
        @matrix_unsafe_items = MatrixUnsafeItem.where("matrix_condition_id = ?", @matrix_condition.id) if @matrix_condition.present?
        @template = Template.where("format_number = ? and document_vigente = ?",65,1).last  
        @adv = User.find(@matrix_condition.user_representante) if  @matrix_condition.user_representante.present? && @matrix_condition.user_representante > 0
        @res = User.find(@matrix_condition.user_responsible) if  @matrix_condition.user_responsible.present? && @matrix_condition.user_responsible > 0

        respond_to do |format| 
            format.html 
            format.pdf {render  pdf: 'ver_matrix_condition',
                orientation: 'Landscape',
                zoom: 0.80,
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
      @matrix_condition = MatrixCondition.new  
      @template = Template.where("format_number = ? and document_vigente = ?",65,1).last  
    end    

    def create
        @matrix_condition = MatrixCondition.new(matrix_condition_params)

        if @matrix_condition.save then
            redirect_to matrix_conditions_path, notice: t('.created') 
        else
            render :new, matrix_conditions: :unprocessable_entity
        end    
    end    
 
    def edit
        @matrix_condition = MatrixCondition.find(params[:id])
    end
    
    def update
        @matrix_condition = MatrixCondition.find(params[:id])
        if @matrix_condition.update(matrix_condition_params)
            actualizar_fecha(@matrix_condition.id)
            redirect_to matrix_condition_path(@matrix_condition.id), notice: 'Matriz  actualizada correctamente'
        else
            render :edit, status: :unprocessable_entity
        end         
    end   
    
    def actualizar_fecha(id)
        @matrix_condition = MatrixCondition.find(id)
        @matrix_condition.date_firm_representante = nil if @matrix_condition.firm_representante.to_i == 0
        @matrix_condition.date_firm_responsible = nil if @matrix_condition.firm_responsible.to_i == 0
        @matrix_condition.save
    end       

    def destroy
        @matrix_condition = MatrixCondition.find(params[:id])
        @matrix_condition.destroy
        redirect_to matrix_conditions_path, notice: 'Matriz borrada correctamente', matrix_condition: :see_other
    end    

    def crear_item_condition
        @matrix_unsafe_item = MatrixUnsafeItem.new
        @matrix_condition = MatrixCondition.find(params[:id].to_i)  
    end    

    def firmar_representante 
        @matrix_condition = MatrixCondition.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @matrix_condition.user_representante.to_i == Current.user.id.to_i
                redirect_to firmar_representante_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Asesor en SST."
            end    
        end
    end    

    def firmar_responsible
        @matrix_condition = MatrixCondition.find_by(id: params[:id].to_i)
        if params[:format].to_i == 2
            if  @matrix_condition.user_responsible.to_i == Current.user.id.to_i
                redirect_to firmar_responsible_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Responsable en SST."
            end    
        end
    end  
  
    def indicador_matrix_condition(matrix_condition_id)
        @total_items = 0
        @abierta_conditions = 0
        @cerrada_conditions = 0
        @total_conditions = 0
        @total_actos = 0
        @abierta_actos = 0
        @cerrada_actos = 0


        @matrix_unsafe_items = MatrixUnsafeItem.where("matrix_condition_id = ?", matrix_condition_id) if matrix_condition_id.present?
        
        if @matrix_unsafe_items.present? 
            @matrix_unsafe_items.each do |item| 
                if item.clasification_unsafe == 0;
                    @total_conditions += 1 
                    if item.state_unsafe == 0; @abierta_conditions += 1
                    else @cerrada_conditions += 1    
                    end
                end    
            end    
        end 
        @datos_matrix_conditions = []
        @datos_matrix_conditions.push(['Cerradas', @cerrada_conditions ])
        @datos_matrix_conditions.push(['Abiertas', @abierta_conditions ])

        if @matrix_unsafe_items.present? 
            @matrix_unsafe_items.each do |item| 
                if item.clasification_unsafe == 1;
                    @total_actos += 1 
                    if item.state_unsafe == 0; @abierta_actos += 1
                    else @cerrada_actos += 1    
                    end
                end    
            end    
        end 
        @datos_matrix_actos = []
        @datos_matrix_actos.push(['Cerradas', @cerrada_actos ])
        @datos_matrix_actos.push(['Abiertas', @abierta_actos ])

    end    


    private

    def matrix_condition_params
        params.require(:matrix_condition).permit(:date_unsafe, :user_representante, :user_responsible, 
                :date_firm_representante, :date_firm_responsible, :firm_representante, 
                :firm_responsible, :entity_id)
    end 

end 


