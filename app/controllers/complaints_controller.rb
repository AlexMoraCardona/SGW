class ComplaintsController < ApplicationController
    def index 
    end    

    def new
        if  Current.user
            @complaint = Complaint.new  
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
        end           
    end    

    def create
        @complaint = Complaint.new(complaint_params)
        @entity = Entity.find(Current.user.entity.to_i)
        @complaint.entity_id = @entity.id if @entity.present?

        if @complaint.firm_complaint == 1
            if @complaint.save then
                redirect_to home_path, notice: t('.created') 
            else
                redirect_back fallback_location: root_path, alert: "Para poder enviar la queja debe firmar el documento!"
            end
        else
            redirect_back fallback_location: root_path, alert: "Para poder enviar la queja debe firmar el documento!"
        end    
    end    
 
    def edit
        @complaint = Complaint.find(params[:id])
    end
    
    def update
        @complaint = Complaint.find(params[:id])
        if @complaint.update(complaint_params)
            redirect_to complaints_path, notice: 'Queja actualizada correctamente'
        else
            render :edit, complaints: :unprocessable_entity
        end         
    end    

    def destroy
        @complaint = Complaint.find(params[:id])
        @complaint.destroy
        redirect_to complaints_path, notice: 'Queja borrada correctamente', complaint: :see_other
    end    

    private

    def complaint_params
        params.require(:complaint).permit(:user_complaint, :user_interpose_complaint, :date_complaint, :relationship_facts, 
        :have_proof, :date_firm_complaint, :firm_complaint, :state_complaint, :entity_id, :observation, files_complaint: [])
    end 

end  

