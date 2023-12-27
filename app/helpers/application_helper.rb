module ApplicationHelper
    def image_tag(img , options={})
        if Rails.env.development? || Rails.env.test?
            assets_path = "#{Rails.root}/app/assets/images/#{img}"
            #if !img.present? or !(File.file?(assets_path) or File.file?(img)) && !img.include?("file://")
            if !img.present?   && !img.include?("file://")

                img = "xxno_image.gif"
            end
        end
        super(img, options)
    end
end
