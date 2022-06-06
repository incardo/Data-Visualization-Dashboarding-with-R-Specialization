
library(flexdashboard)
library(tidyverse)
library(plotly)
library(ggplot2)
library(shiny)

library(tictoc)
library(wbstats)
library(gganimate)


environment <- c("EN.POP.DNST", "EN.ATM.CO2E.KT", "EN.ATM.GHGT.KT.CE", "EG.ELC.FOSL.ZS")
economy <- c("NY.GDP.MKTP.PP.CD", "NY.GDP.PCAP.PP.CD", "NE.RSB.GNFS.ZS")
society <- c("SP.POP.TOTL", "SP.POP.GROW", "SP.DYN.TFRT.IN")
all_indicators <- c(environment,economy,society)

tic()
df <- wb_data(country = "all", indicator = all_indicators, start_date = 1990, end_date = 2020)
toc()
dim(df)

library(countrycode)

df$continent <- countrycode(sourcevar = df[["country"]],
            origin = "country.name",
            destination = "continent")

# Check available data
df %>% group_by(date) %>% summarise_all(funs(sum(!is.na(.)))) %>% print(n = Inf)

df %>% group_by(date) %>% summarise_all(funs(sum(!is.na(.)))) %>%
  gather(key="measure", value="value", all_indicators) %>%
  ggplot(aes(x = date, y = value)) + geom_bar(stat = "identity") +
  facet_wrap(~measure)
# 
# summary(df)
# indicator <- "EG.ELC.FOSL.ZS"
# df %>% select(country, date, indicator) %>% filter(!is.na(indicator)) %>% select(country) %>% unique %>% print(n = Inf)


#renderText(names(titles)[titles == input$Indicator])
# renderText(df %>% select(iso3c, country,date, as.name(input$Indicator)) %>% filter(!is.na(df[[input$Indicator]])) %>% select(date) %>% max(na.rm = TRUE))
#renderTable(df %>% select(iso3c, country,date, input$Indicator) %>% filter(!is.na(input$Indicator)) %>% select(date) %>% distinct())

#df %>% select(iso3c, country,date, as.name(input$Indicator)) %>% filter(!is.na(df[[input$Indicator]])) %>% select(date) %>% max(na.rm = TRUE)
# renderText({
#   fig_dat_all<-df %>% select(iso3c, country,date, EN.ATM.CO2E.KT, SP.POP.TOTL, NY.GDP.MKTP.PP.CD)
#   max(fig_dat_all[[input$Indicator]],na.rm = TRUE)
# })



all_data<-df %>% select(iso3c, country,date, EN.ATM.CO2E.KT) #%>% filter(date==2000) %>% slice_max(EN.ATM.CO2E.KT, n = 10)

top_10 <- all_data %>% 
  group_by(date) %>% 
  slice_max(order_by = EN.ATM.CO2E.KT, n=15) %>% 
  mutate(ranking = rank(-EN.ATM.CO2E.KT)) %>% 
  ungroup()

p <- top_10 %>%
  ggplot(aes(x = -ranking,y = EN.ATM.CO2E.KT, group = country)) +
  geom_tile(aes(y = EN.ATM.CO2E.KT / 2, height = EN.ATM.CO2E.KT, fill = country), width = 0.9) +
  geom_text(aes(label = country), hjust = "right", colour = "black", fontface = "bold", nudge_y = -100000) +
  geom_text(aes(label = scales::comma(EN.ATM.CO2E.KT)), hjust = "left", nudge_y = 100000, colour = "grey30") +
  coord_flip(clip="off") +
  scale_fill_discrete(guide = 'none')+
  scale_x_discrete("") +
  scale_y_continuous("",labels=scales::comma) +
  hrbrthemes::theme_ipsum(plot_title_size = 32, subtitle_size = 24, caption_size = 20, base_size = 20) +
  theme(panel.grid.major.y=element_blank(),
        panel.grid.minor.x=element_blank(),
        #legend.position = c(0.4, 0.2),
        plot.margin = margin(1,1,1,2,"cm"),
        axis.text.y=element_blank()) +
  # gganimate code to transition by year:
  transition_time(date) +
  ease_aes('cubic-in-out') +
  labs(title='World largest polluters',
       subtitle='Tons of CO2 emissions in {round(frame_time,0)}',
       caption='Source: World Bank
Rocco Incardona / @incardo')

animate(p, nframes = 750, fps = 25, end_pause = 50, width = 600, height = 1000)

anim_save("Rplot.gif", animation = last_animation())


renderImage({
  # A temp file to save the output.
  # This file will be removed later by renderImage
  outfile <- tempfile(fileext='.gif')
  
  # now make the animation
  p = ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, 
                            color = continent)) + geom_point() + scale_x_log10() +
    transition_time(year) # New
  
  anim_save("outfile.gif", animate(p)) # New
  
  # Return a list containing the filename
  list(src = "outfile.gif",
       contentType = 'image/gif'
       # width = 400,
       # height = 300,
       # alt = "This is alternate text"
  )}, deleteFile = TRUE)}

