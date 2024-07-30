class EmergencyPlansController < ApplicationController
    def index
        if params[:entity_id].present?
            @entity = Entity.find(params[:entity_id])
            @emergency_plans = EmergencyPlan.where("entity_id = ?",params[:entity_id])
        else    
            if  Current.user && Current.user.level == 1
                @entities = Entity.all
                @emergency_plans = EmergencyPlan.all
            else
                redirect_to new_session_path, alert: t('common.not_logged_in')      
            end           
        end 
    end    

    def new
      @emergency_plan = EmergencyPlan.new  
    end 
    
    def show
        @emergency_plan = EmergencyPlan.find(params[:id])
        @template = Template.find(163)
        @user_responsable = User.find(@emergency_plan.user_responsible) if @emergency_plan.user_responsible > 0
        @entity = Entity.find(@emergency_plan.entity_id) if @emergency_plan.present?
        @equipement_used_plans = EquipementUsedPlan.where("emergency_plan_id = ?", @emergency_plan.id) if @emergency_plan.present?
        @brigadista_plans = BrigadistaPlan.where("emergency_plan_id = ?", @emergency_plan.id) if @emergency_plan.present?
        @res_ext_plans = ResExtPlan.where("emergency_plan_id = ?", @emergency_plan.id) if @emergency_plan.present?
        @res_int_plans = ResIntPlan.where("emergency_plan_id = ?", @emergency_plan.id) if @emergency_plan.present?
    end    

    def create
        @emergency_plan = EmergencyPlan.new(emergency_plan_params)
        if @emergency_plan.save then
            redirect_to emergency_plans_path(entity_id: @emergency_plan.entity_id), notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end     
    end    
 
    def edit
        @emergency_plan = EmergencyPlan.find(params[:id])
    end
    
    def update
        @emergency_plan = EmergencyPlan.find(params[:id])
        if @emergency_plan.update(emergency_plan_params)
            actualizar_fecha(@emergency_plan.id)
            redirect_to emergency_plans_path(entity_id: @emergency_plan.entity_id), notice: 'Plan de emergencia actualizado correctamente'
        else
            render :edit, emergency_plans: :unprocessable_entity
        end         
    end    

    def destroy
        @emergency_plan = EmergencyPlan.find(params[:id])
        @emergency_plan.destroy
        redirect_back fallback_location: root_path, notice: 'Plan de emergencia borrado correctamente', emergency_plan: :see_other
    end    
 
    def firmar_responsable_plan
        @emergency_plan = EmergencyPlan.find_by(id: params[:id].to_i)
        if params[:format].to_i == 2
            if  @emergency_plan.user_responsible.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_responsable_plan_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Responsable."
            end    
        end
    end  

    def actualizar_fecha(id)
        @emergency_plan = EmergencyPlan.find(id)
        @emergency_plan.date_firm_responsible = nil if @emergency_plan.firm_responsible.to_i == 0
        @emergency_plan.save
    end   

    def resources_ext_plan
        @emergency_plan = EmergencyPlan.find_by(id: params[:id].to_i)
        @res_ext_plans = ResExtPlan.where("emergency_plan_id = ?",@emergency_plan.id) if @emergency_plan.present?
        @res_ext_plan = ResExtPlan.new
    end

    def resources_int_plan
        @emergency_plan = EmergencyPlan.find_by(id: params[:id].to_i)
        @res_int_plans = ResIntPlan.where("emergency_plan_id = ?",@emergency_plan.id) if @emergency_plan.present?
        @res_int_plan = ResIntPlan.new
    end

    def brigadistas_plan
        @emergency_plan = EmergencyPlan.find_by(id: params[:id].to_i)
        @brigadista_plans = BrigadistaPlan.where("emergency_plan_id = ?",@emergency_plan.id) if @emergency_plan.present?
        @brigadista_plan = BrigadistaPlan.new
    end

    def equipements_plan
        @emergency_plan = EmergencyPlan.find_by(id: params[:id].to_i)
        @equipement_used_plans = EquipementUsedPlan.where("emergency_plan_id = ?",@emergency_plan.id) if @emergency_plan.present?
        @equipement_used_plan = EquipementUsedPlan.new
    end


    private  
       
    def emergency_plan_params
        params.require(:emergency_plan).permit(:activity, :sede, :ciudad, :direccion, :ubi_geografica, :per_norte, :per_sur, :per_oriente, :per_occidente, 
        :vias_peatonal, :vias_vehicular, :sector_influencia, :mov_telurico, :desc_mov_telurico, :inundaciones, :desc_inundaciones, 
        :incendio, :desc_incendio, :aquien_lado_derecho, :espe_actividades, :vias_acceso, :per_administrativo, :per_operativo, :per_admin_m, 
        :per_admin_f, :per_admin_directa, :per_admin_ind, :per_admin_soc, :per_oper_m, :per_oper_f, :per_oper_directa, :per_oper_ind, 
        :per_oper_soc, :per_total, :per_total_m, :per_total_f, :per_total_dir, :per_total_ind, :per_total_soc, :jornada_laboral_lunes, 
        :jornada_laboral_sabado, :carac_construccion, :tiempo_construccion, :terreno, :construido, :pisos, :entradas_salidas, :locales_externos, :cumple_sismo, 
        :escalera_emergencia, :sotano, :ascensores, :inst_electricas, :fallas_estructurales, :redes_gas, :control_acceso, :redes_contra_incendio, :hidrantes, :sis_alarma, 
        :sis_humo, :sis_iluminacion_emer, :equipo_comunicacion, :tanqueh2o, :planta_energia, :almacenamiento_quimico, :mapa_sede, :accidentes_trabaja, 
        :obs_accidentes_trabaja, :accidentes_visi, :obs_accidentes_visi, :asalto, :obs_asalto, :evento_terrorista, :obs_evento_terrorista, :descripcion_operativo, 
        :descripcion_insumos, :elementos_derecho, :elementos_izquierdo, :inst_especiales, :antec_emergencia, :redes_incendio44, :sistema_alarma44, 
        :sotano44, :gas_domiciliario44, :salidas_emergencia, :sistema_humo44, :tanque_h2o44, :planta_energia44, :valvula_entrada44, 
        :extintores44, :botiquin44, :camilla_portatil44, :analisis_amenazas, :recursos_externos, :emer_medica_ent, :emer_medica_tel, 
        :emer_medica_mun, :emer_incen_ent, :emer_incen_tel, :emer_incen_mun, :emer_respon_ent, :emer_respon_tel, :emer_respon_mun, 
        :emer_natur_ent, :emer_natur_tel, :emer_natur_mun, :emer_civiluno_ent, :emer_civiluno_tel, :emer_civiluno_mun, :emer_civildos_ent, :emer_civildos_tel, 
        :emer_civildos_mun, :emer_civiltres_ent, :emer_civiltres_tel, :emer_civiltres_mun, :emer_hospital_ent, :emer_hospital_tel, :emer_hospital_mun, 
        :rutas_evacuacion, :punto_encuentro, :empresa_fue_creada, :numero_sedes, :user_responsible, :date_firm_responsible, :firm_responsible, :date_plan, :codigo_empresa, :entity_id, plan_files: [] )
    end
end    








