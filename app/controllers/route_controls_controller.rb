class RouteControlsController < ApplicationController
    def index
            if  Current.user && Current.user.level > 0 && Current.user.level < 4
                @route_controles = RouteControl.all.order(id: :desc)
                @q = @route_controles.ransack(params[:q])
                @pagy, @route_controls = pagy(@q.result(id: :desc), items: 3)
                @users = User.all

            elsif Current.user && Current.user.level > 3
                @route_controles = RouteControl.where("user_create = ?",Current.user.id).order(id: :desc)
                @q = @route_controles.ransack(params[:q])
                @pagy, @route_controls = pagy(@q.result(id: :desc), items: 3)
                @users = User.where("entity = ?",Current.user.entity)
            else
                redirect_to new_session_path, alert: t('common.not_logged_in')    
                session.delete(:user_id)  
            end           

        end    

    def new
      @route_control = RouteControl.new  
    end    

    def create
        @route_control = RouteControl.new(route_control_params)

        if @route_control.save then
            redirect_to route_controls_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @route_control = RouteControl.find(params[:id])
        @entity = Entity.find(@route_control.user.entity) if @route_control.present?
    end
    
    def show
        @route_control = RouteControl.find(params[:id])
        @entity = Entity.find(@route_control.user.entity) if @route_control.present?
        @template = Template.where("format_number = ? and document_vigente = ?",96,1).last  
    end

    def update
        @route_control = RouteControl.find(params[:id])
        if @route_control.update(route_control_params)
            redirect_to route_controls_path, notice: 'Ruta de control actualizada correctamente'
        else
            render :edit, route_controls: :unprocessable_entity
        end         
    end    

    def destroy
        @route_control = RouteControl.find(params[:id])
        @route_control.destroy
        redirect_to route_controls_path, notice: 'Ruta de control borrada correctamente', route_control: :see_other
    end    

    def pdf_informe_route_control
        @route_control = RouteControl.find(params[:id])
        @entity = Entity.find(@route_control.user.entity) if @route_control.present?
        @template = Template.where("format_number = ? and document_vigente = ?",96,1).last  

        nombre_evidencia = @template.reference.to_s + '.pdf'


        respond_to do |format| 
            format.html
            format.pdf {
                pdf = WickedPdf.new.pdf_from_string(
                    render_to_string('pdf_informe_route_control'),
                    disable_javascript: true,
                    margin: {top: 20, bottom: 15, left: 15, right: 15 },
                    page_size: 'letter',
                    footer: {right: '[page] de [topage]'}
                    
                  )  
                  send_data(pdf, filename: nombre_evidencia, disposition: 'attachment')      
            }
        end    
      
    end 
    
    def control_hora_inicio
        @route_control = RouteControl.find(params[:id]) if params[:id].present?
        
        if @route_control.present?
            if @route_control.date_control == Date.today
                if @route_control.user_create == Current.user.id
                    @route_control.time_initial_control = Time.now
                    if @route_control.save then
                        redirect_to route_controls_path, notice: t('.created') 
                    else
                        redirect_to route_controls_path, status: :unprocessable_entity
                    end
                else
                    redirect_to route_controls_path, alert: 'Su usuario no corresponde con el usuario conductor.'
                end
            else
                redirect_to route_controls_path, alert: 'El día no corresponde con la fecha asignada para ruta.'
            end    
        else
            render :route_controls_path, status: :unprocessable_entity
        end    
    end 

    def control_hora_final
        @route_control = RouteControl.find(params[:id]) if params[:id].present?
        if @route_control.present?
            if @route_control.date_control == Date.today
                if @route_control.user_create == Current.user.id
                    @route_control.time_final_control = Time.now

                    if @route_control.save then
                        redirect_to route_controls_path, notice: t('.created') 
                    else
                        redirect_to route_controls_path, status: :unprocessable_entity
                    end              
                else
                    redirect_to route_controls_path, alert: 'Su usuario no corresponde con el usuario conductor.'               
                end
            else
                redirect_to route_controls_path, alert: 'El día no corresponde con la fecha asignada para ruta.'             
            end    
        else
            render :route_controls_path, status: :unprocessable_entity
        end    
    end 
    

    private

    def route_control_params
        params.require(:route_control).permit(:date_control, :observation, :time_initial_control, 
        :time_final_control, :place, :vehicle_type, :user_id, :user_create, :entity)
    end 

end  

      
