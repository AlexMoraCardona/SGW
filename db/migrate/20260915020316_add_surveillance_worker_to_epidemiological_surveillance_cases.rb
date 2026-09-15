class AddSurveillanceWorkerToEpidemiologicalSurveillanceCases < ActiveRecord::Migration[7.0]

  def change
    add_reference :epidemiological_surveillance_cases,
                  :surveillance_worker,
                  null: true,
                  foreign_key: true,
                  index: { name: 'idx_sve_case_worker' }
  end

end
