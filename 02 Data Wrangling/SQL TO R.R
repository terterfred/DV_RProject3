require("jsonlite")
require("RCurl")
require(dplyr)
require(lubridate)

# Change the USER and PASS below to be your UTEid
FF <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from FAMA_FRENCH"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_tl23642', PASS='orcl_tl23642', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

GF <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from GROWTH_FUND"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_tl23642', PASS='orcl_tl23642', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

GF<- GF %>% mutate(YEAR = year(parse_date_time(DATE_, "%m%d%y")))
GF<- GF %>% mutate(MONTH = month(parse_date_time(DATE_, "%m%d%y")))

FLJoin <- dplyr::full_join(GF, FF, by=c("YEAR","MONTH"))

