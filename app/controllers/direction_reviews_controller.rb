class DirectionReviewsController < ApplicationController
    def index 
        if  Current.user && Current.user.level > 0 && Current.user.level < 3
            if params[:entity_id].present?
                @entity = Entity.find(params[:entity_id])
                @direction_reviews = DirectionReview.where("entity_id = ?", params[:entity_id]).order(id: :desc)
            else 
                @entities = Entity.all
            end    
        elsif Current.user && Current.user.level > 2 && Current.user.level < 5
            @entity = Entity.find(Current.user.entity)
            @direction_reviews = DirectionReview.where("entity_id = ?",Current.user.entity)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     
    end  
    
    def show 
        @direction_review = DirectionReview.find(params[:id])
        @entity = Entity.find(@direction_review.entity_id) if @direction_review.present?
        @rep = User.find(@direction_review.user_representante)
        @template = Template.where("reference = ? and version = ?",@direction_review.code,@direction_review.version).last  
        @template_versions = Template.where(reference: @template.reference, standar_detail_item_id: @template.standar_detail_item_id).order(:date, :version) if @template.present?

        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Evaluacion.xlsx"'
            }
        end    
    end  
    
    def ver_review_pdf
        @direction_review = DirectionReview.find(params[:id])
        @entity = Entity.find(@direction_review.entity_id) if @direction_review.present?
        @rep = User.find(@direction_review.user_representante)
        @template = Template.where("reference = ? and version = ?",@direction_review.code,@direction_review.version).last  
        @template_versions = Template.where(reference: @template.reference, standar_detail_item_id: @template.standar_detail_item_id).order(:date, :version) if @template.present?

        nombre_archivo = @template.reference.to_s + '.pdf'
        respond_to do |format| 
            format.html
            format.pdf {header_html = render_to_string( partial: 'templates/header')
                pdf = WickedPdf.new.pdf_from_string(
                    render_to_string('ver_review_pdf'),
                    disable_javascript: true,
                    margin: {top: 50, bottom: 10, left: 5, right: 5 },
                    page_size: 'letter',
                    header: {spacing: 5,
                    content: header_html}
                )  
                send_data(pdf, filename: nombre_archivo, disposition: 'attachment')      
            }
        end    

     
    end    


    def new
      @direction_review =  DirectionReview.new
      @template = Template.where("reference = ? and document_vigente = ?",'RAD-SST',1).last  
    end    

    def create
        @direction_review = DirectionReview.new(direction_review_params)
        if @direction_review.save then
            redirect_to direction_reviews_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @direction_review = DirectionReview.find(params[:id])
    end
    
    def update
        @direction_review = DirectionReview.find(params[:id])
        if @direction_review.update(direction_review_params)
            redirect_to direction_review_path(@direction_review.id), notice: 'Informe actualizado correctamente'
        else
            render :edit, direction_reviews: :unprocessable_entity
        end         
    end    

    def destroy
        @direction_review = DirectionReview.find(params[:id])
        @direction_review.destroy
        redirect_to direction_reviews_path, notice: 'Informe borrado correctamente', direction_review: :see_other
    end  
     
    def actualizar_fecha(id)
        @direction_review = DirectionReview.find(id)
        @direction_review.date_firm_representante = nil if @direction_review.firm_representante.to_i == 0
        @direction_review.save
    end      

    def firmar_representante_review 
        @direction_review = DirectionReview.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @direction_review.user_representante.to_i == Current.user.id.to_i
                actualizar_fecha(@direction_review.id)
                redirect_to firmar_representante_review_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Representante Legal."
            end    
        end
    end    

    private

    def direction_review_params
        params.require(:direction_review).permit(:user_representante, :date_firm_representante, :firm_representante, :date_review, :g1, :r1, :g2, :r2, :g3, :r3, :g4, :r4, :g5, :r5, :g6, :r6, :g7, :r7, :g8, :r8, :g9, :r9, :g10, :r10, :g11, :r11, :g12, :r12, :g13, :r13, :g14, :r14, :g15, :r15, :g16, :r16, :g17, :r17, :g18, :r18, :g19, :r19, :g20, :r20, :g21, :r21, :g22, :r22, :g23, :r23, :g24, :r24, :entity_id, :version, :code)
    end 
end  




