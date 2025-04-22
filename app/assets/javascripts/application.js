// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "popper"
import "bootstrap" 
import "chartkick"
import "Chart.bundle"

//= require chartkick
//= require Chart.bundle

//import "direct_uploads"
require("trix")
require("@rails/actiontext")

setTimeout((function () {
    window.status = "FLAG_FOR_PDF";
    Object.keys(Chartkick.charts).forEach(function (key) {
        Chartkick.charts[key].redraw();
    });
}), 3000);


const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl))