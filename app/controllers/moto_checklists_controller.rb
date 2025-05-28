class MotoChecklistsController < ApplicationController
    def index 
        if  Current.user && Current.user.level > 0 && Current.user.level < 3
                #@moto_checklists = MotoChecklist.all.order(id: :desc)
                @q = MotoChecklist.ransack(params[:q])
                @pagy, @moto_checklists = pagy(@q.result(id: :desc), items: 3)
                @users = User.all

        elsif Current.user && Current.user.level == 3 
                @moto_checks = MotoChecklist.where("entity_id = ?",Current.user.entity).order(id: :desc)
                @q = @moto_checks.ransack(params[:q])
                @pagy, @moto_checklists = pagy(@q.result(id: :desc), items: 3)
                @users = User.where("entity = ?",Current.user.entity)
        elsif Current.user && Current.user.level > 3 
                @moto_checks = MotoChecklist.where("user_id = ?",Current.user.id).order(id: :desc)
                @q = @moto_checks.ransack(params[:q])
                @pagy, @moto_checklists = pagy(@q.result(id: :desc), items: 3)
                @users = User.where("entity = ?",Current.user.entity)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     
    end  
    
    def show 
        @template = Template.where("format_number = ? and document_vigente = ?",97,1).last  
        @moto_checklist = MotoChecklist.find(params[:id])
        @entity = Entity.find(@moto_checklist.entity_id) if @moto_checklist.present?
        @user_responsable = User.find(@moto_checklist.user_id)
        @user_autoriza = User.find(@moto_checklist.user_autoriza) if @moto_checklist.user_autoriza.present? && @moto_checklist.user_autoriza > 0 

        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Evaluacion.xlsx"'
            }
        end    
    end  
    
    def ver_checklist_moto_pdf
        @moto_checklist = MotoChecklist.find(params[:id])
        @entity = Entity.find(@moto_checklist.entity_id) if @moto_checklist.present?
        @template = Template.where("format_number = ? and document_vigente = ?",97,1).last  
        @user_responsable = User.find(@moto_checklist.user_id)
        @user_autoriza = User.find(@moto_checklist.user_autoriza) if @moto_checklist.user_autoriza.present? && @moto_checklist.user_autoriza > 0 

        nombre_evidencia = @template.reference.to_s + '.pdf'


        respond_to do |format| 
            format.html
            format.pdf {
                pdf = WickedPdf.new.pdf_from_string(
                    render_to_string('ver_checklist_moto_pdf'),
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
      @moto_checklist =  MotoChecklist.new
      @template = Template.where("format_number = ? and document_vigente = ?",97,1).last  
      @user = User.find(Current.user.id)
      @entity = Entity.find(Current.user.entity)
      @user_autoriza = User.find_by(id: @entity.responsible_sst) if @entity.responsible_sst.present? && @entity.responsible_sst > 0
    end    

    def create
        @moto_checklist = MotoChecklist.new(moto_checklist_params)
        if @moto_checklist.save then
            redirect_to moto_checklists_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @moto_checklist = MotoChecklist.find(params[:id])
        @user = User.find(@moto_checklist.user_id)
        @entity = Entity.find(@moto_checklist.entity_id)
        @user_autoriza = User.find(@moto_checklist.user_autoriza)  if @moto_checklist.present?
    end
    
    def update
        @moto_checklist = MotoChecklist.find(params[:id])
        if @moto_checklist.update(moto_checklist_params)
            redirect_to moto_checklists_path, notice: 'Formato actualizado correctamente'
        else
            render :edit, moto_checklists: :unprocessable_entity
        end         
    end    

    def destroy
        @moto_checklist = MotoChecklist.find(params[:id])
        @moto_checklist.destroy
        redirect_to moto_checklists_path, notice: 'Formato borrado correctamente', moto_checklist: :see_other
    end  

    def firmar_responsable_checklist_moto
        @moto_checklist = MotoChecklist.find_by(id: params[:id].to_i)
        if params[:format].to_i == 2
            if  @moto_checklist.user_id.to_i == Current.user.id.to_i
                @moto_checklist.firm_user = 1
                @moto_checklist.date_firm_user = Time.now
                if @moto_checklist.save
                    redirect_to  moto_checklists_path, notice: 'Formato actualizado correctamente', moto_checklist: :see_other
                else
                    redirect_to  moto_checklists_path, alert: 'Error en la actualización del formato', moto_checklist: :see_other
                end    
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Responsable."
            end    
        end
    end  

    def firmar_autorizado_checklist_moto
        @moto_checklist = MotoChecklist.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @moto_checklist.user_autoriza.to_i == Current.user.id.to_i
                @moto_checklist.user_autoriza_firm = 1
                @moto_checklist.user_autoriza_date = Time.now
                if @moto_checklist.save
                    redirect_to  moto_checklists_path, notice: 'Formato actualizado correctamente', moto_checklist: :see_other
                else
                    redirect_to  moto_checklists_path, alert: 'Error en la actualización del formato', moto_checklist: :see_other
                end    
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Responsable."
            end    
        end
    end  


    def adjuntar_checklist_moto
        @moto_checklist = MotoChecklist.find_by(id: params[:id].to_i)
    end

    private

    def moto_checklist_params
        params.require(:moto_checklist).permit(:date_list, :time_list, :plate_moto, :mileage, 
         :health_conditions, :health_conditions_obs, :protective_equipment, :protective_equipment_obs, 
         :tire_condition, :tire_condition_obs, :lights_condition, :lights_condition_obs, 
         :horn_condition, :horn_condition_obs, :mirrors_condition, :mirrors_condition_obs, 
         :liquids_condition, :liquids_condition_obs, :fluids_condition, :fluids_condition_obs, 
         :brakes_condition, :brakes_condition_obs, :transmission_condition, :transmission_condition_obs, 
         :documents_condition, :documents_condition_obs, :kit_condition, :kit_condition_obs, 
         :firm_user, :date_firm_user, :user_autoriza, :user_autoriza_firm, :user_autoriza_date, 
         :user_id, :entity_id, moto_files: [])
    end 
end 

      