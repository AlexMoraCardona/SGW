class DocumentsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @documents = Document.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')    
             session.delete(:user_id)  
         end           
         
    end    

    def new
      @document = Document.new  
    end    

    def create
        @document = Document.new(document_params)

        if @document.save then
            redirect_to documents_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @document = Document.find(params[:id])
    end
    
    def update
        @document = Document.find(params[:id])
        if @document.update(document_params)
            redirect_to documents_path, notice: 'Documento actualizado correctamente'
        else
            render :edit, documents: :unprocessable_entity
        end         
    end    

    def destroy
        @document = Document.find(params[:id])
        @document.destroy
        redirect_to documents_path, notice: 'Documento borrado correctamente', document: :see_other
    end    

    private

    def document_params
        params.require(:document).permit(:document_type, :code, :abbreviation )
    end 

end  