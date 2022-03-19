library(shiny)
library(tidyverse)

#####Import Data

dat<-read_csv(url("https://www.dropbox.com/s/uhfstf6g36ghxwp/cces_sample_coursera.csv?raw=1"))
dat<- dat %>% select(c("pid7","ideo5"))
dat<-drop_na(dat)

## Practice chart
dat %>% filter(ideo5==5) %>%ggplot(aes(x=pid7)) + geom_histogram(col = "grey", bins = 7, center = 0)

ui<-fluidPage(
  
  titlePanel("Distribution of party membership of survey respondents"),
  
  sliderInput("ideology",
                  "Select Five Point Ideology (1=Very liberal, 5=Very conservative)",
                  min = 1,
                  max = 5,
                  value = 1),
  plotOutput("distPlot")
)
  
  
  server<-function(input, output) {
    
    output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      plot_data <- dat %>% filter(ideo5==input$ideology)
      x    <- plot_data$pid7
      #bins <- 7
      
      #dat %>% filter(ideo5==input$ideology) %>%ggplot(aes(x=pid7)) + geom_histogram(col = "grey", bins = 7, center = 0) +
      #labs(y="Count", x = "7 Point Party ID, 1=Very D, 7=Very R")
      
      
      # generate bins based on input$bins from ui.R
      #x    <- dat %>% filter(ideo5==input$ideology)  %>% select(pid7)
      plot_data <- dat %>% filter(ideo5==input$ideology)
      
      ggplot(plot_data, aes(x=pid7)) + geom_bar(stat = "count", col = "grey")+
      scale_x_continuous(limits = c(0, 8))+
      scale_y_continuous(breaks = seq(0, 125, by = 25), limits = c(0, 125))+
      labs(y="Count", x = "7 Point Party ID, 1=Very D, 7=Very R")
        
      
    })
  }

shinyApp(ui,server)


