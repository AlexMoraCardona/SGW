class ComplaintsController < ApplicationController
    def index 
    end    

    def new
        if  Current.user
            @complaint = Complaint.new  
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')  
             session.delete(:user_id)    
        end           
    end    

    def create
        @complaint = Complaint.new(complaint_params)
        @entity = Entity.find(Current.user.entity.to_i)
        @complaint.entity_id = @entity.id if @entity.present?

        if @complaint.firm_complaint == 1
            @complaint.date_firm_complaint = Time.now
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
        @user = User.find(@complaint.user_complaint) if @complaint.present?

    end
    
    def update
        @complaint = Complaint.find(params[:id])
        if @complaint.update(complaint_params)
            redirect_to informe_path, notice: 'Queja actualizada correctamente'
        else
            render :edit, complaints: :unprocessable_entity
        end         
    end    

    def destroy
        @complaint = Complaint.find(params[:id])
        @complaint.destroy
        redirect_to complaints_path, notice: 'Queja borrada correctamente', complaint: :see_other
    end   
    
    def show
        if Current.user && Current.user.ccl == 1 && Current.user.level > 2 then
            @entity = Entity.find(Current.user.entity)
            @complaints = Complaint.where("entity_id = ?", @entity.id) if @entity.present?
        else
                if Current.user && Current.user.level < 3 && Current.user.level > 0 then
                    if params[:entity_id].present?  then
                        @entity = Entity.find(params[:entity_id].to_i)
                        @complaints = Complaint.where("entity_id = ?", @entity.id).order(:id) if @entity.present?
                        @complaints_pendiente = @complaints.where("state_complaint = ?", 0).count if @complaints.present?
                        @complaints_resuelto = @complaints.where("state_complaint = ?", 1).count if @complaints.present?
                        @complaints_cancelado = @complaints.where("state_complaint = ?", 2).count if @complaints.present?
                        @complaints_total = @complaints.count
                    else    
                        @entities = Entity.all
                        @complaints = Complaint.all
                        @complaints_pendiente = @complaints.where("state_complaint = ?", 0).count if @complaints.present?
                        @complaints_resuelto = @complaints.where("state_complaint = ?", 1).count if @complaints.present?
                        @complaints_cancelado = @complaints.where("state_complaint = ?", 2).count if @complaints.present?
                        @complaints_total = @complaints.count
                    end    
                else
                    redirect_to new_session_path, alert: 'Ingreso no permitido'
                    session.delete(:user_id)
                end
        end    
    end

    def informe
        @complaint = Complaint.find(params[:id])
        @user = User.find(@complaint.user_complaint) if @complaint.present?
        @template = Template.find(55)
        @vista = 'complaints/informe/' 
        @footer = 'Nit: ' + @complaint.entity.identification_number.to_s + ', Dirección: ' + @complaint.entity.entity_address.to_s
        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'informe', 
                disable_javascript: true,
                margin: {top: 45, bottom: 25, left: 25, right: 25 },
                page_size: 'Letter',
                header: {
                         html: { 
                         template: 'complaints/header_formato'
                         }},
                footer: {
                         right: 'Página: [page] de [topage]'
                        }
                
                       } 
        end
    end

    def resumen
        @entity = Entity.find(params[:id].to_i) if params[:id].present?
        if @entity.present? then
            @complaints = Complaint.where("entity_id = ?", @entity.id).order(:id) 
        else
            @complaints = Complaint.all.order(:id) 
        end            
        @complaints_pendiente = @complaints.where("state_complaint = ?", 0).count if @complaints.present?
        @complaints_resuelto = @complaints.where("state_complaint = ?", 1).count if @complaints.present?
        @complaints_cancelado = @complaints.where("state_complaint = ?", 2).count if @complaints.present?
        @complaints_total = @complaints.count if @complaints.present?


        @vista = 'complaints/resumen/' 
        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'informe', 
                disable_javascript: true,
                margin: {top: 25, bottom: 25, left: 25, right: 25 },
                page_size: 'Letter'
                 } 
        end
    end

    private

    def complaint_params
        params.require(:complaint).permit(:user_complaint, :user_interpose_complaint, :date_complaint, :relationship_facts, 
        :have_proof, :date_firm_complaint, :firm_complaint, :state_complaint, :entity_id, :observation, files_complaint: [])
    end  

end  

