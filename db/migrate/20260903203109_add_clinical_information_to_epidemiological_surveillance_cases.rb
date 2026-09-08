class AddClinicalInformationToEpidemiologicalSurveillanceCases < ActiveRecord::Migration[7.0]
  def change
    add_column :epidemiological_surveillance_cases, :symptom_onset, :string
    add_column :epidemiological_surveillance_cases, :symptom_start_date, :date
    add_column :epidemiological_surveillance_cases, :symptoms, :string
    add_column :epidemiological_surveillance_cases, :reported_diagnosis, :string
    add_column :epidemiological_surveillance_cases, :disability_days, :integer

    add_column :epidemiological_surveillance_cases,
               :possible_occupational_exposure,
               :boolean,
               default: false

    add_column :epidemiological_surveillance_cases,
               :contact_with_symptomatic_people,
               :boolean,
               default: false

    add_column :epidemiological_surveillance_cases,
               :initial_measures,
               :string

    add_column :epidemiological_surveillance_cases,
               :return_to_work,
               :integer,
               default: 0,
               null: false
  end
end
