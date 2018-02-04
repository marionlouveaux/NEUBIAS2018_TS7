#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Filopodian analysis"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        fileInput("Batch", label = h3("Batch analysis")),
        fileInput("Manual", label = h3("Manual analysis")),
        fileInput("Perso", label = h3("Another batch analysis")),
        selectInput("select", label = h3("Select box"), 
                    choices = list("Plot Boxplot and CDF" = 1, "Choice 2" = 2, "Choice 3" = 3), 
                    selected = 1),
        actionButton("action", label = "Run Filopodyan analysis")

      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("boxPlot"),
         downloadButton('foo')
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$value <- renderPrint({
    str(Batch$file)
  })
  
  output$value <- renderPrint({
    str(Manual$file)
  })
  
  output$value <- renderPrint({
    str(Perso$file)
  })
  
  output$value <- renderPrint({ input$select })
  output$value <- renderPrint({ input$action })
  
  plotInput <- function(){
    par(mfrow = c(2,2))
    
    x1 <- "med.rate.extens"
    
    curr.data <- StandardGraphInput(x1, adjust.spt = "divide"); curr.data
    Boxplot2(x1, 
             curr.title = "Median Extension Rate Per Filopodium",              # <---- Remember to edit here!
             curr.Ylab = expression("Median fDCTM (extending) [" * mu * "m/s]")  # <---- Remember to edit here!
    )
    legend("topright", QuickStats(x1), bty = "n", cex = 0.8)
    
    CdfPlot2(x1, adjust.spt = "divide",
             curr.title = "Median Extension Rate (CDF)",
             curr.Xlab = expression("Median fDCTM (extending) [" * mu * "m/s]") )
  }
  
  observeEvent(input$action, {
  
   output$boxPlot <- renderPlot({
     
     par(mfrow = c(2,2))
     
     x1 <- "med.rate.extens"
     
     curr.data <- StandardGraphInput(x1, adjust.spt = "divide"); curr.data
     Boxplot2(x1, 
              curr.title = "Median Extension Rate Per Filopodium",              # <---- Remember to edit here!
              curr.Ylab = expression("Median fDCTM (extending) [" * mu * "m/s]")  # <---- Remember to edit here!
     )
     legend("topright", QuickStats(x1), bty = "n", cex = 0.8)
     
     CdfPlot2(x1, adjust.spt = "divide",
              curr.title = "Median Extension Rate (CDF)",
              curr.Xlab = expression("Median fDCTM (extending) [" * mu * "m/s]") )

   })
  })
  
  library(ggplot2)

  output$downloadPlot <- downloadHandler(

      ggplot2::ggsave("test.png", plot = plotInput(), device = "png")
    
  )
  
   

}

# Run the application 
shinyApp(ui = ui, server = server)

