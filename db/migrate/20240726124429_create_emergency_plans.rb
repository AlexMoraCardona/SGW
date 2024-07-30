class CreateEmergencyPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :emergency_plans do |t|
      t.string :sede
      t.string :ciudad
      t.string :direccion
      t.string :ubi_geografica
      t.string :per_norte
      t.string :per_sur
      t.string :per_oriente
      t.string :per_occidente
      t.string :vias_peatonal
      t.string :vias_vehicular
      t.integer :sector_influencia, default: 0
      t.integer :mov_telurico, default: 0
      t.string :desc_mov_telurico
      t.integer :inundaciones, default: 0
      t.string :desc_inundaciones
      t.integer :incendio, default: 0
      t.string :desc_incendio
      t.string :aquien_lado_derecho
      t.string :espe_actividades
      t.string :vias_acceso
      t.integer :per_administrativo, default: 0
      t.integer :per_operativo, default: 0
      t.integer :per_admin_m, default: 0
      t.integer :per_admin_f, default: 0
      t.integer :per_admin_directa, default: 0
      t.integer :per_admin_ind, default: 0
      t.integer :per_admin_soc, default: 0
      t.integer :per_oper_m, default: 0
      t.integer :per_oper_f, default: 0
      t.integer :per_oper_directa, default: 0
      t.integer :per_oper_ind, default: 0
      t.integer :per_oper_soc, default: 0
      t.integer :per_total, default: 0
      t.integer :per_total_m, default: 0
      t.integer :per_total_f, default: 0
      t.integer :per_total_dir, default: 0
      t.integer :per_total_ind, default: 0
      t.integer :per_total_soc, default: 0
      t.string :jornada_laboral_lunes
      t.string :jornada_laboral_sabado
      t.string :carac_construccion
      t.string :tiempo_construccion
      t.string :terreno
      t.string :construido
      t.integer :pisos, default: 0
      t.integer :entradas_salidas, default: 0
      t.integer :locales_externos, default: 0
      t.string :cumple_sismo
      t.string :escalera_emergencia
      t.string :sotano
      t.string :ascensores
      t.string :inst_electricas
      t.string :fallas_estructurales
      t.string :redes_gas
      t.string :control_acceso
      t.string :redes_contra_incendio
      t.string :hidrantes
      t.string :sis_alarma
      t.string :sis_humo
      t.string :sis_iluminacion_emer
      t.string :equipo_comunicacion
      t.string :tanqueh2o
      t.string :planta_energia
      t.string :almacenamiento_quimico
      t.string :mapa_sede
      t.integer :accidentes_trabaja, default: 0
      t.string :obs_accidentes_trabaja
      t.integer :accidentes_visi, default: 0
      t.string :obs_accidentes_visi
      t.integer :asalto, default: 0
      t.string :obs_asalto
      t.integer :evento_terrorista, default: 0
      t.string :obs_evento_terrorista
      t.string :descripcion_insumos
      t.string :elementos_derecho
      t.string :elementos_izquierdo
      t.string :inst_especiales
      t.string :antec_emergencia
      t.integer :redes_incendio44, default: 0
      t.integer :sistema_alarma44, default: 0
      t.integer :sotano44, default: 0
      t.integer :gas_domiciliario44, default: 0
      t.integer :salidas_emergencia, default: 0
      t.integer :sistema_humo44, default: 0
      t.integer :tanque_h2o44, default: 0
      t.integer :planta_energia44, default: 0
      t.integer :valvula_entrada44, default: 0
      t.integer :extintores44, default: 0
      t.integer :botiquin44, default: 0
      t.integer :camilla_portatil44, default: 0
      t.string :analisis_amenazas
      t.string :recursos_externos
      t.string :emer_medica_ent
      t.string :emer_medica_tel
      t.string :emer_medica_mun
      t.string :emer_incen_ent
      t.string :emer_incen_tel
      t.string :emer_incen_mun
      t.string :emer_respon_ent
      t.string :emer_respon_tel
      t.string :emer_respon_mun
      t.string :emer_natur_ent
      t.string :emer_natur_tel
      t.string :emer_natur_mun
      t.string :emer_civiluno_ent
      t.string :emer_civiluno_tel
      t.string :emer_civiluno_mun
      t.string :emer_civildos_ent
      t.string :emer_civildos_tel
      t.string :emer_civildos_mun
      t.string :emer_civiltres_ent
      t.string :emer_civiltres_tel
      t.string :emer_civiltres_mun
      t.string :emer_hospital_ent
      t.string :emer_hospital_tel
      t.string :emer_hospital_mun
      t.integer :empresa_fue_creada, default: 0
      t.integer :numero_sedes, default: 0
      t.integer :user_responsible, default: 0
      t.date :date_firm_responsible
      t.integer :firm_responsible, default: 0
      t.date :date_plan

      t.timestamps
    end
    add_reference :emergency_plans, :entity, null: true, foreign_key: true

  end
end
