class TemplatesController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @templates = Template.all.order(:format_number).decorate
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
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

    private

    def template_params
        params.require(:template).permit(:name, :reference, :description, :standar_detail_item_id, :file, :date, :version, :state, :date_updated, :format_number, :filing)
    end 

end  