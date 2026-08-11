class MatrixUnsafeItemsController < ApplicationController
    def index
         
    end    

    def new
      @matrix_unsafe_item = MatrixUnsafeItem.new  
    end    

    def create
        @matrix_unsafe_item = MatrixUnsafeItem.new(matrix_unsafe_item_params)

        if @matrix_unsafe_item.save then
            redirect_to matrix_condition_path(@matrix_unsafe_item.matrix_condition_id), notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @matrix_unsafe_item = MatrixUnsafeItem.find(params[:id])
        @unsafe_condition = UnsafeCondition.find(@matrix_unsafe_item.unsafe_condition_id) if @matrix_unsafe_item.present?
    end
    
    def update
        @matrix_unsafe_item = MatrixUnsafeItem.find(params[:id])

        if @matrix_unsafe_item.update(matrix_unsafe_item_params)
            redirect_back fallback_location: root_path, notice: 'Item actualizado correctamente'
        else
            render :edit, status: :unprocessable_entity
        end         
    end    

    def destroy
        @matrix_unsafe_item = MatrixUnsafeItem.find(params[:id])
        @matrix_unsafe_item.destroy
        redirect_back fallback_location: root_path, notice: 'Item borrado correctamente', matrix_unsafe_item: :see_other
    end   
    
    def matrix_unsafe_item_pdf
        @template = Template.where("format_number = ? and document_vigente = ?",64,1).last  
        @matrix_unsafe_item = MatrixUnsafeItem.find(params[:id])
        @unsafe_condition = UnsafeCondition.find(@matrix_unsafe_item.unsafe_condition_id) if @matrix_unsafe_item.present?
        
        @reporta = User.find(@unsafe_condition.user_reports) if  @unsafe_condition.user_reports.present? && @unsafe_condition.user_reports > 0
        @recibe = User.find(@unsafe_condition.user_receiving) if  @unsafe_condition.user_receiving.present? && @unsafe_condition.user_receiving > 0
        @coordinador = User.find(@unsafe_condition.user_coordinator) if  @unsafe_condition.user_coordinator.present? && @unsafe_condition.user_coordinator > 0


        nombre_evidencia = @template.reference.to_s + '.pdf'

        respond_to do |format| 
            format.html
            format.pdf {
                pdf = WickedPdf.new.pdf_from_string(
                    render_to_string('matrix_unsafe_item_pdf'),
                    zoom: 1,
                    disable_javascript: true,
                    margin: {top: 10, bottom: 10, left: 5, right: 5 },
                    page_size: 'letter',
                    footer: {right: '[page] de [topage]'}
                    
                  )  
                  send_data(pdf, filename: nombre_evidencia, disposition: 'attachment')      
            }
        end    

    end    

    private

    def matrix_unsafe_item_params
        params.require(:matrix_unsafe_item).permit(:date_item, :user_reporta, :cargo_reporta, :correo_reporta, :sede, :exact_ubication, :description_usafe, :solution_usafe, :tip_action, :state_unsafe, :observations, :user_recibe, :date_intervencion, :entity_id, :unsafe_condition_id, :clasification_unsafe, :matrix_condition_id, registros: [])
    end 

end 

