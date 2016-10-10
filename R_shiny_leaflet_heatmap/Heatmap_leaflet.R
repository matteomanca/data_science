library(rCharts)
library(shiny)

runApp(
  
  list(ui = (fluidPage(
    headerPanel("Heatmap"),
    mainPanel(
      chartOutput("baseMap", "leaflet"),
      tags$style('.leaflet {height: 800px; width:900px;}'),
      tags$head(tags$script(src="http://leaflet.github.io/Leaflet.heat/dist/leaflet-heat.js")),
      uiOutput('heatMap')
    )
  )),
  server = function(input, output) {
    
    input_file <- "/Users/matteo.manca/Dropbox/Sync/Research-Projects/Projects/Eurecat/heatMapAndreas/results_geo.csv"
    bcn <- read.csv(input_file, sep = ';', header = TRUE)
    head(bcn)
    
    output$baseMap  <- renderMap({
      baseMap <- Leaflet$new()
      baseMap$setView(c(2.2632836,  41.3632715), 3)
      baseMap$tileLayer(provider = "OpenStreetMap.Mapnik")
      baseMap
    })
    
    output$heatMap <- renderUI({
      
      
      bcn_dat <- bcn[,c("lat","long","tweets")]
      bcn_dat <- bcn_dat[complete.cases(bcn_dat),]
      head(bcn_dat)
      
      
      ## create JSON
      j <- paste0("[",bcn_dat[, "lat"], ",", bcn_dat[,"long"], ",", bcn_dat[,"tweets"], "]", collapse=",")
      j <- paste0("[",j,"]")
      
      tags$body(tags$script(HTML(sprintf("
                                         var addressPoints = %s
                                         var heat = L.heatLayer(addressPoints).addTo(map)"
                                         , j
      ))))
      
    })
  }
      ))