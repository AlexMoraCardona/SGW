Rails.application.routes.draw do
  
  root :to =>  'homes#index' 
  get 'home', to:  "homes#index"
  
  namespace :authentication, path: '', as: ''  do
    resources :users
    resources :sessions, only: [:new, :create, :destroy]
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

  get '/presentations/listadopresentaciones', to: 'presentations#listadopresentaciones', as: 'listadopresentaciones'
  get '/profiles/firma_aprobo/:id', to: 'profiles#firma_aprobo', as: 'firma_aprobo'
  get '/profiles/firma_elaboro/:id', to: 'profiles#firma_elaboro', as: 'firma_elaboro'
  get '/profiles/encuesta/:id', to: 'profiles#encuesta', as: 'encuesta' 
  get '/profiles/informe/:id', to: 'profiles#informe', as: 'infoprofile' 
  get '/profiles/fichatecnica/:id', to: 'profiles#fichatecnica', as: 'fichatecnica' 
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
      get '/report_officials/actualizarindicadores/:id', to: 'report_officials#actualizarindicadores', as: 'actualizar_indicadores'
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


  resources :evaluations do
    collection do
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
