#PART 1: Data preparation
#ETF by sector 
#Preparing data

#1 sector
ConsumerDiscretionary <- read.csv("ETFs/etfdb_csv/Consumer-Discretionary.csv", header = TRUE, stringsAsFactors = FALSE)

for (i in 1:nrow(ConsumerDiscretionary)) {
  ConsumerDiscretionary$Asset.Class[i] <- 'Consumer Discretionary'
}

#2 sector
ConsumerStaples <- read.csv("ETFs/etfdb_csv/Consumer-Staples.csv", header = TRUE, stringsAsFactors = FALSE)

for (i in 1:nrow(ConsumerStaples)) {
  ConsumerStaples$Asset.Class[i] <- 'Consumer Staples'
}

#3 sector
Energy <- read.csv("ETFs/etfdb_csv/Energy.csv", header = TRUE, stringsAsFactors = FALSE)

for (i in 1:nrow(Energy)) {
  Energy$Asset.Class[i] <- 'Energy'
}


#4 sector
Financials <- read.csv("ETFs/etfdb_csv/Financials.csv", header = TRUE, stringsAsFactors = FALSE)

for (i in 1:nrow(Financials)) {
  Financials$Asset.Class[i] <- 'Financials'
}

#5 sector
Healthcare <- read.csv("ETFs/etfdb_csv/Healthcare.csv", header = TRUE, stringsAsFactors = FALSE)

for (i in 1:nrow(Healthcare)) {
  Healthcare$Asset.Class[i] <- 'Healthcare'
}

#6 sector
Industrials <- read.csv("ETFs/etfdb_csv/Industrials.csv", header = TRUE, stringsAsFactors = FALSE)

for (i in 1:nrow(Industrials)) {
  Industrials$Asset.Class[i] <- 'Industrials'
}

#7 sector
Materials <- read.csv("ETFs/etfdb_csv/Materials.csv", header = TRUE, stringsAsFactors = FALSE)

for (i in 1:nrow(Materials)) {
  Materials$Asset.Class[i] <- 'Materials'
}

#8 sector
RealEstate <- read.csv("ETFs/etfdb_csv/Real-Estate.csv", header = TRUE, stringsAsFactors = FALSE)

for (i in 1:nrow(RealEstate)) {
  RealEstate$Asset.Class[i] <- 'Real Estate'
}

#9 sector
Technology <- read.csv("ETFs/etfdb_csv/Technology.csv", header = TRUE, stringsAsFactors = FALSE)

for (i in 1:nrow(Technology)) {
  Technology$Asset.Class[i] <- 'Technology'
}


#10 sector
Telecom <- read.csv("ETFs/etfdb_csv/Telecom.csv", header = TRUE, stringsAsFactors = FALSE)

for (i in 1:nrow(Telecom)) {
  Telecom$Asset.Class[i] <- 'Telecom'
}

#11 sector
Utilities <- read.csv("ETFs/etfdb_csv/Utilities.csv", header = TRUE, stringsAsFactors = FALSE)

for (i in 1:nrow(Utilities)) {
  Utilities$Asset.Class[i] <- 'Utilities'
}

#Complete DATASET
#created on 20/02/2020 from etfdb.com
ETFData <- data.frame(rbind(ConsumerDiscretionary, ConsumerStaples, Energy, 
                        Financials, Healthcare, Industrials, Materials, 
                        RealEstate, Technology, Telecom, Utilities))

#Needed for UI-Database
#for discover etfs page
ETFData <- ETFData[c(1:3,22,4,32,42)]
colnames(ETFData)<- c("Symbol", "Name", "Sector", "Subsector", "Total Assets", "Holdings", "Overall rating")
#for portfolio page
etfList <- ETFData[1:4]
save(etfList,file = "ETFs/data/etf_data.rda")

############################################################################
#ADDITIONALS
#Topic of interest 
Agriculture <- read.csv("ETFs/etfdb_csv/additional/Agriculture.csv", header = TRUE, stringsAsFactors = FALSE)

for (i in 1:nrow(Agriculture)) {
  Agriculture$Asset.Class[i] <- 'Agriculture'
}
Agriculture <- Agriculture[c(1:3,22)]
colnames(Agriculture)<- c("Symbol", "Name", "Sector", "Subsector")


AI <- read.csv("ETFs/etfdb_csv/additional/AI.csv", header = TRUE, stringsAsFactors = FALSE)

for (i in 1:nrow(AI)) {
  AI$Asset.Class[i] <- 'Artificial Intelligence'
}
AI <- AI[c(1:3,22)]
colnames(AI)<- c("Symbol", "Name", "Sector", "Subsector")


Blockchain <- read.csv("ETFs/etfdb_csv/additional/Blockchain.csv", header = TRUE, stringsAsFactors = FALSE)

for (i in 1:nrow(Blockchain)) {
  Blockchain$Asset.Class[i] <- 'Blockchain'
}
Blockchain <- Blockchain[c(1:3,22)]
colnames(Blockchain)<- c("Symbol", "Name", "Sector", "Subsector")


Emerging_Markets <- read.csv("ETFs/etfdb_csv/additional/Emerging_Markets.csv", header = TRUE, stringsAsFactors = FALSE)

for (i in 1:nrow(Emerging_Markets)) {
  Emerging_Markets$Asset.Class[i] <- 'Emerging Markets'
}
Emerging_Markets <- Emerging_Markets[c(1:2,19,19)]
colnames(Emerging_Markets)<- c("Symbol", "Name", "Sector", "Subsector")


ETFAdditional <- data.frame(rbind(Agriculture, AI, Blockchain, Emerging_Markets))
save(ETFAdditional,file = "ETFs/data/etf_data_additional.rda")

#####################################################################
#TOTAL RDA

etfTOT <- data.frame(rbind(etfList, ETFAdditional))
etfTOT <- etfTOT[order(etfTOT$Symbol),]
save(etfTOT,file = "ETFs/data/etfTOT.rda")



