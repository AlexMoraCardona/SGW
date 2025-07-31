class CarChecklistsController < ApplicationController
    def index 
        if  Current.user && Current.user.level > 0 && Current.user.level < 3
                @car_checks = CarChecklist.all.order(date_list: :desc)
                @q = @car_checks.ransack(params[:q])
                @pagy, @car_checklists = pagy(@q.result(id: :desc), items: 3)
                @users = User.all

        elsif Current.user && Current.user.level == 3 
                @car_checks = CarChecklist.where("entity_id = ?",Current.user.entity).order(id: :desc)
                @q = @car_checks.ransack(params[:q])
                @pagy, @car_checklists = pagy(@q.result(id: :desc), items: 3)
                @users = User.where("entity = ?",Current.user.entity)
        elsif Current.user && Current.user.level > 3 
                @car_checks = CarChecklist.where("user_id = ?",Current.user.id).order(id: :desc)
                @q = @car_checks.ransack(params[:q])
                @pagy, @car_checklists = pagy(@q.result(id: :desc), items: 3)
                @users = User.where("entity = ?",Current.user.entity)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     
    end  
    
    def show 
        @template = Template.where("format_number = ? and document_vigente = ?",98,1).last  
        @car_checklist = CarChecklist.find(params[:id])
        @entity = Entity.find(@car_checklist.entity_id) if @car_checklist.present?
        @user_responsable = User.find(@car_checklist.user_id)
        @user_autoriza = User.find(@car_checklist.user_autoriza) if @car_checklist.user_autoriza.present? && @car_checklist.user_autoriza > 0 

        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Evaluacion.xlsx"'
            }
        end    
    end  
    
    def ver_checklist_car_pdf
        @car_checklist = CarChecklist.find(params[:id])
        @entity = Entity.find(@car_checklist.entity_id) if @car_checklist.present?
        @template = Template.where("format_number = ? and document_vigente = ?",98,1).last  
        @user_responsable = User.find(@car_checklist.user_id)
        @user_autoriza = User.find(@car_checklist.user_autoriza) if @car_checklist.user_autoriza.present? && @car_checklist.user_autoriza > 0 

        nombre_evidencia = @template.reference.to_s + '.pdf'


        respond_to do |format| 
            format.html
            format.pdf {
                pdf = WickedPdf.new.pdf_from_string(
                    render_to_string('ver_checklist_car_pdf'),
                    disable_javascript: true,
                    margin: {top: 20, bottom: 15, left: 15, right: 15 },
                    page_size: 'letter',
                    footer: {right: '[page] de [topage]'}
                    
                  )  
                  send_data(pdf, filename: nombre_evidencia, disposition: 'attachment')      
            }
        end    
      
    end    


    def new
      @car_checklist =  CarChecklist.new
      @template = Template.where("format_number = ? and document_vigente = ?",98,1).last  
      @user = User.find(Current.user.id)
      @entity = Entity.find(Current.user.entity)
      @user_autoriza = User.find_by(id: @entity.responsible_sst) if @entity.responsible_sst.present? && @entity.responsible_sst > 0
    end    

    def create
        @car_checklist = CarChecklist.new(car_checklist_params)
        if @car_checklist.save then
            redirect_to car_checklists_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @car_checklist = CarChecklist.find(params[:id])
        @user = User.find(@car_checklist.user_id)
        @entity = Entity.find(@car_checklist.entity_id)
        @user_autoriza = User.find(@car_checklist.user_autoriza)  if @car_checklist.present?
    end
    
    def update
        @car_checklist = CarChecklist.find(params[:id])
        if @car_checklist.update(car_checklist_params)
            redirect_to car_checklists_path, notice: 'Formato actualizado correctamente'
        else
            render :edit, car_checklists: :unprocessable_entity
        end         
    end    

    def destroy
        @car_checklist = CarChecklist.find(params[:id])
        @car_checklist.destroy
        redirect_to car_checklists_path, notice: 'Formato borrado correctamente', car_checklist: :see_other
    end  

    def firmar_responsable_checklist_car
        @car_checklist = CarChecklist.find_by(id: params[:id].to_i)
        if params[:format].to_i == 2
            if  @car_checklist.user_id.to_i == Current.user.id.to_i
                @car_checklist.firm_user = 1
                @car_checklist.date_firm_user = Time.now
                if @car_checklist.save
                    redirect_to  car_checklists_path, notice: 'Formato actualizado correctamente', car_checklist: :see_other
                else
                    redirect_to  car_checklists_path, alert: 'Error en la actualización del formato', car_checklist: :see_other
                end    
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Responsable."
            end    
        end
    end  

    def firmar_autorizado_checklist_car
        @car_checklist = CarChecklist.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @car_checklist.user_autoriza.to_i == Current.user.id.to_i
                @car_checklist.user_autoriza_firm = 1
                @car_checklist.user_autoriza_date = Time.now
                if @car_checklist.save
                    redirect_to  car_checklists_path, notice: 'Formato actualizado correctamente', car_checklist: :see_other
                else
                    redirect_to  car_checklists_path, alert: 'Error en la actualización del formato', car_checklist: :see_other
                end    
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Responsable."
            end    
        end
    end  


    def adjuntar_checklist_car
        @car_checklist = CarChecklist.find_by(id: params[:id].to_i)
    end

    private

    def car_checklist_params
        params.require(:car_checklist).permit(:date_list, :time_list, :plate_car, :mileage,
         :health_conditions, :health_conditions_obs, :tire_condition, :tire_condition_obs,
         :lights_condition, :lights_condition_obs, :horn_condition, :horn_condition_obs,
         :mirrors_condition, :mirrors_condition_obs, :liquids_condition, :liquids_condition_obs, 
         :fluids_condition, :fluids_condition_obs, :brakes_condition, :brakes_condition_obs, 
         :windshield_condition, :windshield_condition_obs, :retention_condition, 
         :retention_condition_obs, :documents_condition, :documents_condition_obs, 
         :prevention_condition, :prevention_condition_obs, :witnesses_condition, 
         :witnesses_condition_obs, :firm_user, :date_firm_user, :user_autoriza, 
         :user_autoriza_firm, :user_autoriza_date, :user_id, :entity_id, car_files: [])
    end 
end 

      