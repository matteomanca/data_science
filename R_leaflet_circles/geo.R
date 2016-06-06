

library(shiny)
library(sp)
library(leaflet)
library(RColorBrewer)
library(dplyr)


load("./summary.Rdata")
pal <- colorQuantile(palette=c("green", "yellow", "orange", "red"), domain=log(summary$median_price))

dim(summary)

# summary = summary[1:500,]

summary <- summary[sample(1:nrow(summary), 500,replace=FALSE),]

ui <- fluidPage(
  headerPanel('Distribution of UK Rental Rates by Postcode'),
  leafletOutput("mymap", width="800", height="800"))


server <- function(input, output, session) {
	
	output$mymap <- renderLeaflet({
		
		m <- leaflet()
		m <- addProviderTiles(m, "CartoDB.DarkMatter", options = providerTileOptions(noWrap = TRUE))
		
		m <- addCircles(m,
						lng=summary$outCodeLong,
						lat=summary$outCodeLat,
 						radius=summary$radius,
						weight=3,
						opacity=0.5,
						color="green"
						# label=paste(summary$postcode, ": Q1=", summary$p1, "%", sep="") 
)
		
		m <- addCircles(m,
						lng=summary$outCodeLong[summary$q1>0],
						lat=summary$outCodeLat[summary$q1>0],
						radius=summary$radius1[summary$q1>0],
						weight=2,
						opacity=0.8,
						color="yellow"
						# label=paste(summary$outCode[summary$q1>0], ": Q2=", summary$p2[summary$q1>0], "%", sep="")
						)
		
		m <- addCircles(m,
						lng=summary$outCodeLong[summary$q2>0],
						lat=summary$outCodeLat[summary$q2>0],
						radius=summary$radius2[summary$q2>0],
						weight=1,
						opacity=0.7,
						color="orange"
						# label=paste(summary$outCode[summary$q2>0], ": Q3=", summary$p3[summary$q2>0], "%", sep="")
						)
		
		m <- addCircles(m,
						lng=summary$outCodeLong[summary$q3>0],
						lat=summary$outCodeLat[summary$q3>0],
						radius=summary$radius3[summary$q3>0],
						weight=1,
						opacity=0.7,
						color="red"
						# label=paste(summary$outCode[summary$q3>0], ": Q4=", summary$p4[summary$q3>0], "%", sep="")
						)
		
		m <- addLegend(m, "bottomleft", pal = pal, values = log(summary$median_price),
					   title = "Median Price Quartile",
					   opacity = 1)
		
		m <- setView(m, lng = -2.5, lat = 54.5, zoom = 6)
		return(m)
	})
}

shinyApp(ui, server)
