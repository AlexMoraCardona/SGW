class HomesController < ApplicationController
    def index 
         @calendars =  Calendar.where("year = ? and month = ? and day >= ?", Date.today.year, Date.today.month, Date.today.day).order(:day) 
         @activities = Activity.all.order(:citation)
    end    

    def show
         
    end    
end  