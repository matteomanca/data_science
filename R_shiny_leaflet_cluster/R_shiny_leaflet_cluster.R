
library(shiny)
library(sp)
library(leaflet)
library(RColorBrewer)
library(dplyr)


summary = read.csv("/Users/matteo.manca/Dropbox/Sync/Research-Projects/Projects/Eurecat/urbaning/DATASETS-COMPLETE-PROCESSED/tweets_2015_bcn-complete.csv", header = F)

dim(summary)
head(summary)



ui <- fluidPage(
  headerPanel('Tweets bcn 2015'),
  leafletOutput("mymap", width="800", height="800"))


server <- function(input, output, session) {
  
  output$mymap <- renderLeaflet({
    
    m <- leaflet()
    m <- addProviderTiles(m, "CartoDB.DarkMatter", options = providerTileOptions(noWrap = TRUE))
    
    
    m <-addMarkers(m,
                   lng=summary$V6,
                   lat=summary$V5,
                   clusterOptions = markerClusterOptions()
                   
    )
    
    
    m <- setView(m, lng = 2.15, lat = 41.35630, zoom = 6)
    return(m)
  })
}

shinyApp(ui, server)

