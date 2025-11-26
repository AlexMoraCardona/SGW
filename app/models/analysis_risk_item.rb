class AnalysisRiskItem < ApplicationRecord
    belongs_to :analysis_risk
    has_rich_text :basic_steps
    has_rich_text :actions_steps
    has_rich_text :measures_steps
end
