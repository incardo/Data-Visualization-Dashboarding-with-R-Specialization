library(shiny)
library(tidyverse)
library(plotly)
library(DT)

#####Import Data

dat<-read_csv(url("https://www.dropbox.com/s/uhfstf6g36ghxwp/cces_sample_coursera.csv?raw=1"))
dat<- dat %>% select(c("pid7","ideo5","newsint","gender","educ","CC18_308a","region"))
dat<-drop_na(dat)

#####Make your app
#####Hint: when you make the data table on page 3, you may need to adjust the height argument in the dataTableOutput function. Try a value of height=500


ui <- navbarPage(
  title="My Application",
  
  tabPanel("Page 1",
           
           sidebarLayout(
             sidebarPanel(
               
               sliderInput(
                 inputId="ideology",
                 label="Select Five Point Ideology (1=Very liberal, 5=Very conservative)",
                 min=1,
                 max=5,
                 value=3,
                 sep=""),

             ),
             mainPanel(
               tabsetPanel(
                 tabPanel("Tab 1", plotOutput("distPlot")), 
                 tabPanel("Tab 2", plotOutput("trumpPlot"))
                         )
                       )
                     )
           
           ),
  
  tabPanel("Page 2",
           
           sidebarLayout(
             sidebarPanel(
               
               checkboxGroupInput(inputId="gender",
                                  label="Select gender",
                                  choices=c(1, 2),
                                  selected=c(1, 2))
               
             ),
             mainPanel(
               plotlyOutput(outputId = "scatter")
             )
           )
           
  ),
  
  tabPanel("Page 3",
           
           sidebarLayout(
             sidebarPanel(
               
               selectInput("region","Select Region",
                           c(1,2,3,4), multiple = TRUE)
               
             ),
             mainPanel(
               dataTableOutput(outputId = "regionplot")
             )
           )
           
  )
)

server<-function(input,output){
  
  output$distPlot <- renderPlot({

    plot_data <- dat %>% filter(ideo5==input$ideology)
    ggplot(plot_data, aes(x=pid7)) + geom_bar(stat = "count", col = "grey")+
      scale_x_continuous(limits = c(0, 8))+
      scale_y_continuous(breaks = seq(0, 125, by = 25), limits = c(0, 125))+
      labs(y="Count", x = "7 Point Party ID, 1=Very D, 7=Very R")
    })
  
  output$trumpPlot <- renderPlot({
    
    plot_data <- dat %>% filter(ideo5==input$ideology)
    ggplot(plot_data, aes(x=CC18_308a)) + geom_bar(stat = "count", col = "grey")+
      scale_x_continuous(limits = c(0, 5))+
      #scale_y_continuous(breaks = seq(0, max(plot_data$CC18_308a), by = 25), limits = c(0, max(plot_data$CC18_308a)))+
      labs(y="count", x = "Trump support")
  })
  
  output$scatter <- renderPlotly({
    
    plot_data <- dat %>% filter(gender %in% input$gender)
    
    ggplot(plot_data,aes(x=educ,y=pid7))+
      geom_jitter()+
      geom_smooth(method='lm')+
      labs(y="pid7", x = "educ")
  })
  
  
  output$regionplot <- renderDataTable({
    filter(dat, region %in% input$region)})
  
}

shinyApp(ui=ui,server=server)
