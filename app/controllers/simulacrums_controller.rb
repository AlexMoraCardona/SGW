class SimulacrumsController < ApplicationController
    def index 
        if Current.user && Current.user.level > 0 && Current.user.level < 4 
            @entity = Entity.find(Current.user.entity)
            @simulacrums = Simulacrum.where("entity_id = ?",Current.user.entity).order(id: :desc)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     
    end  
    
    def show
        @simulacrum = Simulacrum.find(params[:id])
        @entity = Entity.find(@simulacrum.entity_id) if @simulacrum.present?
        @template = Template.where("format_number = ? and document_vigente = ?",113,1).last  
        @simulacrum_items = SimulacrumItem.where("simulacrum_id = ?",@simulacrum.id) if @simulacrum.present?   
        @user_asesor = User.find(@simulacrum.user_asesor) if @simulacrum.user_asesor > 0
        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Analisis.xlsx"'
            }
        end    
    end  
    
  
    def new
      @simulacrum =  Simulacrum.new
      @entity = Entity.find(Current.user.entity)
      @template = Template.where("format_number = ? and document_vigente = ?",113,1).last
      @user_asesor = User.find(@entity.external_consultant) if @entity.external_consultant > 0

    end    

    def create
        @simulacrum = Simulacrum.new(simulacrum_params)
        if @simulacrum.save then
            redirect_to simulacrum_path(@simulacrum.id), notice: 'Informe simulacro creado correctamente!' 
        else
            redirect_to simulacrums_path, alert: 'Se presento error en la creación.' 
        end    
    end    
 
    def edit
          @simulacrum = Simulacrum.find(params[:id])
          @entity = Entity.find(@simulacrum.entity_id)
          @template = Template.where("format_number = ? and document_vigente = ?",113,1).last  
          @user_asesor = User.find(@entity.external_consultant) if @entity.external_consultant > 0
    end
    
    def update
        @simulacrum = Simulacrum.find(params[:id])
        
        if @simulacrum.update(simulacrum_params)
            redirect_to simulacrum_path(@simulacrum.id), notice: 'Informe simulacro actualizado correctamente'
        else
            redirect_to simulacrum_path(@simulacrum.id), simulacrums: :unprocessable_entity
        end         
    end    

    def destroy
        @simulacrum = Simulacrum.find(params[:id])
        @simulacrum.destroy
        redirect_to simulacrums_path, notice: 'Informe simulacro borrado correctamente', simulacrum: :see_other
    end  

    
    def ver_simulacro
        @simulacrum = Simulacrum.find(params[:id])
        @entity = Entity.find(@simulacrum.entity_id) if @simulacrum.present?
        @template = Template.where("format_number = ? and document_vigente = ?",113,1).last  
        @simulacrum_items = SimulacrumItem.where("simulacrum_id = ?",@simulacrum.id) if @simulacrum.present?   
        @user_asesor = User.find(@entity.external_consultant) if @entity.external_consultant > 0

        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'ver_simulacrum',
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

    def firma_simulacro
        @simulacrum = Simulacrum.find(params[:id])
        @simulacrum.date_user_asesor =  Time.now
        @simulacrum.firm_user_asesor = 1
        
        if Current.user.id == @simulacrum.user_asesor
            if @simulacrum.save then
                redirect_to simulacrum_path(@simulacrum.id), notice: "Firmado correctamente!"
            else
                redirect_to simulacrums_path, alert: "Se produjo un error en la firma." 
            end
        else
            redirect_to  simulacrums_path, alert: "Su usuario no corresponde con el nombre de la firma." 
        end    

    end    

    def crear_item_simulacro
        @simulacrum_item = SimulacrumItem.new
        @simulacrum = Simulacrum.find(params[:id].to_i)  
        @simulacrum_items = SimulacrumItem.where("simulacrum_id = ?",@simulacrum.id) if @simulacrum.present?
    end    


    private

    def simulacrum_params
        params.require(:simulacrum).permit(:date_simulacrum, :year, :user_asesor, 
        :date_user_asesor, :firm_user_asesor, :time_simulacrum, :municipality, 
        :preparation, :type_emergency, :time_warning_signal, :time_alarm_signal, 
        :time_arrival, :support_group, :cel_emergency, :conclusions, :entity_id, :recommendations, simulacro_files: [])
    end 

end  
   