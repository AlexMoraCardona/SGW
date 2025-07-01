class InvesUsersController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @inves_users = InvesUser.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')    
             session.delete(:user_id)  
         end           
         
    end    

    def new
      @inves_user = InvesUser.new  
      @inves_users = InvesUser.where("investigation_id = ?",params[:id])  

    end    

    def create
        @inves_user = InvesUser.new(inves_user_params)
        user = User.find(@inves_user.user_id)
        @inves_user.post = User.label_activity(user.activity) if user.present?
        @inves_user.name = user.name if user.present?

        if @inves_user.save then
            redirect_to investigations_path(params[entity_id: @inves_user.investigation.entity_id]), notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @inves_user = InvesUser.find(params[:id])
    end
    
    def update
        @inves_user = InvesUser.find(params[:id])
        if @inves_user.update(inves_user_params)
            redirect_to redirect_to fallback_location: root_path, notice: 'Investigador actualizado correctamente'
        else
            render :edit, inves_users: :unprocessable_entity
        end         
    end    

    def destroy
        @inves_user = InvesUser.find(params[:id])
        @inves_user.destroy
        redirect_to investigations_path(params[entity_id: @inves_user.investigation.entity_id]), notice: 'Investigador borrado correctamente', inves_user: :see_other
    end  
    
    def firma_inves
        @inves_user = InvesUser.find(params[:id])
        @inves_user.date_firm =  Time.now
        @inves_user.firm = 1
        
        if Current.user.id == @inves_user.user_id
            if @inves_user.save then
                redirect_to investigations_path, notice: "Firmado correctamente!"
            else
                redirect_to investigations_path, alert: "Se produjo un error en la firma." 
            end
        else
            redirect_to  investigations_path, alert: "Su usuario no corresponde con el nombre de la firma." 
        end    

    end    

    private

    def inves_user_params
        params.require(:inves_user).permit(:user_id, :name, :post, :firm, :date_firm, :investigation_id)
    end 

end  
 


      