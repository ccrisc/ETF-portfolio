
# Define server logic required 
shinyServer(function(input, output, session) {
  
  hideTab("Menu",target = "Portfolio")
  observeEvent(input$button,{
    showTab("Menu",target = "Portfolio")
  })

  
  # 1. BOTTONE Get Started
  observeEvent(input$button,{
    updateTabsetPanel(session, "Menu",
                      selected = "Portfolio")
  })
  
  
#########################################################
  # 2. Definisco ETF Database --> DETAILS/Discover ETFs
  
  #configure sector imput
  filtered_sector <- reactive({
    if(input$sector == "All"){
      ETFData
    } else{
      ETFData %>%
        filter(ETFData$Sector == input$sector)
    }
  })
  #configure subector imput
  filtered_subsector <- reactive({
    if(input$subsector == "All"){
      filtered_sector()
    } else{
      filtered_sector() %>%
        filter(Subsector == input$subsector)
    }
  })
  #configure rating imput
  filtered_rating <- reactive({
    if(input$rating == "All"){
      filtered_subsector()
    } else{
      filtered_subsector() %>%
        filter(`Overall rating` == input$rating)
    }
  })
  
  #command to show data Table
  output$Database <- renderDataTable({
    datatable(
      data=filtered_rating(),
      options = list(pageLength = 20),  
      rownames = FALSE,
      style = "bootstrap4")
  })
########################################################
  #3. Portfolio Page
  observeEvent(input$button,{
  #info alert
  shinyalert(
    title = "Welcome!",
    text = "We will now create a portfolio based on sector exposure.
    
    In order to do so, please select from the first box every asset category you haven't already invested in;
    Then, if you want, select from the second box a field you are interested in.",
    closeOnEsc = TRUE,
    closeOnClickOutside = FALSE,
    html = FALSE,
    type = "",
    showConfirmButton = TRUE,
    confirmButtonText = "OK",
    confirmButtonCol = "#FF1B0F",
    animation = TRUE
  )
  })
  #validate portfolio value
  eventReactive(input$portfolioValue,{
    validate(
      need(input$portfolioValue>1000,label =  'Minimum value is 1000$')
    )
  })
  
  #Core:
  coreData <-  eventReactive(input$do,{
    #get stock prices
    user_selected <- c(input$etfs, input$themetf)
    u <- which(etfTOT$Sector==user_selected)
    desired <- c(etfTOT$Symbol[u])
    returns <- sort(desired) %>%
      tq_get(get  = "stock.prices",
             from = "2015-01-01") %>%
      group_by(symbol) %>% 
      #get returns
      tq_transmute(select     = adjusted, 
                   mutate_fun = periodReturn, 
                   period     = "daily", 
                   col_rename = "Returns") 
    #Cumulative returns
    RetCum <-  data.frame("symbol"=returns$symbol, 
                          "date"=returns$date, 
                          "Returns"=returns$Returns,
                          "Cumulative"=cumsum(returns$Returns))
    return(RetCum)
  })
  
  #CHART: cumulative returns
  output$returnsPlot <- renderHighchart({
    returnsPlot <- hchart(coreData(), 
                          "line", 
                          hcaes(x = date, 
                                y = (Cumulative * 100), 
                                group = symbol)
    ) %>%
      hc_yAxis(title = list(text = "Return"),
               labels = list(format = "{value}%")) 
    return(returnsPlot)
  })
  
#grafico Reward to volatility
  output$portPlot <- renderHighchart({
    risk_return <- coreData() %>% 
      group_by(symbol) %>% 
      summarise(Mean = mean.geometric(Returns),
                SD = StdDev(Returns),
                Slope=Mean/SD)
    return(plot_ly(data   = risk_return,
                   type   = "scatter",
                   mode   = "markers",
                   x      = ~ Mean, 
                   y      = ~ SD,
                   color  = ~ Slope, 
                   colors = 'Spectral', #or PiYG, Accent ... Colori punti
                   size   = ~ Slope,
                   #Definisco descrizione punti ETF grafico
                   text   = ~ str_c( #<em> testo in grassetto
                     "<em> Ticker: ", symbol, "</em><br>", #<br> a capo
                     "Reward to Risk: ", round(Slope, 4)), #approssimaz.
                   marker = list(opacity = 0.8,
                                 symbol = 'circle',
                                 sizemode = 'diameter',
                                 sizeref = 4.0,
                                 line = list(width = 2, color = '#FFFFFF')) #griglia interna
    ) %>%
      #Descrizione grafico: assi, titolo
      layout(title   = 'Risk vs Reward',
             xaxis   = list(title = 'Mean Returns ',
                            gridcolor = '#C0C0C0', #colore asse X
                            zerolinewidth = 2,
                            ticklen = 10,
                            gridwidth = 1), #spessore griglia
             yaxis   = list(title = 'Standard deviation',
                            gridcolor = '#C0C0C0', #colore asse Y
                            zerolinewidth = 2, #asse principale
                            ticklen = 5,
                            gridwith = 1), #spessore griglia
             margin = list(l = 50, #distanza da sinistra
                           t = 70, #distanza dal titolo
                           b = 70), #distanza da legenda
             font   = list(color = '#000000'),
             paper_bgcolor = '#f2f2f2', #colore backgroud foglio
             plot_bgcolor = '#f2f2f2') #colore backgroud grafico
    )
  })

  #PORTFOLIO CONSTRUCTION
  BuildPort  <- eventReactive(input$do, {
    returnsModel <- coreData() %>% 
      select(-Cumulative) %>% 
      spread(., symbol, Returns) %>% 
      select(-date) %>% 
      as.matrix()
    returnsModel <- replace_na(returnsModel,0)
    
    VarCov <-matrix(cov(returnsModel), 
                    nrow = ncol(returnsModel), 
                    ncol = ncol(returnsModel),
                    dimnames = list(colnames(returnsModel),colnames(returnsModel)))
    mean_return <- mean.geometric(returnsModel) 
    Gmin <- globalMin.portfolio(mean_return, VarCov, shorts=FALSE)
    Portfolio <- data.frame("Symbol"=colnames(returnsModel), "Weight"=Gmin$weights)
    Name <- etfTOT[which(etfTOT$Symbol %in% Portfolio$Symbol),2]
    Name <- Name[1:nrow(Portfolio)]
    Portfolio <- data.frame("Symbol"=Portfolio$Symbol, "Name"=Name, "Weight"=Portfolio$Weight)
    Portfolio <- data.frame("Symbol"=Portfolio$Symbol[Portfolio$Weight!=0],
                            "Name"= Portfolio$Name[Portfolio$Weight!=0],
                            "Weight"=Portfolio$Weight[Portfolio$Weight!=0])
    return(Portfolio)
  })
  
  
  #Portfolio table
  portfolioValue <- reactive({as.numeric(gsub(",", "", input$portfolioValue)) })
  output$table <- renderDataTable({
    Port <- BuildPort()
    Allocation <- cbind(Port$Weight*portfolioValue())
    portfolioAlloc <- data.frame("Symbol"=Port$Symbol,  
                                 "Name"=Port$Name, 
                                 "Weight"=Port$Weight,
                                 Allocation)
    
    return(datatable(portfolioAlloc, 
                     rownames = FALSE, 
                     selection = "none",
                     filter = "none",
                     style = "bootstrap4",
                     options = list(searching = FALSE,
                                    lengthMenu = list(c(5, 15, -1), 
                                                      list('5', '15', 'All')),
                                    pageLength = 5
                                    )
                     ) %>% 
             formatCurrency("Allocation", '$') %>% 
             formatPercentage("Weight",1)) 
  })
  
  
  #CHART: Pie chart
  output$pie <- renderHighchart({
    aaa <- BuildPort()
    fig <- plot_ly(aaa,
                   labels = ~ Symbol,
                   values = ~ Weight,
                   type = 'pie',  
                   textinfo = 'label',
                   insidetextfont = list(color = '#FFFFFF'),
                   hoverinfo = 'text',
                   text = ~paste(Name, "<br>", Weight*100, "%" ),
                   showlegend = FALSE,
                   marker = list(colors = rainbow(nrow(aaa)),
                                 line = list(color = '#FFFFFF', width = 1))) %>%
      layout(
        paper_bgcolor = '#f2f2f2', #colore backgroud foglio
        plot_bgcolor = '#f2f2f2') #colore backgroud grafico
    
    return(fig)
  })
  
  # Portfolio growth line chart
  output$portfolioGrowth <- renderHighchart({
    # CHART: Portfolio growth chart
    Crescita <- coreData()  
    returnsModel2 <- coreData() %>% 
      select(-Cumulative) %>% 
      spread(., symbol, Returns) %>% 
      select(-date) %>% 
      as.matrix()
    returnsModel2 <- replace_na(returnsModel2,0)
    
    VarCov2 <-matrix(cov(returnsModel2), 
                     nrow = ncol(returnsModel2), 
                     ncol = ncol(returnsModel2),
                     dimnames = list(colnames(returnsModel2),colnames(returnsModel2)))
    mean_return2 <- mean.geometric(returnsModel2) 
    Gmin2 <- globalMin.portfolio(mean_return2, VarCov2, shorts=FALSE)
    Portfolio2 <- data.frame("Symbol"=colnames(returnsModel2), "Weight"=Gmin2$weights)
    Name2 <- etfTOT[which(etfTOT$Symbol %in% Portfolio2$Symbol),2]
    Name2 <- Name2[1:nrow(Portfolio2)]
    Specifiche <- data.frame("Symbol"=Portfolio2$Symbol,
                             "Weight"=Portfolio2$Weight)
    
    StoricoCrescita <- tq_portfolio(Crescita,
                                    assets_col   = symbol, 
                                    returns_col  = Returns, 
                                    weights      = c(Specifiche$Weight), 
                                    col_rename   = "investment_growth",
                                    wealth.index = TRUE) %>%
      mutate(investment_growth = investment_growth * 20000) %>% 
      hchart(., "line", hcaes(x = date, y = investment_growth), color="red") %>%
      hc_yAxis(title = list(text = "Investment Growth"),
               labels = list(format = "${value}"))
    return(StoricoCrescita)
  })
  #CHART: Portfolio composition by sector
  output$portfolioSector <- renderHighchart({
    domino <- BuildPort()
    Sector <- etfTOT[which(etfTOT$Symbol %in% domino$Symbol),3]
    Sector <- Sector[1:nrow(domino)]
    Domino <- data.frame("Symbol"=domino$Symbol, Sector)
    aggregazione <- aggregate(Symbol ~ Sector, data = Domino, paste, collapse = ",")
    aggregazione <- aggregate(Symbol ~ Sector, data = Domino, paste, collapse = ",")
    y <- c(str_count(aggregazione$Symbol, ",") + 1)
    x <- levels(aggregazione$Sector)
    graphico <- plot_ly(y=y, 
                   x=x, 
                   type = "bar",
                   color = ~ x,
                   colors = "YlOrRd",
                   showlegend = FALSE,
                   hoverinfo = 'text',
                   text = ~paste(x, y),) %>%
      layout(
        paper_bgcolor = '#f2f2f2', #colore backgroud foglio
        plot_bgcolor = '#f2f2f2') #colore backgroud grafico
    return(graphico)
})

  
}) #close server