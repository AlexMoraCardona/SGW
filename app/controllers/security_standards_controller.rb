class SecurityStandardsController < ApplicationController
    def index 
        if Current.user && Current.user.level > 0 && Current.user.level < 4 
            @entity = Entity.find(Current.user.entity)
            @security_standards = SecurityStandard.where("entity_id = ?",Current.user.entity).order(id: :desc)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     
    end  
    
    def show
        @security_standard = SecurityStandard.find(params[:id])
        @entity = Entity.find(@security_standard.entity_id) if @security_standard.present?
        @template = Template.where("format_number = ? and document_vigente = ?",112,1).last  
        @user_elaborated = User.find(@security_standard.user_elaborated) if @security_standard.user_elaborated > 0
        @user_asesor = User.find(@security_standard.user_asesor) if @security_standard.user_asesor > 0

        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Analisis.xlsx"'
            }
        end    
    end  
    
  
    def new
      @security_standard =  SecurityStandard.new
      @entity = Entity.find(Current.user.entity)
      @template = Template.where("format_number = ? and document_vigente = ?",112,1).last  
      @company_areas = CompanyArea.where("entity_id = ?",Current.user.entity.to_i) if Current.user.entity.present?
      @protection_elements = ProtectionElement.where("(entity = ? or entity = ?) and state_protection = ?",6,Current.user.entity,1)
      @user_asesor = User.find(@entity.external_consultant) if @entity.external_consultant > 0
    end    

    def create
        @security_standard = SecurityStandard.new(security_standard_params)
        user_elaborated = User.find(@security_standard.user_elaborated) if @security_standard.user_elaborated > 0
        user_asesor = User.find(@security_standard.user_asesor) if @security_standard.user_asesor > 0
        @security_standard.cargo_user_elaborated = user_elaborated.cargo_rol if user_elaborated.present?
        @security_standard.cargo_user_asesor = user_asesor.cargo_rol if user_asesor.present?

        if params[:security_standard][:danger].present?
            dangers = ''
            params[:security_standard][:danger].each do |dato|
                danger =  ClasificationDangerDetail.find(dato) if dato.present?
                if danger.present?
                    dangers << ' *' + danger.clasification_danger.name + " - " + danger.name + ", "
                end    
            end
            @security_standard.danger =  dangers if dangers.present?
        end    

        if params[:element_protection].present?
             epps = ''
            params[:element_protection].each do |dato|
                epp = ProtectionElement.find(dato) if dato.present?
                if epp.present?
                    epps << epp.name + ", "
                end    
            end
            @security_standard.element_protection =  epps if epps.present?
        end    


        if @security_standard.save then
            redirect_to security_standard_path(@security_standard.id), notice: 'Estándar creado correctamente!' 
        else
            redirect_to security_standards_path, alert: 'Se presento error en la creación.' 
        end    
    end    
 
    def edit
          @security_standard = SecurityStandard.find(params[:id])
          @entity = Entity.find(@security_standard.entity_id)
          @template = Template.where("format_number = ? and document_vigente = ?",112,1).last  
          @company_areas = CompanyArea.where("entity_id = ?",Current.user.entity.to_i) if Current.user.entity.present?
          @protection_elements = ProtectionElement.where("(entity = ? or entity = ?) and state_protection = ?",6,Current.user.entity,1)
          @user_asesor = User.find(@entity.external_consultant) if @entity.external_consultant > 0

    end
    
    def update
        @security_standard = SecurityStandard.find(params[:id])
        user_elaborated = User.find(@security_standard.user_elaborated) if @security_standard.user_elaborated > 0
        user_asesor = User.find(@security_standard.user_asesor) if @security_standard.user_asesor > 0
        @security_standard.cargo_user_elaborated = user_elaborated.cargo_rol if user_elaborated.present?
        @security_standard.cargo_user_asesor = user_asesor.cargo_rol if user_asesor.present?

        if params[:security_standard][:danger].present?
            dangers = ''
            params[:security_standard][:danger].each do |dato|
                danger =  ClasificationDangerDetail.find(dato) if dato.present?
                if danger.present?
                    dangers << ' *' + danger.clasification_danger.name + " - " + danger.name + ", "
                end    
            end
            @security_standard.danger =  dangers if dangers.present?
        end    

        if params[:element_protection].present?
             epps = ''
            params[:element_protection].each do |dato|
                epp = ProtectionElement.find(dato) if dato.present?
                if epp.present?
                    epps << epp.name + ", "
                end    
            end
            @security_standard.element_protection =  epps if epps.present?
        end    
        
        if @security_standard.update(security_standard_params)
            redirect_to security_standard_path(@security_standard.id), notice: 'Análisis actualizado correctamente'
        else
            redirect_to security_standard_path(@security_standard.id), security_standards: :unprocessable_entity
        end         
    end    

    def destroy
        @security_standard = SecurityStandard.find(params[:id])
        @security_standard.destroy
        redirect_to security_standards_path, notice: 'Estandar borrado correctamente', security_standard: :see_other
    end  

    
    def ver_security_standard
        @security_standard = SecurityStandard.find(params[:id])
        @entity = Entity.find(@security_standard.entity_id) if @security_standard.present?
        @template = Template.where("format_number = ? and document_vigente = ?",112,1).last  
        @user_elaborated = User.find(@security_standard.user_elaborated) if @security_standard.user_elaborated > 0
        @user_asesor = User.find(@security_standard.user_asesor) if @security_standard.user_asesor > 0

        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'ver_security_standard',
                margin: {top: 10, bottom: 10, left: 10, right: 10 },
                disable_javascript: true,
                page_size: 'letter',
                zoom: 0.75,
                footer: {
                    right: 'Página: [page] de [topage]'
                   }                
                       } 
        end
      
    end    

    def firma_security_elaborated
        @security_standard = SecurityStandard.find(params[:id])
        @security_standard.date_user_elaborated =  Time.now
        @security_standard.firm_user_elaborated = 1
        
        if Current.user.id == @security_standard.user_elaborated
            if @security_standard.save then
                redirect_to security_standard_path(@security_standard.id), notice: "Firmado correctamente!"
            else
                redirect_to security_standards_path, alert: "Se produjo un error en la firma." 
            end
        else
            redirect_to  security_standards_path, alert: "Su usuario no corresponde con el nombre de la firma." 
        end    

    end    

    def firma_security_asesor
        @security_standard = SecurityStandard.find(params[:id])
        @security_standard.date_user_asesor =  Time.now
        @security_standard.firm_user_asesor = 1
        
        if Current.user.id == @security_standard.user_asesor
            if @security_standard.save then
                redirect_to security_standard_path(@security_standard.id), notice: "Firmado correctamente!"
            else
                redirect_to security_standards_path, alert: "Se produjo un error en la firma." 
            end
        else
            redirect_to  security_standards_path, alert: "Su usuario no corresponde con el nombre de la firma." 
        end    

    end    


    private

    def security_standard_params
        params.require(:security_standard).permit(:code_area, :date_standard, :user_elaborated, 
        :date_user_elaborated, :firm_user_elaborated, :cargo_user_elaborated, :user_asesor, 
        :date_user_asesor, :firm_user_asesor, :cargo_user_asesor, :objetivo, :danger, 
        :type_action, :element_protection, :description_activity, :standard_security, :entity_id)
    end 

end  
   




