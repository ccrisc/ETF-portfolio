library(dplyr)
library(DT)
library(here)
library(highcharter)
library(IntroCompFinR)
library(knitr)
library(PerformanceAnalytics)
library(plotly)
library(quantmod) 
library(RColorBrewer)
library(rsconnect)
library(shiny)
library(shinyalert)
library(shinybusy)
library(shinycssloaders)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyjs)
library(shinythemes)
library(shinyWidgets)
library(stringr)
library(tidyr)
library(tidyquant)

options(repos = c("R-Forge" = "https://R-Forge.R-project.org", CRAN="https://cran.rstudio.com"))

#no scientific notation
options(scipen=999) 
#ETF Database --> DETAILS/Discover ETFs
source("ETFs/1-ETF-bysector.R") 
#etflist for PORTFOLIO section
load("ETFs/data/etf_data.rda", envir = .GlobalEnv) 
load("ETFs/data/etf_data_additional.rda", envir = .GlobalEnv) 
load("ETFs/data/etfTOT.rda", envir = .GlobalEnv) 

#Graph sources
#https://thedatagame.com.au/2016/12/24/a-single-index-model-shiny-app-for-etfs/   

#reward to volatility graph source:
# source: https://www.business-science.io/investments/2016/11/30/Russell2000_Analysis.html

