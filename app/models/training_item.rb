class TrainingItem < ApplicationRecord

    def self.calculos(id)
        @training_item = TrainingItem.find(id)
        if @training_item.present?
            @training_item.training_coverage_percentage = ((@training_item.cant_emple_cap.to_f / @training_item.cant_emple.to_f) * 100).round(2) if @training_item.cant_emple > 0
            @training_item.percentage_trained_workers = ((@training_item.cant_cap.to_f / @training_item.cant_emple_cap.to_f) * 100).round(2) if @training_item.cant_emple_cap > 0
        end    
        @training_item.save
    end    

end
