
# Define UI for application 
shinyUI(
    #barra superiore navigazione
    navbarPage(icon("chevron-right", lib= "glyphicon"), #Nome in alto a sinistra
               id="Menu",
               collapsible = TRUE,
               fluid = TRUE, #layout fluido i adatta alla pagina
               inverse = TRUE,#sfondo nero
########################################################################
#PRIMO BOTTONE
               #Home button
               tabPanel("HOME",  
                        value = "home", #definisco nome per click
                        
                        #Definisco stile
                       includeCSS("https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css"), #core css 
                       includeCSS("www/main.css"), #custom styles
                       #includeCSS("www/Lato.css"),
                       #includeCSS("www/Raleway.css"),
                    
                       includeScript("https://kit.fontawesome.com/466fc67188.js"), #for icons
                       
                       #definisco Contenuto pagina
                       tags$div(id="copertina",
                                tags$div(class="container",
                                         tags$br(),
                                         tags$h1("Start now"),
                                         tags$h2("Build your portfolio"),
                                         tags$div(class="row",
                                                  tags$br(),
                                                  tags$br(),
                                                  actionButton("button", class="myButton","Get Started!")
                                         )
                                )
                       ),
                       tags$div(id="black",
                       tags$h3(tags$b("Connect")),
                       tags$a(href="https://twitter.com/intent/tweet?text=https%3A//criscc.shinyapps.io/Portfolio/",
                              tags$i(class="fab fa-twitter")),
                       tags$a(href="https://www.facebook.com/sharer/sharer.php?u=https%3A//criscc.shinyapps.io/Portfolio/",
                              tags$i(class="fab fa-facebook-f")),
                       tags$a(href="https://github.com/login",
                              tags$i(class="fab fa-github")),
                       tags$a(href="https://www.linkedin.com/shareArticle?mini=true&url=https%3A//criscc.shinyapps.io/Portfolio/&title=Portfolio&summary=&source=",
                              tags$i(class="fab fa-linkedin-in")),
                       tags$a(href="mailto:?subject=ETF%20Portfolio%20based&body=Check%20this%20out!%0Ahttps%3A//criscc.shinyapps.io/Portfolio/",
                              tags$i(class="fas fa-share-alt")),
                       br()
                       ),
                       tags$div(id="sottopagina",
                       tags$p("Created by",
                       tags$a(href="mailto:cesarina.criscione@usi.ch", "Cesarina Criscione"))
                       )
               ),

#########################################################################
#SECONDO BOTTONE
                          tabPanel("ABOUT",
                                   value = "about",
                                   tags$section(id="download-app",
                                   tags$div(class="container",
                                   tags$div(class="row",
                                   tags$div(class="title-area",
                                            tags$h2(class="title", "Why?"),
                                            tags$p('"An exchange-traded fund (ETF) is a type of security that involves a collection of securities—such as stocks—that often tracks an underlying index, although they can invest in any number of industry sectors or use various strategies."'),
                                            tags$p("This project is part of a thesis project which objective is to analyze sector based strategies in order to optimize the investor's total wealth."),
                                            tags$p()
                                            )))), #close section
                                   tags$section(id="howit-works",
                                   tags$div(class="howit-works-area",
                                   tags$div(class="container",
                                   tags$div(class="row",
                                   tags$div(class="title-area",
                                   tags$p()))))), #close section
                                   tags$section(id="download-app",
                                   tags$div(class="download-overlay",
                                   tags$div(class="container",
                                   tags$div(class="row",
                                   tags$div(class="title-area",
                                   tags$div(class="title", "Subscribe to Newsletter"),
                                   tags$p("Discover always something new about ETFs investments exploring all the possible porfolio combinations."),
                                   ),
                                   tags$div(class="form-group",
                                            tags$input(type="email", class="form-control", placeholder="Email"))
                                   
                                   ))))
                                   ), #close tab panel

#########################################################################
#TERZO BOTTONE
navbarMenu("DETAILS",
           #primo pulsante 
           tabPanel("Discover ETFs",
                    tags$div(id="white",
                    tags$h3("WE CARE ABOUT YOUR SATISFACTION OUR AIM IS TO PROVIDE YOU ALL THE NEEDED INFORMATIONS.")),
                    tags$div(id="grey",
                    tags$iframe(width="700" ,height="455", src="https://www.youtube.com/embed/OwpFBi-jZVg" ,frameborder="0", allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture")),
                    tags$div(id="white",
                    tags$h3("DISCOVER ALL THE AVAILABLE ETFs.")),
                            #ETF Database
        br(), #initial space
        sidebarPanel(
          selectInput(
          inputId = "sector", 
          label = "View ETFs by sector", 
          choices = c("All", unique(as.character(ETFData$Sector))), 
          selected = "All"
        )),
        sidebarPanel(
        selectInput(
          inputId = "subsector", 
          label = "Explore Subsectors", 
          choices = c("All", unique(as.character(ETFData$Subsector))), 
          selected = "All"
        )),
        sidebarPanel(
          selectInput(
            inputId = "rating", 
            label = "Sort by rating", 
            choices = c("All", unique(as.character(ETFData$`Overall rating`))), 
            selected = "All"
          )),
        
        mainPanel(
          dataTableOutput(outputId = "Database"), 
          width = 10.5),
        br() #end page space
                         #fine ETF Database
           ), #chiude tabPanel
        
        #secondo pulsante
        tabPanel("Portfolio",
                 value = "Portfolio",
                 useShinyjs(),
                 ##################
                 #Configurazione pagina
                 #add busy bouncher
                 add_busy_spinner(spin = "double-bounce", 
                                  color = "#FF3333",
                                  position = 'full-page'),
                 fluidRow(
                 sidebarPanel(
                   selectizeInput(
                     "etfs", 
                     label = "Select sectors",
                     choices = etfList$Sector,
                     multiple = TRUE,
                     options = list(placeholder = 'Select sectors')
                   )),
                 sidebarPanel(
                   selectizeInput(
                     "themetf", 
                     label = "Select fields of interest",
                     choices = ETFAdditional$Sector,
                     multiple = TRUE,
                     options = list(placeholder = 'Select your interests')
                   )),
                 sidebarPanel(
                   numericInput("portfolioValue", 
                                "Initial Investment ($)",
                                20000, 
                                step = 100,
                                min = 1000, 
                                max = 1000000)
                 )), #chiude fluidRow1
                 fluidRow(
                   tags$div(HTML("<center>"), 
                            actionButton("do", 
                                         class="PortButton",
                                         "Calculate Portfolio"))
                 ), #chiude fluidRow2
                 br(),
                 br(),
                 useShinyalert(), #info alert
                   fluidRow(
                   box(width = 6, 
                       title = "Portfolio Allocation", dataTableOutput("table")),
                   box(width = 6, 
                       title = "Asset Weights", plotlyOutput("pie"))
                 ), #chiude fluirow 1
                 
                 fluidRow(
                   box(width = 6,  title = "Portfolio Composition by Sector", plotlyOutput("portfolioSector")),
                   box(width = 6,  title = "Portfolio Growth", highchartOutput("portfolioGrowth"))
                 ),
                 br(),
                 br(),
                 tags$div(id="white",
                          tags$h3("Visualize the data of all the ETFs for the selected sectors.")),
                 br(),
                 fluidRow(
                   box(width = 6,  title = "ETFs Cumulative Returns", highchartOutput("returnsPlot")),
                   box(width = 6,  title = "Reward to Volatility", plotlyOutput("portPlot"))
                 )
                 #fine configurazione pagina
        ), #chiude tabPanel
        ##################
           #terzo pulsante
           tabPanel("Privacy Policy",
                    tags$div(id="white",
                    tags$h1("Patience"),
                    tags$p("Sorry for the inconvenience. This page is under construction."),
                    tags$p("- The team")))
), #chiude navbarmenu

###########################################################################
#QUARTO BOTTONE
tabPanel("CONTACT",
         tags$div(id="fondo",
         tags$div(id="contact", class="form",
         tags$h2("CONTACT"),
         tags$ul(class="list-unstyled li-space-lg",
         tags$li(tags$a(href="mailto:cesarina.criscione@usi.ch", "cesarina.criscione@usi.ch")),
         tags$li(tags$a(href="https://www.usi.ch/it", "Università della Svizzera Italiana")),
         tags$li("Switzerland")),
         #Contact Form
         tags$h2("OR COMPILE THE FORM BELOW"),
         tags$div(class="contact-area",
         tags$form(class="contact-form", action="mailto:cesarina.criscione@usi.ch", method="POST",
         tags$div(class="form-group",                  
         tags$input(type="text", class="form-control", placeholder="Your name")),
         tags$div(class="form-group",
         tags$input(type="email", class="form-control", placeholder="Email")),
         tags$div(class="form-group",                 
         tags$textarea(class="form-control", rows="3", placeholder="Your Message")),
         tags$a(href="mailto:cesarina.criscione@usi.ch", class="whiteButton", "Send message"),
         )))
         ))
  ) #navbarpage
) #shinyui
    
