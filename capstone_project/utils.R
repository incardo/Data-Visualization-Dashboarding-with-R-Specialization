# Check available data
#df %>% group_by(date) %>% summarise_all(funs(sum(!is.na(.)))) %>% print(n = Inf)

# df %>% group_by(date) %>% summarise_all(funs(sum(!is.na(.)))) %>%
#   gather(key="measure", value="value", all_indicators) %>%
#   ggplot(aes(x = date, y = value)) + geom_bar(stat = "identity") +
#   facet_wrap(~measure)
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