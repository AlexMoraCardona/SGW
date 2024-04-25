# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_04_24_221542) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.string "origin"
    t.integer "state", default: 0
    t.string "description"
    t.string "observation"
    t.string "place"
    t.integer "notify", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "calendar_id", null: false
    t.bigint "entity_id", null: false
    t.bigint "user_id", null: false
    t.time "citation"
    t.index ["calendar_id"], name: "index_activities_on_calendar_id"
    t.index ["entity_id"], name: "index_activities_on_entity_id"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "activity_users", force: :cascade do |t|
    t.integer "mandatory", default: 0
    t.integer "attended", default: 0
    t.integer "confirm", default: 0
    t.date "date_confirm"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "activity_id", null: false
    t.bigint "user_id", null: false
    t.index ["activity_id"], name: "index_activity_users_on_activity_id"
    t.index ["user_id"], name: "index_activity_users_on_user_id"
  end

  create_table "adm_calendars", force: :cascade do |t|
    t.integer "year", default: 1900
    t.integer "bisiesto", default: 0
    t.integer "day_initial", default: 1
    t.integer "generated", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "adm_exams", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "cant_questions", default: 0
    t.decimal "percentage_min"
    t.integer "cant_attempts", default: 0
    t.integer "time_max", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admin_extent_dangers", force: :cascade do |t|
    t.date "date_creation"
    t.date "date_vencimiento"
    t.integer "state_extent", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id"
    t.index ["entity_id"], name: "index_admin_extent_dangers_on_entity_id"
  end

  create_table "administrative_political_divisions", force: :cascade do |t|
    t.string "department_code"
    t.string "department_name"
    t.string "municipality_code"
    t.string "municipality_name"
    t.string "town_center_code"
    t.string "town_center_name"
    t.string "classification"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "allow_exams", force: :cascade do |t|
    t.date "date_initial"
    t.date "date_final"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "adm_exam_id"
    t.bigint "entity_id"
    t.string "name_exam"
    t.index ["adm_exam_id"], name: "index_allow_exams_on_adm_exam_id"
    t.index ["entity_id"], name: "index_allow_exams_on_entity_id"
    t.index ["user_id"], name: "index_allow_exams_on_user_id"
  end

  create_table "annual_work_plan_items", force: :cascade do |t|
    t.integer "consecutive"
    t.string "aim"
    t.string "goal"
    t.string "activity"
    t.string "resource"
    t.string "responsible"
    t.date "date_realization"
    t.integer "month"
    t.string "observation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "annual_work_plan_id"
    t.integer "earring", default: 0
    t.string "evidences_plan"
    t.index ["annual_work_plan_id"], name: "index_annual_work_plan_items_on_annual_work_plan_id"
  end

  create_table "annual_work_plans", force: :cascade do |t|
    t.integer "year"
    t.integer "user_legal_representative"
    t.integer "user_adviser_sst"
    t.integer "user_responsible_sst"
    t.integer "version"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id"
    t.date "date_firm_legal_representative"
    t.date "date_firm_adviser_sst"
    t.date "date_firm_responsible_sst"
    t.integer "firm_legal_representative", default: 0
    t.integer "firm_adviser_sst", default: 0
    t.integer "firm_responsible_sst", default: 0
    t.date "date_create"
    t.date "date_update"
    t.index ["entity_id"], name: "index_annual_work_plans_on_entity_id"
  end

  create_table "assistants", force: :cascade do |t|
    t.string "name"
    t.string "post"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "meeting_minute_id", null: false
    t.index ["meeting_minute_id"], name: "index_assistants_on_meeting_minute_id"
  end

  create_table "calendars", force: :cascade do |t|
    t.integer "day", default: 1
    t.integer "month", default: 1
    t.integer "year", default: 1900
    t.integer "festive", default: 0
    t.string "name_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "adm_calendar_id", null: false
    t.index ["adm_calendar_id"], name: "index_calendars_on_adm_calendar_id"
  end

  create_table "cessation_funds", force: :cascade do |t|
    t.string "name"
    t.string "nit"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clasification_danger_details", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "clasification_danger_id"
    t.index ["clasification_danger_id"], name: "index_clasification_danger_details_on_clasification_danger_id"
  end

  create_table "clasification_dangers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "complaints", force: :cascade do |t|
    t.integer "user_complaint", default: 0
    t.integer "user_interpose_complaint", default: 0
    t.date "date_complaint"
    t.string "relationship_facts"
    t.integer "have_proof", default: 0
    t.date "date_firm_complaint"
    t.integer "firm_complaint", default: 0
    t.integer "state_complaint", default: 0
    t.string "observation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id"
    t.index ["entity_id"], name: "index_complaints_on_entity_id"
  end

  create_table "contents", force: :cascade do |t|
    t.string "clasification"
    t.string "title"
    t.integer "state", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link"
  end

  create_table "cycles", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "danger_detail_preventions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "danger_detail_risks", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "clasification_danger_detail_id"
    t.index ["clasification_danger_detail_id"], name: "index_danger_detail_risks_on_clasification_danger_detail_id"
  end

  create_table "danger_preventions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "clasification_danger_detail_id"
    t.index ["clasification_danger_detail_id"], name: "index_danger_preventions_on_clasification_danger_detail_id"
  end

  create_table "description_jobs", force: :cascade do |t|
    t.string "name_job"
    t.string "immediate_boss"
    t.string "objetive_job"
    t.string "academic_training"
    t.string "experience"
    t.string "salary_range"
    t.string "type_contract"
    t.string "working_hours"
    t.string "required_knowledge"
    t.string "competencies"
    t.string "job_functions"
    t.string "roles_responsibilities"
    t.string "observations"
    t.integer "user_elaboro"
    t.integer "user_reviso"
    t.integer "user_aprobo"
    t.date "date_firm_elaboro"
    t.date "date_firm_reviso"
    t.date "date_firm_aprobo"
    t.integer "firm_elaboro", default: 0
    t.integer "firm_reviso", default: 0
    t.integer "firm_aprobo", default: 0
    t.integer "state_job"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id", null: false
    t.index ["entity_id"], name: "index_description_jobs_on_entity_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "document_type"
    t.integer "code"
    t.string "abbreviation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_documents_on_code", unique: true
  end

  create_table "economic_activity_codes", force: :cascade do |t|
    t.string "risk_class"
    t.string "ciu_code"
    t.string "additional_digits"
    t.string "economic_activity_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employee_news", force: :cascade do |t|
    t.date "date_new"
    t.integer "work_accident", default: 0
    t.date "disability_start_date"
    t.date "disability_end_date"
    t.integer "mortal_accident", default: 0
    t.integer "occupational_disease", default: 0
    t.integer "laboral_inhability", default: 0
    t.integer "common_inhability", default: 0
    t.integer "days_absenteeism", default: 0
    t.integer "user_reports"
    t.bigint "user_id"
    t.bigint "entity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_employee_news_on_entity_id"
    t.index ["user_id"], name: "index_employee_news_on_user_id"
  end

  create_table "entities", force: :cascade do |t|
    t.string "email_entity"
    t.integer "kind_person", default: 0
    t.string "business_name"
    t.string "first_name"
    t.string "second_name"
    t.string "surname"
    t.string "second_surname"
    t.integer "economic_activity", default: 0
    t.string "tax_regime"
    t.integer "identification_number"
    t.integer "verification_digit"
    t.integer "document_type_legal_representative", default: 0
    t.integer "document_number_legal_representative"
    t.string "first_name_legal_representative"
    t.string "second_name_legal_representative"
    t.string "surname_legal_representative"
    t.string "second_surname_legal_representative"
    t.string "email_legal_representative"
    t.integer "phone_number_entity"
    t.decimal "cell_entity"
    t.string "entity_address"
    t.integer "entity_location_code", default: 0
    t.string "entity_zone"
    t.integer "entity_arl", default: 0
    t.integer "number_workers", default: 0
    t.integer "risk_classification", default: 0
    t.string "license"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "agricultural_unit", default: 0
    t.integer "responsible_sst", default: 0
    t.integer "external_consultant", default: 0
    t.integer "pay_entity", default: 0
    t.index ["email_entity"], name: "index_entities_on_email_entity", unique: true
  end

  create_table "evaluation_models", force: :cascade do |t|
    t.integer "evaluation", default: 0
    t.integer "rule", default: 0
    t.decimal "score", default: "0.0"
    t.decimal "percentage", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "evaluation_rule_details", force: :cascade do |t|
    t.decimal "score", default: "0.0"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "observation"
    t.integer "meets", default: 0
    t.integer "apply", default: 0
    t.bigint "evaluation_id"
    t.bigint "standar_detail_item_id", null: false
    t.integer "cycle", default: 0
    t.decimal "maximun_value", default: "0.0"
    t.string "item_nro"
    t.integer "order_nro", default: 0
    t.index ["evaluation_id"], name: "index_evaluation_rule_details_on_evaluation_id"
    t.index ["standar_detail_item_id"], name: "index_evaluation_rule_details_on_standar_detail_item_id"
  end

  create_table "evaluations", force: :cascade do |t|
    t.integer "entity", default: 0
    t.date "date_evaluation"
    t.integer "number_employees", default: 0
    t.integer "risk_level", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rule", default: 0
    t.decimal "score", default: "0.0"
    t.decimal "percentage", default: "0.0"
    t.string "result"
    t.string "observation"
    t.bigint "entity_id"
    t.bigint "risk_level_id"
    t.bigint "rule_id"
    t.index ["entity_id"], name: "index_evaluations_on_entity_id"
    t.index ["risk_level_id"], name: "index_evaluations_on_risk_level_id"
    t.index ["rule_id"], name: "index_evaluations_on_rule_id"
  end

  create_table "events", force: :cascade do |t|
    t.date "date_new"
    t.integer "work_accident", default: 0
    t.date "disability_start_date"
    t.date "disability_end_date"
    t.integer "mortal_accident", default: 0
    t.integer "occupational_disease", default: 0
    t.integer "laboral_inhability", default: 0
    t.integer "common_inhability", default: 0
    t.integer "days_absenteeism", default: 0
    t.integer "user_reports"
    t.bigint "user_id"
    t.bigint "entity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_events_on_entity_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "evidences", force: :cascade do |t|
    t.date "date"
    t.date "date_update"
    t.string "place"
    t.string "goals"
    t.integer "number_attendees", default: 0
    t.integer "number_officials", default: 0
    t.string "period"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id", null: false
    t.bigint "template_id", null: false
    t.bigint "evaluation_rule_detail_id", null: false
    t.string "letter_value"
    t.string "value"
    t.string "initial_period"
    t.string "final_period"
    t.time "initial_time"
    t.time "final_time"
    t.integer "vigia", default: 0
    t.integer "year_initial", default: 2000
    t.integer "year_final", default: 2000
    t.integer "month_initial", default: 1
    t.integer "month_final", default: 1
    t.integer "total_votes", default: 0
    t.string "description_complaint"
    t.string "data"
    t.integer "evidence_authority", default: 0
    t.string "object"
    t.string "policy"
    t.text "compliances"
    t.index ["entity_id"], name: "index_evidences_on_entity_id"
    t.index ["evaluation_rule_detail_id"], name: "index_evidences_on_evaluation_rule_detail_id"
    t.index ["template_id"], name: "index_evidences_on_template_id"
  end

  create_table "exam_details", force: :cascade do |t|
    t.string "answer_user", default: "0"
    t.integer "correct", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "exam_id"
    t.bigint "exam_question_id"
    t.index ["exam_id"], name: "index_exam_details_on_exam_id"
    t.index ["exam_question_id"], name: "index_exam_details_on_exam_question_id"
  end

  create_table "exam_questions", force: :cascade do |t|
    t.integer "number", default: 0
    t.string "question"
    t.string "bad_answer_one"
    t.string "bad_answer_two"
    t.string "bad_answer_three"
    t.string "good_answe"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "adm_exam_id"
    t.index ["adm_exam_id"], name: "index_exam_questions_on_adm_exam_id"
  end

  create_table "exams", force: :cascade do |t|
    t.integer "total_good", default: 0
    t.integer "total_bad", default: 0
    t.decimal "final_percentage", default: "0.0"
    t.integer "time_exam", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "adm_exam_id"
    t.bigint "user_id"
    t.decimal "percentage_min"
    t.string "resul"
    t.index ["adm_exam_id"], name: "index_exams_on_adm_exam_id"
    t.index ["user_id"], name: "index_exams_on_user_id"
  end

  create_table "firms", force: :cascade do |t|
    t.integer "legal_representative", default: 0
    t.string "post"
    t.integer "authorize_firm", default: 0
    t.date "date_authorize_firm"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "evidence_id", null: false
    t.index ["evidence_id"], name: "index_firms_on_evidence_id"
    t.index ["user_id"], name: "index_firms_on_user_id"
  end

  create_table "form_preventions", force: :cascade do |t|
    t.integer "eli", default: 0
    t.integer "sus", default: 0
    t.integer "ci", default: 0
    t.integer "ca", default: 0
    t.integer "epp", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "admin_extent_danger_id"
    t.bigint "user_id"
    t.bigint "danger_prevention_id"
    t.index ["admin_extent_danger_id"], name: "index_form_preventions_on_admin_extent_danger_id"
    t.index ["danger_prevention_id"], name: "index_form_preventions_on_danger_prevention_id"
    t.index ["user_id"], name: "index_form_preventions_on_user_id"
  end

  create_table "health_promoters", force: :cascade do |t|
    t.string "name_entity"
    t.string "code_entity"
    t.string "nit_entity"
    t.string "regime_entity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "history_evaluations", force: :cascade do |t|
    t.date "date_create_evaluation"
    t.date "date_history_evaluation"
    t.integer "number_employees", default: 0
    t.integer "score", default: 0
    t.decimal "percentage", default: "0.0"
    t.string "result", default: "0.0"
    t.string "observation"
    t.integer "id_employee_contractor", default: 0
    t.string "firm_employee_contractor"
    t.integer "id_responsible_execution", default: 0
    t.string "firm_responsible_execution"
    t.integer "completed_items", default: 0
    t.integer "unfulfilled_items", default: 0
    t.integer "not_apply_items", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id", null: false
    t.bigint "evaluation_id", null: false
    t.bigint "risk_level_id", null: false
    t.bigint "rule_id", null: false
    t.date "date_firm_employee"
    t.date "date_firm_responsible"
    t.index ["entity_id"], name: "index_history_evaluations_on_entity_id"
    t.index ["evaluation_id"], name: "index_history_evaluations_on_evaluation_id"
    t.index ["risk_level_id"], name: "index_history_evaluations_on_risk_level_id"
    t.index ["rule_id"], name: "index_history_evaluations_on_rule_id"
  end

  create_table "history_items", force: :cascade do |t|
    t.decimal "score", default: "0.0"
    t.string "description"
    t.string "observation"
    t.integer "meets", default: 0
    t.integer "apply", default: 0
    t.integer "cycle", default: 0
    t.string "item_nro"
    t.integer "order_nro", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "evaluation_rule_detail_id", null: false
    t.bigint "history_evaluation_id", null: false
    t.index ["evaluation_rule_detail_id"], name: "index_history_items_on_evaluation_rule_detail_id"
    t.index ["history_evaluation_id"], name: "index_history_items_on_history_evaluation_id"
  end

  create_table "history_matrix_legal_items", force: :cascade do |t|
    t.integer "consecutive"
    t.string "risk_factor"
    t.string "issuing_entity"
    t.string "requirement"
    t.string "rule_name"
    t.string "applicable_article"
    t.integer "apply"
    t.string "evidence_compliance"
    t.string "responsible"
    t.integer "meets"
    t.string "description_compliance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "history_matrix_legal_id"
    t.index ["history_matrix_legal_id"], name: "index_history_matrix_legal_items_on_history_matrix_legal_id"
  end

  create_table "history_matrix_legals", force: :cascade do |t|
    t.date "date_create"
    t.integer "user_legal_representative"
    t.integer "user_adviser_sst"
    t.integer "user_responsible_sst"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "matrix_legal_id"
    t.bigint "entity_id"
    t.integer "meets_compliment", default: 0
    t.integer "meets_partial", default: 0
    t.integer "meets_earring", default: 0
    t.index ["entity_id"], name: "index_history_matrix_legals_on_entity_id"
    t.index ["matrix_legal_id"], name: "index_history_matrix_legals_on_matrix_legal_id"
  end

  create_table "indicators", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "cycle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cycle_id"], name: "index_indicators_on_cycle_id"
  end

  create_table "levels", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.integer "phone_number_entity"
    t.decimal "cell_entity"
    t.string "entity_address"
    t.integer "entity_location_code", default: 0
    t.string "entity_zone"
    t.integer "number_workers"
    t.string "name_locate"
    t.string "code_locate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id"
    t.index ["entity_id"], name: "index_locations_on_entity_id"
  end

  create_table "matrix_action_items", force: :cascade do |t|
    t.integer "consecutive", default: 0
    t.integer "year", default: 1900
    t.integer "type_corrective", default: 0
    t.string "clasification_type_corrective"
    t.integer "campus", default: 0
    t.date "date_action_conformity"
    t.string "area"
    t.string "description_action"
    t.integer "action_implement", default: 0
    t.string "responsible"
    t.date "commitment_date"
    t.date "closet_date"
    t.integer "took_actions", default: 0
    t.integer "state_actions", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "matrix_corrective_action_id"
    t.integer "origin_action", default: 0
    t.index ["matrix_corrective_action_id"], name: "index_matrix_action_items_on_matrix_corrective_action_id"
  end

  create_table "matrix_corrective_actions", force: :cascade do |t|
    t.integer "user_legal_representative"
    t.integer "user_adviser_sst"
    t.integer "user_responsible_sst"
    t.integer "version"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id"
    t.date "date_firm_legal_representative"
    t.date "date_firm_adviser_sst"
    t.date "date_firm_responsible_sst"
    t.integer "firm_legal_representative", default: 0
    t.integer "firm_adviser_sst", default: 0
    t.integer "firm_responsible_sst", default: 0
    t.date "date_create"
    t.date "date_update"
    t.index ["entity_id"], name: "index_matrix_corrective_actions_on_entity_id"
  end

  create_table "matrix_danger_items", force: :cascade do |t|
    t.integer "consecutive", default: 0
    t.integer "year", default: 0
    t.string "source_information"
    t.string "activity"
    t.string "task"
    t.integer "type_task", default: 0
    t.string "origin"
    t.string "possible_effects_health"
    t.string "possible_effects_security"
    t.string "description_existing_control_origin"
    t.string "description_existing_control_medium"
    t.string "description_existing_control_person"
    t.string "description_existing_control_observations"
    t.integer "deficiency_level", default: 0
    t.integer "exposure_level", default: 0
    t.integer "probability_level", default: 0
    t.string "interpretation"
    t.integer "consequence_level", default: 0
    t.integer "level_risk_intervention", default: 0
    t.string "risk_level_interpretation"
    t.string "risk_acceptability"
    t.integer "number_exposed", default: 0
    t.integer "hours_exposure", default: 0
    t.string "worst_consequence"
    t.integer "existence_legal_requirement", default: 0
    t.string "intervention_measures_elimination", default: "0"
    t.string "intervention_measures_replacement", default: "0"
    t.string "intervention_measures_engineering_control"
    t.string "intervention_measures_acsw"
    t.string "intervention_measures_ppee"
    t.string "responsible_implementation"
    t.string "type_register"
    t.date "proposed_date"
    t.date "implementation_date"
    t.date "follow_date"
    t.string "observations"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "matrix_danger_risk_id"
    t.bigint "clasification_danger_id"
    t.bigint "clasification_danger_detail_id"
    t.integer "number_exposed_contrators"
    t.integer "number_exposed_totals"
    t.bigint "location_id", null: false
    t.index ["clasification_danger_detail_id"], name: "index_matrix_danger_items_on_clasification_danger_detail_id"
    t.index ["clasification_danger_id"], name: "index_matrix_danger_items_on_clasification_danger_id"
    t.index ["location_id"], name: "index_matrix_danger_items_on_location_id"
    t.index ["matrix_danger_risk_id"], name: "index_matrix_danger_items_on_matrix_danger_risk_id"
  end

  create_table "matrix_danger_risks", force: :cascade do |t|
    t.integer "user_legal_representative"
    t.integer "user_adviser_sst"
    t.integer "user_responsible_sst"
    t.integer "version"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id"
    t.date "date_firm_legal_representative"
    t.date "date_firm_adviser_sst"
    t.date "date_firm_responsible_sst"
    t.integer "firm_legal_representative", default: 0
    t.integer "firm_adviser_sst", default: 0
    t.integer "firm_responsible_sst", default: 0
    t.date "date_create"
    t.date "date_update"
    t.index ["entity_id"], name: "index_matrix_danger_risks_on_entity_id"
  end

  create_table "matrix_legal_items", force: :cascade do |t|
    t.integer "consecutive"
    t.string "risk_factor"
    t.string "issuing_entity"
    t.string "requirement"
    t.string "rule_name"
    t.string "applicable_article"
    t.integer "apply"
    t.string "evidence_compliance"
    t.string "responsible"
    t.integer "meets"
    t.string "description_compliance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "matrix_legal_id"
    t.integer "year", default: 1900
    t.index ["matrix_legal_id"], name: "index_matrix_legal_items_on_matrix_legal_id"
  end

  create_table "matrix_legals", force: :cascade do |t|
    t.date "date_create"
    t.date "date_update"
    t.integer "user_legal_representative", default: 0
    t.integer "user_adviser_sst", default: 0
    t.integer "user_responsible_sst", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id"
    t.date "date_firm_legal_representative"
    t.date "date_firm_adviser_sst"
    t.date "date_firm_responsible_sst"
    t.integer "firm_legal_representative", default: 0
    t.integer "firm_adviser_sst", default: 0
    t.integer "firm_responsible_sst", default: 0
    t.integer "version", default: 0
    t.string "code"
    t.index ["entity_id"], name: "index_matrix_legals_on_entity_id"
  end

  create_table "meeting_attendees", force: :cascade do |t|
    t.string "name"
    t.string "post"
    t.string "process_area"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "meeting_minute_id", null: false
    t.index ["meeting_minute_id"], name: "index_meeting_attendees_on_meeting_minute_id"
  end

  create_table "meeting_commitments", force: :cascade do |t|
    t.integer "number"
    t.string "commitment"
    t.string "responsible"
    t.date "date_commitment"
    t.string "state_commitment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "meeting_minute_id", null: false
    t.index ["meeting_minute_id"], name: "index_meeting_commitments_on_meeting_minute_id"
  end

  create_table "meeting_minutes", force: :cascade do |t|
    t.date "date"
    t.time "start_time"
    t.time "end_time"
    t.string "code"
    t.integer "version"
    t.integer "record_number"
    t.string "area_process_committee"
    t.string "objective_meeting"
    t.string "meeting_type"
    t.string "place"
    t.string "order_day"
    t.string "Issues"
    t.string "miscellaneous_propositions"
    t.string "elaborated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id", null: false
    t.bigint "evaluation_id", null: false
    t.bigint "user_id", null: false
    t.index ["entity_id"], name: "index_meeting_minutes_on_entity_id"
    t.index ["evaluation_id"], name: "index_meeting_minutes_on_evaluation_id"
    t.index ["user_id"], name: "index_meeting_minutes_on_user_id"
  end

  create_table "occupational_exam_items", force: :cascade do |t|
    t.integer "consecutive", default: 0
    t.date "fec_exam"
    t.date "fec_venc"
    t.integer "exam_type", default: 0
    t.string "nro_identification"
    t.string "name"
    t.string "post"
    t.string "concept"
    t.string "addressing"
    t.string "recommendations"
    t.string "restrictions"
    t.string "sve"
    t.string "action"
    t.string "follow_up"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "occupational_exam_id"
    t.index ["occupational_exam_id"], name: "index_occupational_exam_items_on_occupational_exam_id"
  end

  create_table "occupational_exams", force: :cascade do |t|
    t.integer "user_legal_representative"
    t.integer "user_adviser_sst"
    t.integer "user_responsible_sst"
    t.integer "version"
    t.string "code"
    t.date "date_create"
    t.date "date_update"
    t.date "date_firm_legal_representative"
    t.date "date_firm_adviser_sst"
    t.date "date_firm_responsible_sst"
    t.integer "firm_legal_representative", default: 0
    t.integer "firm_adviser_sst", default: 0
    t.integer "firm_responsible_sst", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id"
    t.index ["entity_id"], name: "index_occupational_exams_on_entity_id"
  end

  create_table "occupational_risk_managers", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "condition", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "participants", force: :cascade do |t|
    t.integer "arl_activity_report", default: 0
    t.integer "quote_10_aditional_points", default: 0
    t.string "degree"
    t.integer "designating_by_legal_representative", default: 0
    t.integer "joint_committee_president", default: 0
    t.integer "joint_committee_secretary", default: 0
    t.string "post_copasst"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "evidence_id", null: false
    t.integer "responsible_ssst", default: 0
    t.integer "external_consultant", default: 0
    t.integer "collaborator", default: 0
    t.string "reported_activity"
    t.string "employees_activity"
    t.integer "vigia", default: 0
    t.integer "jury_voting", default: 0
    t.integer "candidate", default: 0
    t.integer "number_votes", default: 0
    t.integer "workers_representative", default: 0
    t.integer "company_representative", default: 0
    t.integer "person_complaining", default: 0
    t.integer "choose", default: 0
    t.index ["evidence_id"], name: "index_participants_on_evidence_id"
    t.index ["user_id"], name: "index_participants_on_user_id"
  end

  create_table "pension_funds", force: :cascade do |t|
    t.string "fund"
    t.string "code_fund"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "presentations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.integer "gender", default: 0
    t.integer "blood_type", default: 0
    t.integer "age", default: 0
    t.integer "weight", default: 0
    t.integer "height", default: 0
    t.integer "civil_status", default: 0
    t.integer "education_level", default: 0
    t.string "secretariat_belongs"
    t.string "dependency_belongs"
    t.string "post_actual"
    t.integer "contract_type", default: 0
    t.integer "salary_range", default: 0
    t.string "emergency_contact"
    t.string "phone_emergency_contact"
    t.integer "population_group", default: 0
    t.string "address"
    t.string "neighborhood"
    t.string "phone"
    t.integer "stratum_socioeconomic", default: 0
    t.integer "housing_type", default: 0
    t.integer "basic_housing_services", default: 0
    t.integer "head_family", default: 0
    t.integer "has_children", default: 0
    t.integer "number_children", default: 0
    t.integer "number_people_charge", default: 0
    t.integer "live_people_disability", default: 0
    t.integer "type_disability", default: 0
    t.integer "use_time", default: 0
    t.integer "diagnosed_illness", default: 0
    t.string "what_disease"
    t.integer "smoke", default: 0
    t.string "daily_average_smoke"
    t.integer "consume_alcoholic_beverages", default: 0
    t.integer "average_drinks", default: 0
    t.integer "sports_practice", default: 0
    t.integer "average_sports", default: 0
    t.integer "conveyance", default: 0
    t.integer "accept_processing_data", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "survey_profile_id"
    t.bigint "health_promoter_id"
    t.bigint "pension_fund_id"
    t.bigint "occupational_risk_manager_id"
    t.bigint "administrative_political_division_id"
    t.integer "Antiquity", default: 0
    t.integer "area_work", default: 0
    t.bigint "cessation_fund_id"
    t.index ["administrative_political_division_id"], name: "index_profiles_on_administrative_political_division_id"
    t.index ["cessation_fund_id"], name: "index_profiles_on_cessation_fund_id"
    t.index ["health_promoter_id"], name: "index_profiles_on_health_promoter_id"
    t.index ["occupational_risk_manager_id"], name: "index_profiles_on_occupational_risk_manager_id"
    t.index ["pension_fund_id"], name: "index_profiles_on_pension_fund_id"
    t.index ["survey_profile_id"], name: "index_profiles_on_survey_profile_id"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "report_officials", force: :cascade do |t|
    t.date "date"
    t.integer "number_oficial"
    t.integer "user_reports"
    t.integer "working_days_month"
    t.bigint "entity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year", default: 0
    t.integer "month", default: 0
    t.decimal "frecuencia_accidentalidad", default: "0.0"
    t.decimal "severidad_accidentalidad", default: "0.0"
    t.decimal "proporcion_accidentes_mortales", default: "0.0"
    t.decimal "prevalencia_enfermedad_laboral", default: "0.0"
    t.decimal "incidencia_enfermedad_laboral", default: "0.0"
    t.decimal "ausentismo_causa_medica", default: "0.0"
    t.integer "number_oficial_independent", default: 0
    t.integer "number_oficial_student", default: 0
    t.integer "number_oficial_temporary", default: 0
    t.integer "number_oficial_cooperative", default: 0
    t.integer "number_oficial_other", default: 0
    t.integer "total_officials", default: 0
    t.integer "total_work_accidents", default: 0
    t.integer "total_mortal_accident", default: 0
    t.integer "total_occupational_disease", default: 0
    t.integer "total_laboral_inhability", default: 0
    t.integer "total_common_inhability", default: 0
    t.integer "total_days_absenteeism", default: 0
    t.integer "total_days_severidad_accidents", default: 0
    t.integer "total_accidents_mortal_year", default: 0
    t.integer "total_accidents_work_year", default: 0
    t.integer "promedio_year_officials", default: 0
    t.integer "total_occupational_disease_year", default: 0
    t.index ["entity_id"], name: "index_report_officials_on_entity_id"
  end

  create_table "resource_items", force: :cascade do |t|
    t.integer "consecutive", default: 0
    t.string "process"
    t.string "activity"
    t.string "responsible"
    t.integer "value", default: 0
    t.integer "executed", default: 0
    t.integer "approved", default: 0
    t.date "date_approved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "resource_id"
    t.index ["resource_id"], name: "index_resource_items_on_resource_id"
  end

  create_table "resources", force: :cascade do |t|
    t.integer "year", default: 2000
    t.integer "user_legal_representative"
    t.integer "user_adviser_sst"
    t.integer "user_responsible_sst"
    t.integer "version"
    t.string "code"
    t.date "date_firm_legal_representative"
    t.date "date_firm_adviser_sst"
    t.date "date_firm_responsible_sst"
    t.integer "firm_legal_representative", default: 0
    t.integer "firm_adviser_sst", default: 0
    t.integer "firm_responsible_sst", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id"
    t.index ["entity_id"], name: "index_resources_on_entity_id"
  end

  create_table "risk_levels", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rules", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.date "creation_date"
    t.date "date_update"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "standar_detail_items", force: :cascade do |t|
    t.string "description"
    t.decimal "maximun_value", default: "0.0"
    t.integer "standar_detail", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "aplica", default: 0
    t.bigint "standar_detail_id"
    t.string "item_nro"
    t.integer "order_nro", default: 0
    t.string "criterion"
    t.string "verification_mode"
    t.index ["standar_detail_id"], name: "index_standar_detail_items_on_standar_detail_id"
  end

  create_table "standar_details", force: :cascade do |t|
    t.string "description"
    t.decimal "value", default: "0.0"
    t.integer "standar", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "standar_id"
    t.index ["standar_id"], name: "index_standar_details_on_standar_id"
  end

  create_table "standars", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.decimal "value", default: "0.0"
    t.integer "cycle", default: 0
    t.integer "rule", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "rule_id"
    t.index ["rule_id"], name: "index_standars_on_rule_id"
  end

  create_table "survey_profiles", force: :cascade do |t|
    t.date "date_profile"
    t.date "date_vencimiento_profile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id"
    t.integer "user_elaboro"
    t.integer "user_reviso"
    t.integer "user_aprobo"
    t.date "date_firm_elaboro"
    t.date "date_firm_reviso"
    t.date "date_firm_aprobo"
    t.integer "firm_elaboro", default: 0
    t.integer "firm_aprobo", default: 0
    t.integer "firm_reviso", default: 0
    t.index ["entity_id"], name: "index_survey_profiles_on_entity_id"
  end

  create_table "templates", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "standar_detail_item_id", null: false
    t.date "date"
    t.integer "version", default: 0
    t.integer "state", default: 0
    t.date "date_updated"
    t.integer "format_number", default: 0
    t.string "filing"
    t.index ["standar_detail_item_id"], name: "index_templates_on_standar_detail_item_id"
  end

  create_table "training_items", force: :cascade do |t|
    t.integer "consecutive"
    t.string "duration"
    t.string "training_topic"
    t.string "goals"
    t.string "scope"
    t.string "resources"
    t.string "responsible"
    t.date "date_training"
    t.decimal "training_coverage_percentage"
    t.decimal "percentage_trained_workers"
    t.string "observation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "training_id"
    t.index ["training_id"], name: "index_training_items_on_training_id"
  end

  create_table "trainings", force: :cascade do |t|
    t.integer "year"
    t.integer "user_legal_representative"
    t.integer "user_adviser_sst"
    t.integer "user_responsible_sst"
    t.integer "version"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id"
    t.date "date_firm_legal_representative"
    t.date "date_firm_adviser_sst"
    t.date "date_firm_responsible_sst"
    t.integer "firm_legal_representative", default: 0
    t.integer "firm_adviser_sst", default: 0
    t.integer "firm_responsible_sst", default: 0
    t.date "date_create"
    t.date "date_update"
    t.index ["entity_id"], name: "index_trainings_on_entity_id"
  end

  create_table "unsafe_conditions", force: :cascade do |t|
    t.date "date_report"
    t.string "place_report"
    t.integer "user_reports"
    t.string "description_condition"
    t.integer "equipment_condition", default: 0
    t.integer "floors_condition", default: 0
    t.integer "not_demarcate_areas", default: 0
    t.integer "gases_dusts", default: 0
    t.integer "unsafe_work_design", default: 0
    t.integer "inadequate_signage", default: 0
    t.integer "defective_tools", default: 0
    t.integer "lack_alarm", default: 0
    t.integer "lack_cleanliness", default: 0
    t.integer "lack_space_work", default: 0
    t.integer "incorrect_storage", default: 0
    t.integer "excessive_noise_levels", default: 0
    t.integer "inadequate_lighting_ventilation", default: 0
    t.string "other_unsafe_conditions"
    t.string "description_act_unsafe"
    t.integer "not_using_equipment", default: 0
    t.integer "operating_without_authorization", default: 0
    t.integer "running_facilities", default: 0
    t.integer "using_defective_tool", default: 0
    t.integer "psychoactive_substances", default: 0
    t.integer "ignore_dangerous", default: 0
    t.integer "use_wrong_tool", default: 0
    t.integer "wrong_position", default: 0
    t.integer "heights_without_authorization", default: 0
    t.integer "workplace_distractions", default: 0
    t.integer "gen_on_desk", default: 0
    t.string "other_features"
    t.string "alternative_soluctions"
    t.integer "user_receiving"
    t.integer "user_coordinator"
    t.date "date_firm_user_reports"
    t.date "date_firm_user_receiving"
    t.date "date_firm_user_coordinator"
    t.integer "firm_user_reports", default: 0
    t.integer "firm_user_receiving", default: 0
    t.integer "firm_user_coordinator", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id"
    t.integer "version"
    t.string "code"
    t.index ["entity_id"], name: "index_unsafe_conditions_on_entity_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "nro_document", null: false
    t.string "name"
    t.string "username", null: false
    t.string "email", null: false
    t.string "password_digest"
    t.integer "level", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state", default: 0
    t.integer "entity", default: 0
    t.string "activity"
    t.integer "legal_representative", default: 0
    t.integer "copasst", default: 0
    t.integer "ccl", default: 0
    t.integer "collaborator", default: 0
    t.bigint "document_id"
    t.integer "president_copasst", default: 0
    t.integer "secretary_copasst", default: 0
    t.integer "vigia_sgsst", default: 0
    t.string "cargo_rol"
    t.integer "brigade", default: 0
    t.string "cel"
    t.string "phone"
    t.index ["document_id"], name: "index_users_on_document_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["nro_document"], name: "index_users_on_nro_document", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activities", "calendars"
  add_foreign_key "activities", "entities"
  add_foreign_key "activities", "users"
  add_foreign_key "activity_users", "activities"
  add_foreign_key "activity_users", "users"
  add_foreign_key "admin_extent_dangers", "entities"
  add_foreign_key "allow_exams", "adm_exams"
  add_foreign_key "allow_exams", "entities"
  add_foreign_key "allow_exams", "users"
  add_foreign_key "annual_work_plan_items", "annual_work_plans"
  add_foreign_key "annual_work_plans", "entities"
  add_foreign_key "assistants", "meeting_minutes"
  add_foreign_key "calendars", "adm_calendars"
  add_foreign_key "clasification_danger_details", "clasification_dangers"
  add_foreign_key "complaints", "entities"
  add_foreign_key "danger_detail_risks", "clasification_danger_details"
  add_foreign_key "danger_preventions", "clasification_danger_details"
  add_foreign_key "description_jobs", "entities"
  add_foreign_key "evaluation_rule_details", "evaluations"
  add_foreign_key "evaluation_rule_details", "standar_detail_items"
  add_foreign_key "evaluations", "entities"
  add_foreign_key "evaluations", "risk_levels"
  add_foreign_key "evaluations", "rules"
  add_foreign_key "evidences", "entities"
  add_foreign_key "evidences", "evaluation_rule_details"
  add_foreign_key "evidences", "templates"
  add_foreign_key "exam_details", "exam_questions"
  add_foreign_key "exam_details", "exams"
  add_foreign_key "exam_questions", "adm_exams"
  add_foreign_key "exams", "adm_exams"
  add_foreign_key "exams", "users"
  add_foreign_key "firms", "evidences"
  add_foreign_key "firms", "users"
  add_foreign_key "form_preventions", "admin_extent_dangers"
  add_foreign_key "form_preventions", "danger_preventions"
  add_foreign_key "form_preventions", "users"
  add_foreign_key "history_evaluations", "entities"
  add_foreign_key "history_evaluations", "evaluations"
  add_foreign_key "history_evaluations", "risk_levels"
  add_foreign_key "history_evaluations", "rules"
  add_foreign_key "history_items", "evaluation_rule_details"
  add_foreign_key "history_items", "history_evaluations"
  add_foreign_key "history_matrix_legal_items", "history_matrix_legals"
  add_foreign_key "history_matrix_legals", "entities"
  add_foreign_key "history_matrix_legals", "matrix_legals"
  add_foreign_key "locations", "entities"
  add_foreign_key "matrix_action_items", "matrix_corrective_actions"
  add_foreign_key "matrix_corrective_actions", "entities"
  add_foreign_key "matrix_danger_items", "clasification_danger_details"
  add_foreign_key "matrix_danger_items", "clasification_dangers"
  add_foreign_key "matrix_danger_items", "locations"
  add_foreign_key "matrix_danger_items", "matrix_danger_risks"
  add_foreign_key "matrix_danger_risks", "entities"
  add_foreign_key "matrix_legal_items", "matrix_legals"
  add_foreign_key "matrix_legals", "entities"
  add_foreign_key "meeting_attendees", "meeting_minutes"
  add_foreign_key "meeting_commitments", "meeting_minutes"
  add_foreign_key "meeting_minutes", "entities"
  add_foreign_key "meeting_minutes", "evaluations"
  add_foreign_key "meeting_minutes", "users"
  add_foreign_key "occupational_exam_items", "occupational_exams"
  add_foreign_key "occupational_exams", "entities"
  add_foreign_key "participants", "evidences"
  add_foreign_key "participants", "users"
  add_foreign_key "profiles", "administrative_political_divisions"
  add_foreign_key "profiles", "cessation_funds"
  add_foreign_key "profiles", "health_promoters"
  add_foreign_key "profiles", "occupational_risk_managers"
  add_foreign_key "profiles", "pension_funds"
  add_foreign_key "profiles", "survey_profiles"
  add_foreign_key "profiles", "users"
  add_foreign_key "resource_items", "resources"
  add_foreign_key "resources", "entities"
  add_foreign_key "standar_detail_items", "standar_details"
  add_foreign_key "standar_details", "standars"
  add_foreign_key "standars", "rules"
  add_foreign_key "survey_profiles", "entities"
  add_foreign_key "templates", "standar_detail_items"
  add_foreign_key "training_items", "trainings"
  add_foreign_key "trainings", "entities"
  add_foreign_key "unsafe_conditions", "entities"
  add_foreign_key "users", "documents"
end
