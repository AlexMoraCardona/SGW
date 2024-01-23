class TrainingsController < ApplicationController
    def index 
        if params[:entity_id].present?
            @entity = Entity.find(params[:entity_id])
            @trainings = Training.where("entity_id = ?", params[:entity_id])
        else    
            if  Current.user && Current.user.level == 1
                @entities = Entity.all
                @trainings = Training.all
            else
                redirect_to new_session_path, alert: t('common.not_logged_in')      
            end           
        end 
    end  
    
    def show
        @training = Training.find(params[:id])
        @rep = User.find(@training.user_legal_representative) if  @training.user_legal_representative.present? && @training.user_legal_representative > 0
        @adv = User.find(@training.user_adviser_sst) if  @training.user_adviser_sst.present? && @training.user_adviser_sst > 0
        @res = User.find(@training.user_responsible_sst) if  @training.user_responsible_sst.present? && @training.user_responsible_sst > 0

        @training_items = TrainingItem.where("training_id = ?", @training.id) if @training.present?
        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Evaluacion.xlsx"'
            }
        end    
    end  
    
    def ver_training
        @training = Training.find(params[:id])
        @training_items = TrainingItem.where("training_id = ?", @training.id) if @training.present?
        @rep = User.find(@training.user_legal_representative) if  @training.user_legal_representative.present? && @training.user_legal_representative > 0
        @adv = User.find(@training.user_adviser_sst) if  @training.user_adviser_sst.present? && @training.user_adviser_sst > 0
        @res = User.find(@training.user_responsible_sst) if  @training.user_responsible_sst.present? && @training.user_responsible_sst > 0

        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'ver_training',
                margin: {top: 10, bottom: 10, left: 10, right: 10 },
                disable_javascript: true,
                page_size: 'letter',
                footer: {
                    right: 'Página: [page] de [topage]'
                   }                
                       } 
        end
      
    end    


    def new
      @training =  Training.new
      @template = Template.find(97)
    end    

    def create
        @training = Training.new(training_params)
        if @training.save then
            redirect_to trainings_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @training = Training.find(params[:id])
    end
    
    def update
        @training = Training.find(params[:id])
        if @training.update(training_params)
            redirect_to trainings_path, notice: 'Cronograma actualizado correctamente'
        else
            render :edit, trainings: :unprocessable_entity
        end         
    end    

    def destroy
        @training = Training.find(params[:id])
        @training.destroy
        redirect_to trainings_path, notice: 'Cronograma borrado correctamente', training: :see_other
    end  
    
    def crear_item_training 
        @training_item = TrainingItem.new  
        @cant = 0
        @training_items = TrainingItem.where("training_id = ?", params[:id]) if params[:id].present?
        @cant = @training_items.count if @training_items.present?
        @cant = @cant + 1 
    end    

    def firmar_rep 
        @training = Training.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @training.user_legal_representative.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_rep_trainings_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Representante Legal."
            end    
        end
    end    

    def firmar_adv
        @training = Training.find_by(id: params[:id].to_i)
        if params[:format].to_i == 2
            if  @training.user_adviser_sst.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_adv_trainings_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Asesor en SST."
            end    
        end
    end    

    def firmar_res
        @training = Training.find_by(id: params[:id].to_i)
        if params[:format].to_i == 3
            if  @training.user_responsible_sst.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_res_trainings_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Responsable en SST."
            end    
        end
    end    

    private

    def training_params
        params.require(:training).permit(:year, :user_legal_representative, :user_adviser_sst, 
        :user_responsible_sst, :entity_id, :version, :code, :date_firm_legal_representative, :date_firm_adviser_sst, 
        :date_firm_responsible_sst, :firm_legal_representative, :firm_adviser_sst, :firm_responsible_sst)
    end 
end  

