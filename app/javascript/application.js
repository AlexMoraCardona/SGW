// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import "popper"
import "bootstrap" 

import "chartkick"
import "Chart.bundle"
import "chartkick/chart.js"

//import "direct_uploads"
require("trix")
require("@rails/actiontext")

setTimeout((function () {
    window.status = "FLAG_FOR_PDF";
    Object.keys(Chartkick.charts).forEach(function (key) {
        Chartkick.charts[key].redraw();
    });
}), 3000);





