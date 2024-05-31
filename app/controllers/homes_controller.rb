class HomesController < ApplicationController
    def index 
         @calendars =  Calendar.where("year = ? and month >= ?", Date.today.year, Date.today.month).order(:day) 
         @activities = Activity.all.order(:citation)
    end    

    def show
         
    end    
end  