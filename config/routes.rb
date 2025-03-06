Rails.application.routes.draw do
  
  root :to =>  'homes#index' 
  get 'home', to:  "homes#index"
  
  namespace :authentication, path: '', as: ''  do
    resources :users
    resources :sessions, only: [:new, :create, :destroy]
    get '/users/cambio_empresa/:id', to: 'users#cambio_empresa', as: 'cambio_empresa'
    get '/sessions/cambioclave/:id', to: 'sessions#cambioclave', as: 'cambioclave'
    post '/sessions/generarclave/:id', to: 'sessions#generarclave', as: 'generarclave'
    get '/users/cambiar_clave/:id', to: 'users#cambiar_clave', as: 'cambiar_clave'

  end  
  

  

  resources :entities 
  resources :levels
  resources :administrative_political_divisions
  resources :documents
  resources :economic_activity_codes
  resources :occupational_risk_managers
  resources :risk_levels  
  resources :cycles
  resources :rules
  resources :standars
  resources :standar_details
  resources :standar_detail_items
  resources :templates 
  resources :meeting_attendees
  resources :meeting_commitments
  resources :assistants
  resources :employee_news
  resources :events
  resources :indicators
  resources :firms
  resources :participants
  resources :evidences
  resources :history_evaluations
  resources :matrix_legal_items
  resources :annual_work_plan_items
  resources :clasification_dangers
  resources :clasification_danger_details
  resources :matrix_danger_items
  resources :matrix_action_items
  resources :locations
  resources :adm_calendars
  resources :calendars
  resources :activities
  resources :activity_users
  resources :adm_exams
  resources :exam_questions
  resources :exams
  resources :exam_details
  resources :allow_exams
  resources :contents
  resources :training_items
  resources :resource_items
  resources :unsafe_conditions
  resources :complaints
  resources :occupational_exam_items
  resources :pension_funds
  resources :health_promoters
  resources :survey_profiles
  resources :profiles
  resources :cessation_funds
  resources :presentations
  resources :danger_detail_risks
  resources :danger_preventions
  resources :form_preventions
  resources :protection_elements
  resources :matrix_protection_items
  resources :provides_protection_items
  resources :working_conditions
  resources :working_condition_items
  resources :extinguishers
  resources :adm_extinguishers
  resources :business_days
  resources :matrix_conditions
  resources :matrix_unsafe_items
  resources :format_actions 
  resources :audit_reports
  resources :audit_report_items
  resources :direction_reviews
  resources :improvement_plans
  resources :improvement_items
  resources :type_condition_inspections
  resources :situation_conditions
  resources :safety_inspections
  resources :safety_inspection_items
  resources :commitments
  resources :emergency_plans
  resources :equipement_used_plans
  resources :brigadista_plans
  resources :res_int_plans
  resources :res_ext_plans
  resources :table_diseases
  resources :detail_diseases
  resources :view_videos

  get '/emergency_plans/resources_ext_plan/:id', to: 'emergency_plans#resources_ext_plan', as: 'resources_ext_plan'
  get '/emergency_plans/resources_int_plan/:id', to: 'emergency_plans#resources_int_plan', as: 'resources_int_plan'
  get '/emergency_plans/brigadistas_plan/:id', to: 'emergency_plans#brigadistas_plan', as: 'brigadistas_plan'
  get '/emergency_plans/equipements_plan/:id', to: 'emergency_plans#equipements_plan', as: 'equipements_plan'
  get '/emergency_plans/firmar_responsable_plan/:id', to: 'emergency_plans#firmar_responsable_plan', as: 'firmar_responsable_plan'
  get '/emergency_plans/ver_emergency_plan_pdf/:id', to: 'emergency_plans#ver_emergency_plan_pdf', as: 'ver_emergency_plan_pdf'
  get '/safety_inspections/ver_inspeccion_pdf/:id', to: 'safety_inspections#ver_inspeccion_pdf', as: 'ver_inspeccion_pdf'
  get '/safety_inspections/firmar_responsable_inspeccion/:id', to: 'safety_inspections#firmar_responsable_inspeccion', as: 'firmar_responsable_inspeccion'
  get '/improvement_plans/crear_item_improvement_plan/:id', to: 'improvement_plans#crear_item_improvement_plan', as: 'crear_item_improvement_plan'
  get '/improvement_plans/firmar_representante_improvement/:id', to: 'improvement_plans#firmar_representante_improvement', as: 'firmar_representante_improvement_plan'
  get '/improvement_plans/firmar_responsable_improvement/:id', to: 'improvement_plans#firmar_responsable_improvement', as: 'firmar_responsable_improvement_plan'
  get '/improvement_plans/ver_improvement_plan_pdf/:id', to: 'improvement_plans#ver_improvement_plan_pdf', as: 'ver_improvement_plan_pdf'
  get '/direction_reviews/firmar_representante_review/:id', to: 'direction_reviews#firmar_representante_review', as: 'firmar_representante_review'
  get '/direction_reviews/ver_review_pdf/:id', to: 'direction_reviews#ver_review_pdf', as: 'ver_review_pdf'
  get '/audit_reports/crear_item_auditoria_interna/:id', to: 'audit_reports#crear_item_auditoria_interna', as: 'crear_item_auditoria_interna'
  get '/audit_reports/firmar_representante/:id', to: 'audit_reports#firmar_representante', as: 'firmar_representante_audi'
  get '/audit_reports/firmar_auditor/:id', to: 'audit_reports#firmar_auditor', as: 'firmar_auditor'
  get '/audit_reports/ver_auditoria_interna_pdf/:id', to: 'audit_reports#ver_auditoria_interna_pdf', as: 'ver_auditoria_interna_pdf'
  get '/matrix_unsafe_items/matrix_unsafe_item_pdf/:id', to: 'matrix_unsafe_items#matrix_unsafe_item_pdf', as: 'matrix_unsafe_item_pdf'
  get '/unsafe_conditions/unsafe_condition_pdf/:id', to: 'unsafe_conditions#unsafe_condition_pdf', as: 'unsafe_condition_pdf'
  get '/unsafe_conditions/add_evidences/:id', to: 'unsafe_conditions#add_evidences', as: 'add_evidences'
  get '/format_actions/format_action_pdf/:id', to: 'format_actions#format_action_pdf', as: 'format_action_pdf'
  get '/matrix_conditions/condition_pdf/:id', to: 'matrix_conditions#condition_pdf', as: 'condition_pdf'
  get '/matrix_conditions/crear_item_condition/:id', to: 'matrix_conditions#crear_item_condition', as: 'crear_item_condition'
  get '/matrix_conditions/firmar_representante/:id', to: 'matrix_conditions#firmar_representante', as: 'firmar_representante'
  get '/matrix_conditions/firmar_responsible/:id', to: 'matrix_conditions#firmar_responsible', as: 'firmar_responsible'
  get '/unsafe_conditions/firmar_reporta/:id', to: 'unsafe_conditions#firmar_reporta', as: 'firmar_reporta'
  get '/unsafe_conditions/firmar_recibe/:id', to: 'unsafe_conditions#firmar_recibe', as: 'firmar_recibe'
  get '/working_conditions/edit_item/:id', to: 'working_conditions#edit_item', as: 'edit_item_working_condition'
  get '/working_conditions/reporte/:entity_id', to: 'working_conditions#reporte', as: 'reporte_working_condition'
  get '/working_conditions/working_pdf/:id', to: 'working_conditions#working_pdf', as: 'working_pdf'
  get '/working_conditions/firmar_user/:id', to: 'working_conditions#firmar_user', as: 'firmar_user'
  get '/working_conditions/mod_detalle/:id', to: 'working_conditions#mod_detalle', as: 'mod_detalle' 
  get '/working_conditions/detalles_working/:id', to: 'working_conditions#detalles_working', as: 'detalles_working' 
  get '/form_preventions/informesuge/:id', to: 'form_preventions#informesuge', as: 'informesuge' 
  get '/form_preventions/encuestapre/:id', to: 'form_preventions#encuestapre', as: 'encuestapre' 
  get '/form_preventions/firmar_admin_extent/:id', to: 'form_preventions#firmar_admin_extent', as: 'firmar_admin_extent'
  get '/form_preventions/actualizar_form_prevention/:id', to: 'form_preventions#actualizar_form_prevention', as: 'actualizar_form_prevention'
  get '/presentations/listadopresentaciones', to: 'presentations#listadopresentaciones', as: 'listadopresentaciones'
  get '/profiles/firma_aprobo/:id', to: 'profiles#firma_aprobo', as: 'firma_aprobo'
  get '/profiles/firma_elaboro/:id', to: 'profiles#firma_elaboro', as: 'firma_elaboro'
  get '/profiles/encuesta/:id', to: 'profiles#encuesta', as: 'encuesta' 
  get '/profiles/informe/:id', to: 'profiles#informe', as: 'infoprofile' 
  get '/profiles/fichatecnica/:id', to: 'profiles#fichatecnica', as: 'fichatecnica' 
  get '/profiles/detalles_profile/:id', to: 'profiles#detalles_profile', as: 'detalles_profile' 
  get '/profiles/encuesta_profile/:id', to: 'profiles#encuesta_profile', as: 'encuesta_profile' 
  get '/adm_calendars/generar/:id', to: 'adm_calendars#generar', as: 'generar' 
  get '/adm_calendars/ver_calendario/:id', to: 'adm_calendars#ver_calendario', as: 'ver_calendario' 
  get '/calendars/detail/:id', to: 'calendars#detail', as: 'detail' 
  get '/calendars/nueva_actividad/:id', to: 'calendars#nueva_actividad', as: 'nueva_actividad' 
  get '/calendars/seleccion/:id', to: 'calendars#seleccion', as: 'seleccion' 
  post '/calendars/seleccion/:id' => 'calendars#citar', as: 'citar'
  get '/exams/evaluacion/:id', to: 'exams#evaluacion', as: 'evaluacion' 
  post '/exams/guardar_respuesta/:id' => 'exams#guardar_respuesta', as: 'guardar_respuesta'
  get '/exams/ver_respuesta/:id' => 'exams#ver_respuesta', as: 'ver_respuesta'
  get '/exams/historia' => 'exams#historia', as: 'historia'
  get '/exams/ver_detalle/:id' => 'exams#ver_detalle', as: 'ver_detalle'
  get '/exams/repro/:id' => 'exams#repro', as: 'repro'
  get '/exams/apro/:id' => 'exams#apro', as: 'apro'
  get '/exams/repro_det/:id' => 'exams#repro_det', as: 'repro_det'
  get '/complaints/informe', to: 'complaints#informe', as: 'informe' 
  get '/complaints/informe/:id' => 'complaints#informe', as: 'inform'
  get '/complaints/resumen/:id' => 'complaints#resumen', as: 'resumen'
  get '/evaluations/firmar_responsable_evaluation/:id', to: 'evaluations#firmar_responsable_evaluation', as: 'firmar_responsable_evaluation'
  get '/evaluations/firmar_representante_evaluation/:id', to: 'evaluations#firmar_representante_evaluation', as: 'firmar_representante_evaluation'
  get '/history_evaluations/descargar_historia/:id', to: 'history_evaluations#descargar_historia', as: 'descargar_historia'
  get '/view_videos/registrar_vista/:id', to: 'view_videos#registrar_vista', as: 'registrar_vista'
  get '/survey_profiles/informe_estudio_socio/:id', to: 'survey_profiles#informe_estudio_socio', as: 'informe_estudio_socio'
  get '/templates/matriz_documental/:id', to: 'templates#matriz_documental', as: 'matriz_documental'
  get '/assistants/firmar_assistent/:id', to: 'assistants#firmar_assistent', as: 'firmar_assistent'

  resources :admin_extent_dangers do
    collection do
      get '/admin_extent_dangers/crear_admin_extent', to: 'admin_extent_dangers#crear_admin_extent', as: 'crear_admin_extent'
      get '/admin_extent_dangers/matrix_prevention/:id', to: 'admin_extent_dangers#matrix_prevention', as: 'matrix_prevention'
      get '/admin_extent_dangers/matrix_vista/:id', to: 'admin_extent_dangers#matrix_vista', as: 'matrix_vista'

    end  
  end

  resources :kits do
    collection do
      get '/kits/firmar_kit/:id', to: 'kits#firmar_kit', as: 'firmar_kit'
      get '/kits/kit_pdf/:id', to: 'kits#kit_pdf', as: 'kit_pdf'
      get '/kits/kit_adjunto/:id', to: 'kits#kit_adjunto', as: 'kit_adjunto'
    end  
  end  


  resources :matrix_danger_risks do
    collection do
      get '/matrix_danger_risks/crear_item/:id', to: 'matrix_danger_risks#crear_item', as: 'crear_item'
      get '/matrix_danger_risks/resumen_pdf/:id', to: 'matrix_danger_risks#resumen_pdf', as: 'resumen_pdf'
      get '/matrix_danger_risks/total_items/:id', to: 'matrix_danger_risks#total_items', as: 'total_items'
      get '/matrix_danger_risks/firmar_rep/:id', to: 'matrix_danger_risks#firmar_rep', as: 'firmar_rep'
      get '/matrix_danger_risks/firmar_adv/:id', to: 'matrix_danger_risks#firmar_adv', as: 'firmar_adv'
      get '/matrix_danger_risks/firmar_res/:id', to: 'matrix_danger_risks#firmar_res', as: 'firmar_res'

    end  
  end

  resources :matrix_corrective_actions do
    collection do
      get '/matrix_corrective_actions/crear_item/:id', to: 'matrix_corrective_actions#crear_item', as: 'crear_item'
      get '/matrix_corrective_actions/resumen_pdf/:id', to: 'matrix_corrective_actions#resumen_pdf', as: 'resumen_pdf'
      get '/matrix_corrective_actions/total_items/:id', to: 'matrix_corrective_actions#total_items', as: 'total_items'
      get '/matrix_corrective_actions/firmar_rep/:id', to: 'matrix_corrective_actions#firmar_rep', as: 'firmar_rep'
      get '/matrix_corrective_actions/firmar_adv/:id', to: 'matrix_corrective_actions#firmar_adv', as: 'firmar_adv'
      get '/matrix_corrective_actions/firmar_res/:id', to: 'matrix_corrective_actions#firmar_res', as: 'firmar_res'
    end  
  end
  
  resources :report_officials do
    collection do
      get '/report_officials/actualizar_indicadores/:id', to: 'report_officials#actualizar_indicadores', as: 'actualizar_indicadores'
    end
  end


  resources :matrix_legals do
    collection do
      get '/matrix_legals/crear_item/:id', to: 'matrix_legals#crear_item', as: 'crear_item'
      get :crear_historia
      get '/ver_history/:id', to: 'matrix_legals#ver_history', as: 'ver_history' 
      get '/show_history/:id', to: 'matrix_legals#show_history', as: 'show_history' 
      get '/matrix_legals/total_items/:id', to: 'matrix_legals#total_items', as: 'total_items'
      get '/matrix_legals/firmar_rep/:id', to: 'matrix_legals#firmar_rep', as: 'firmar_rep'
      get '/matrix_legals/firmar_adv/:id', to: 'matrix_legals#firmar_adv', as: 'firmar_adv'
      get '/matrix_legals/firmar_res/:id', to: 'matrix_legals#firmar_res', as: 'firmar_res'
    end
  end

  resources :annual_work_plans do
    collection do
      get '/annual_work_plans/crear_item_plan/:id', to: 'annual_work_plans#crear_item_plan', as: 'crear_item_plan'
      get '/annual_work_plans/ver_plan/:id', to: 'annual_work_plans#ver_plan', as: 'ver_plan'
      get '/annual_work_plans/firmar_rep/:id', to: 'annual_work_plans#firmar_rep', as: 'firmar_rep'
      get '/annual_work_plans/firmar_adv/:id', to: 'annual_work_plans#firmar_adv', as: 'firmar_adv'
      get '/annual_work_plans/firmar_res/:id', to: 'annual_work_plans#firmar_res', as: 'firmar_res'
    end
  end

  resources :adm_extinguishers do
    collection do
      get '/adm_extinguishers/crear_item_extinguisher/:id', to: 'adm_extinguishers#crear_item_extinguisher', as: 'crear_item_extinguisher'
      get '/adm_extinguishers/ver_extinguisher/:id', to: 'adm_extinguishers#ver_extinguisher', as: 'ver_extinguisher'
      get '/adm_extinguishers/firmar_extinguisher/:id', to: 'adm_extinguishers#firmar_extinguisher', as: 'firmar_extinguisher'
      get '/adm_extinguishers/extinguisher_adjunto/:id', to: 'adm_extinguishers#extinguisher_adjunto', as: 'extinguisher_adjunto'
    end
  end


  resources :trainings do
    collection do
      get '/trainings/crear_item_training/:id', to: 'trainings#crear_item_training', as: 'crear_item_training'
      get '/trainings/ver_training/:id', to: 'trainings#ver_training', as: 'ver_training'
      get '/trainings/firmar_rep/:id', to: 'trainings#firmar_rep', as: 'firmar_rep'
      get '/trainings/firmar_adv/:id', to: 'trainings#firmar_adv', as: 'firmar_adv'
      get '/trainings/firmar_res/:id', to: 'trainings#firmar_res', as: 'firmar_res'
    end
  end

  resources :resources do
    collection do
      get '/resources/crear_item_resource/:id', to: 'resources#crear_item_resource', as: 'crear_item_resource'
      get '/resources/ver_resource/:id', to: 'resources#ver_resource', as: 'ver_resource'
      get '/resources/firmar_rep/:id', to: 'resources#firmar_rep', as: 'firmar_rep'
      get '/resources/firmar_adv/:id', to: 'resources#firmar_adv', as: 'firmar_adv'
      get '/resources/firmar_res/:id', to: 'resources#firmar_res', as: 'firmar_res'
    end
  end

  resources :meeting_minutes do
    collection do
      get '/meeting_minutes/crear_asistente/:id', to: 'meeting_minutes#crear_asistente', as: 'crear_asistente'
      get '/meeting_minutes/crear_compromiso/:id', to: 'meeting_minutes#crear_compromiso', as: 'crear_compromiso'
      get '/meeting_minutes/crear_firma/:id', to: 'meeting_minutes#crear_firma', as: 'crear_firma'
    end
  end
 
  resources :evaluation_rule_details do
    member do
      get 'crear_evidencia'
      get '/evaluation_rule_details/crear_firma/:id', to: 'evaluation_rule_details#crear_firma', as: 'crear_firma'
      get '/evaluation_rule_details/crear_participant/:id', to: 'evaluation_rule_details#crear_participant', as: 'crear_participant'
      get '/evaluation_rule_details/actualizar_evidencia/:id', to: 'evaluation_rule_details#actualizar_evidencia', as: 'actualizar_evidencia'
      get '/evaluation_rule_details/ver_evidencia/:id', to: 'evaluation_rule_details#ver_evidencia', as: 'ver_evidencia'
      get '/evaluation_rule_details/crear_compromiso/:id', to: 'evaluation_rule_details#crear_compromiso', as: 'crear_compromiso'
    end
  end

  resources :occupational_exams do
    collection do
      get '/occupational_exams/crear_item_occupational/:id', to: 'occupational_exams#crear_item_occupational', as: 'crear_item_occupational'
      get '/occupational_exams/ver_occupational/:id', to: 'occupational_exams#ver_occupational', as: 'ver_occupational'
      get '/occupational_exams/firmar_rep/:id', to: 'occupational_exams#firmar_rep', as: 'firmar_rep'
      get '/occupational_exams/firmar_adv/:id', to: 'occupational_exams#firmar_adv', as: 'firmar_adv'
      get '/occupational_exams/firmar_res/:id', to: 'occupational_exams#firmar_res', as: 'firmar_res'
    end
  end

  resources :matrix_protections do
    collection do
      get '/matrix_protections/crear_item_protection/:id', to: 'matrix_protections#crear_item_protection', as: 'crear_item_protection'
      get '/matrix_protections/ver_matrix_protection/:id', to: 'matrix_protections#ver_matrix_protection', as: 'ver_matrix_protection'
      get '/matrix_protections/firmar_rep/:id', to: 'matrix_protections#firmar_rep', as: 'firmar_rep'
      get '/matrix_protections/firmar_adv/:id', to: 'matrix_protections#firmar_adv', as: 'firmar_adv'
      get '/matrix_protections/firmar_res/:id', to: 'matrix_protections#firmar_res', as: 'firmar_res'
    end
  end

  resources :provides_protections do
    collection do
      get '/provides_protections/crear_item_provide/:id', to: 'provides_protections#crear_item_provide', as: 'crear_item_provide'
      get '/provides_protections/ver_info_provide/:id', to: 'provides_protections#ver_info_provide', as: 'ver_info_provide'
      get '/provides_protections/firmar_colaborador/:id', to: 'provides_protections#firmar_colaborador', as: 'firmar_colaborador'
      get '/provides_protections/firmar_responsable/:id', to: 'provides_protections#firmar_responsable', as: 'firmar_responsable'
    end
  end


  resources :evaluations do
    collection do
      get '/evaluations/ver_evaluation_pdf/:id', to: 'evaluations#ver_evaluation_pdf', as: 'ver_evaluation_pdf'
      get :crear_evaluacion
      get :crear_historia
      get '/ver_history/:id', to: 'evaluations#ver_history', as: 'ver_history' 
    end
  end

  resources :description_jobs do
    collection do
      get '/description_jobs/pdf/:id', to: 'description_jobs#pdf', as: 'pdf'
      get '/description_jobs/firmar_ela/:id', to: 'description_jobs#firmar_ela', as: 'firmar_ela'
      get '/description_jobs/firmar_rev/:id', to: 'description_jobs#firmar_rev', as: 'firmar_rev'
      get '/description_jobs/firmar_apr/:id', to: 'description_jobs#firmar_apr', as: 'firmar_apr'
    end  
  end

  delete "attachments/:id/purge", to: "attachments#purge", as: "purge_attachment"

  get '/indicadores/resultado', to: 'indicadores#resultado', as: 'resultado' 
  post '/indicadores/resultado' => 'indicadores#consultar', as: 'consultar'
  get '/indicadores/graficos/:id', to: 'indicadores#graficos', as: 'graficos' 
  get '/indicadores/graficos_pdf/:id', to: 'indicadores#graficos_pdf', as: 'graficos_pdf' 
  
  get '/indicadores/resultadompr', to: 'indicadores#resultadompr', as: 'resultadompr' 
  post '/indicadores/resultadompr' => 'indicadores#consultarmpr', as: 'consultarmpr'
  get '/indicadores/graficosmpr/:id', to: 'indicadores#graficosmpr', as: 'graficosmpr' 

  get '/indicadores/resultadoml', to: 'indicadores#resultadoml', as: 'resultadoml' 
  post '/indicadores/resultadoml' => 'indicadores#consultarml', as: 'consultarml'
  get '/indicadores/graficosml/:id', to: 'indicadores#graficosml', as: 'graficosml' 

  get '/indicadores/resultadoacpm', to: 'indicadores#resultadoacpm', as: 'resultadoacpm' 
  post '/indicadores/resultadoacpm' => 'indicadores#consultaracpm', as: 'consultaracpm'
  get '/indicadores/graficosacpm/:id', to: 'indicadores#graficosacpm', as: 'graficosacpm' 

  get '/indicadores/resultadompt', to: 'indicadores#resultadompt', as: 'resultadompt' 
  post '/indicadores/resultadompt' => 'indicadores#consultarmpt', as: 'consultarmpt'
  get '/indicadores/graficosmpt/:id', to: 'indicadores#graficosmpt', as: 'graficosmpt' 

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
