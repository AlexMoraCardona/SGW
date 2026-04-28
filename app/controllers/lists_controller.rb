class ListsController < ApplicationController
    def index

        if  Current.user
            @lists = List.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')  
             session.delete(:user_id)    
         end          
         
    end    

    def new
      @list = List.new  
      @check_lists = CheckList.where("state = ?",0)
    end    

    def create
        ult = List.last
        if ult.present?
            cant = ult.numero
        else
            cant = 0
        end        
        @list = List.new(list_params)
        items = CheckListItem.where("check_list_id = ? and state = ?",@list.check_list_id,0)
        if items.present?
                cant = cant + 1
                items.each do |item|
                   @new_list = List.new 
                   @new_list.check_list_id =  item.check_list_id
                   @new_list.check_list_item_id =  item.id 
                   @new_list.entity_id =  @list.entity_id   
                   @new_list.numero = cant 
                   @new_list.clasification = item.clasification
                   @new_list.save 
                end
                redirect_to check_lists_path, notice: t('.created')     
        else
            redirect_to check_lists_path, alert: 'La lista no tiene items, se cancela la creación.'
        end
    end    
 
    def edit
        @list = List.find(params[:id])
    end

    def show
       @list = List.find(params[:id]) 
       @lists = List.where("numero = ?",@list.numero).order(:clasification, :id) if @list.present?

    end    
    
    def update 
        @list = List.find(params[:id])
        if @list.update(list_params)
            redirect_to list_path(@list.id), notice: 'Lista actualizada correctamente'
        else
            render :edit, lists: :unprocessable_entity
        end         
    end    

    def destroy
        @list = List.find(params[:id])
        @list.destroy
        redirect_to check_lists_path, notice: 'Lista borrada correctamente', list: :see_other
    end    

    def list_pdf
        @list = List.find(params[:id]) 
        @lists = List.where("numero = ?",@list.numero) if @list.present?

        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'list_pdf',
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

    def list_params
        params.require(:list).permit(:numero, :clasification, :observation, :state, :check_list_id, :check_list_item_id, :entity_id)
    end 

end  

        

