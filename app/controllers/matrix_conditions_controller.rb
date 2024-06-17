class MatrixConditionsController < ApplicationController
    def index
        if params[:entity_id].present?
            @entity = Entity.find(params[:entity_id])
            @matrix_condition = MatrixCondition.find_by(entity_id: params[:entity_id])
        else    
            if  Current.user && Current.user.level == 1
                @entities = Entity.all
                @matrix_conditions = MatrixCondition.all
            else
                redirect_to new_session_path, alert: t('common.not_logged_in')      
            end           
        end 
    end 
    
    def show
        @matrix_condition = MatrixCondition.find(params[:id])
        @matrix_unsafe_items = MatrixUnsafeItem.where("matrix_condition_id = ?", @matrix_condition.id) if @matrix_condition.present?
        @template = Template.find(196)
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
        @template = Template.find(196)
        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'ver_matrix_condition',
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
      @template = Template.find(196)
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
            redirect_to matrix_conditions_path, notice: 'Matriz  actualizada correctamente'
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
            if  @matrix_condition.user_representante.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_representante_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Representante Legal."
            end    
        end
    end    

    def firmar_responsible
        @matrix_condition = MatrixCondition.find_by(id: params[:id].to_i)
        if params[:format].to_i == 2
            if  @matrix_condition.user_responsible.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_responsible_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Asesor en SST."
            end    
        end
    end    

    private

    def matrix_condition_params
        params.require(:matrix_condition).permit(:date_unsafe, :user_representante, :user_responsible, :date_firm_representante, :date_firm_responsible, :firm_representante, :firm_responsible, :entity_id)
    end 

end 


