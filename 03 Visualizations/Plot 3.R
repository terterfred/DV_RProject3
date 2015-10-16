require("jsonlite")
require("RCurl")
require(dplyr)
require(lubridate)
require(ggplot2)
require(graphics)

FF <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from FAMA_FRENCH"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_tl23642', PASS='orcl_tl23642', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

GF <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from GROWTH_FUND"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_tl23642', PASS='orcl_tl23642', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))


GF<- GF %>% mutate(YEAR = year(parse_date_time(DATE_, "%m%d%y")))
GF<- GF %>% mutate(MONTH = month(parse_date_time(DATE_, "%m%d%y")))
FF<- FF %>% mutate(RF = RF/100)
FF<- FF %>% mutate(MKT_RF= MKT_RF/100)

Antijoin <- dplyr::anti_join(GF, FF, by=c("YEAR","MONTH"))
Antijoin %>% group_by(ICDI) %>% summarise(count = n())
retm <- as.numeric(as.character(unlist(GF[4])))
GF %>% mutate(Retm = retm) %>% filter(ICDI == 51 |ICDI == 53| ICDI==64) %>% ggplot(aes(x=DATE_,y=Retm,color=ICDI,group=ICDI)) + geom_line()

