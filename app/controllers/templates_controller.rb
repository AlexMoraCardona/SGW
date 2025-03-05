class TemplatesController < ApplicationController
    

    def index
        if  Current.user && Current.user.level == 1
            #@templates = Template.all.order(format_number: :desc).decorate
            @q = Template.ransack(params[:q])
            @pagy, @templates = pagy(@q.result(reference: :desc), items: 3)
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')     
             session.delete(:user_id) 
         end 
    end    

    def new
      @template = Template.new  
    end    

    def create
        @template = Template.new(template_params)

        if @template.save then
            redirect_to templates_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @template = Template.find(params[:id])
    end
    
    def update
        @template = Template.find(params[:id])
        if @template.update(template_params)
            redirect_to templates_path, notice: 'Plantilla actualizada correctamente'
        else
            render :edit, templates: :unprocessable_entity
        end         
    end    

    def destroy
        @template = Template.find(params[:id])
        @template.destroy
        redirect_to templates_path, notice: 'Plantilla borrada correctamente', template: :see_other
    end  
    
    def show
        @template = Template.where("format_number = ? and document_vigente = ?",78,1).last  
        @entity = Entity.find(Current.user.entity)

        #@templates = Template.where("document_vigente = ?",1)  
        @consultas = []
        i = 1
        @valor = 0
        while i < 100
            l = 1
            while l < 5
                consulta = Template.where("format_number = ? and version = ?",i,l).last
                if consulta.present?
                    @valor += 1
                    @consultas.push([Template.label_proceso(consulta.process_document), consulta.name, Template.label_tipodocumento(consulta.type_document), consulta.reference, Template.label_tiposoporte(consulta.type_soport), consulta.date, consulta.version, Template.label_document_vigente(consulta.document_vigente), consulta.observations, Template.label_dependencia_admin(consulta.dependence_admin), consulta.control_changes]) 
                end    
                l += 1
            end  
            i += 1
        end  
    end    

    private

    def template_params
        params.require(:template).permit(:name, :reference, :description, :standar_detail_item_id, :file, 
        :date, :version, :state, :date_updated, :format_number, :filing, :firm_representante, :firm_responsable,
        :firm_asesor, :firm_presidente_copasst, :firm_secretario_copasst, :firm_vigia, :participant_responsable, 
        :participant_representante, :participant_asesor, :participant_vigia, :participant_colaborador, 
        :type_document, :process_document, :type_soport, :name_dependence, :observations, :dependence_admin, 
        :control_changes, :not_current, :document_vigente)
    end 

end  
