require("jsonlite")
require("RCurl")
require(dplyr)
require(lubridate)
require(ggplot2)

# Change the USER and PASS below to be your UTEid
FF <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from FAMA_FRENCH"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_tl23642', PASS='orcl_tl23642', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

GF <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from GROWTH_FUND"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_tl23642', PASS='orcl_tl23642', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

GF<- GF %>% mutate(YEAR = year(parse_date_time(DATE_, "%m%d%y")))
GF<- GF %>% mutate(MONTH = month(parse_date_time(DATE_, "%m%d%y")))
FF<- FF %>% mutate(RF = RF/100)
FF<- FF %>% mutate(MKT_RF= MKT_RF/100)

InJoin <- dplyr::inner_join(GF, FF, by=c("YEAR","MONTH"))
retm <- as.numeric(as.character(unlist(InJoin[4])))
InJoin <- InJoin %>% mutate(retm_rf = retm  - RF)
InJoin <- InJoin %>% mutate(retm_mkt = retm  - MKT_RF)

InJoin %>% group_by(ICDI) %>%filter(retm_mkt<=2)%>% summarise(avg = mean(retm_mkt)) %>% ggplot(aes(x=ICDI, y=avg)) + geom_point()