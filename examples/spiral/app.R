library(shiny)
library(rscatter)

# Define UI for app that draws a fermat spiral ----
ui <- fluidPage(

  # App title ----
  titlePanel("Fermat Spiral"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(

      # Input: Slider for range ----
      sliderInput(inputId = "range",
                  label = "Range:",
                  min = pi/2,
                  max = 50*pi,
                  step = pi/4,
                  value = 10*pi),

      # Input: Slider for the step ----
      sliderInput(inputId = "step",
                  label = "Step:",
                  min = 0.001,
                  max = 1,
                  value = 0.01),

      # Input: Slider for the point size ----
      sliderInput(inputId = "size",
                  label = "Point size:",
                  min = 0.1,
                  max = 10,
                  value = 1.5)

    ),

    # Main panel for displaying outputs ----
    mainPanel(
      rscatterOutput("rscatterPlot", height = "700px")
    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {

  output$rscatterPlot <- renderRscatter({
    phi = seq(from = 0, to = input$range, by = input$step)
    fermat_spiral = data.frame(
     x = c(-sqrt(phi)*cos(phi), sqrt(phi)*cos(phi)),
     y = c(-sqrt(phi)*sin(phi), sqrt(phi)*sin(phi)),
     branch = rep(c("a", "b"), each = length(phi))
     )
    rscatter("x", "y", size = input$size, colorBy = "branch", data = fermat_spiral)
  })

}

shinyApp(ui, server)
