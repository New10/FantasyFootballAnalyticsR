###########################
# File: NFL Projections.R
# Description: Downloads Fantasy Football Projections from NFL.com
# Date: 3/3/2013
# Author: Isaac Petersen (isaac@fantasyfootballanalytics.net)
# Notes:
# To do:
###########################

#Load libraries
library("XML")
library("stringr")
library("ggplot2")
library("plyr")

#Suffix
suffix <- "nfl"

#Functions
source(paste(getwd(),"/R Scripts/Functions/Functions.R", sep=""))
source(paste(getwd(),"/R Scripts/Functions/League Settings.R", sep=""))

#Download fantasy football projections from NFL.com
qb1_nfl <- readHTMLTable("http://fantasy.nfl.com/research/projections?position=1&sort=projectedPts&statCategory=projectedStats&statSeason=2014&statType=seasonProjectedStats", stringsAsFactors = FALSE)$`NULL`
qb2_nfl <- readHTMLTable("http://fantasy.nfl.com/research/projections?offset=26&position=1&sort=projectedPts&statCategory=projectedStats&statSeason=2014&statType=seasonProjectedStats", stringsAsFactors = FALSE)$`NULL`
rb1_nfl <- readHTMLTable("http://fantasy.nfl.com/research/projections?position=2&statCategory=projectedStats&statSeason=2014&statType=seasonProjectedStats", stringsAsFactors = FALSE)$`NULL`
rb2_nfl <- readHTMLTable("http://fantasy.nfl.com/research/projections?offset=26&position=2&sort=projectedPts&statCategory=projectedStats&statSeason=2014&statType=seasonProjectedStats", stringsAsFactors = FALSE)$`NULL`
rb3_nfl <- readHTMLTable("http://fantasy.nfl.com/research/projections?offset=51&position=2&sort=projectedPts&statCategory=projectedStats&statSeason=2014&statType=seasonProjectedStats", stringsAsFactors = FALSE)$`NULL`
rb4_nfl <- readHTMLTable("http://fantasy.nfl.com/research/projections?offset=76&position=2&sort=projectedPts&statCategory=projectedStats&statSeason=2014&statType=seasonProjectedStats", stringsAsFactors = FALSE)$`NULL`
wr1_nfl <- readHTMLTable("http://fantasy.nfl.com/research/projections?position=3&sort=projectedPts&statCategory=projectedStats&statSeason=2014&statType=seasonProjectedStats", stringsAsFactors = FALSE)$`NULL`
wr2_nfl <- readHTMLTable("http://fantasy.nfl.com/research/projections?offset=26&position=3&sort=projectedPts&statCategory=projectedStats&statSeason=2014&statType=seasonProjectedStats", stringsAsFactors = FALSE)$`NULL`
wr3_nfl <- readHTMLTable("http://fantasy.nfl.com/research/projections?offset=51&position=3&sort=projectedPts&statCategory=projectedStats&statSeason=2014&statType=seasonProjectedStats", stringsAsFactors = FALSE)$`NULL`
wr4_nfl <- readHTMLTable("http://fantasy.nfl.com/research/projections?offset=76&position=3&sort=projectedPts&statCategory=projectedStats&statSeason=2014&statType=seasonProjectedStats", stringsAsFactors = FALSE)$`NULL`
wr5_nfl <- readHTMLTable("http://fantasy.nfl.com/research/projections?offset=101&position=3&sort=projectedPts&statCategory=projectedStats&statSeason=2014&statType=seasonProjectedStats", stringsAsFactors = FALSE)$`NULL`
wr6_nfl <- readHTMLTable("http://fantasy.nfl.com/research/projections?offset=126&position=3&sort=projectedPts&statCategory=projectedStats&statSeason=2014&statType=seasonProjectedStats", stringsAsFactors = FALSE)$`NULL`
te1_nfl <- readHTMLTable("http://fantasy.nfl.com/research/projections?position=4&statCategory=projectedStats&statSeason=2014&statType=seasonProjectedStats", stringsAsFactors = FALSE)$`NULL`
te2_nfl <- readHTMLTable("http://fantasy.nfl.com/research/projections?offset=26&position=4&sort=projectedPts&statCategory=projectedStats&statSeason=2014&statType=seasonProjectedStats", stringsAsFactors = FALSE)$`NULL`

#Add variable names for each object
fileList <- c("qb1_nfl","qb2_nfl","rb1_nfl","rb2_nfl","rb3_nfl","rb4_nfl","wr1_nfl","wr2_nfl","wr3_nfl","wr4_nfl","wr5_nfl","wr6_nfl","te1_nfl","te2_nfl")

for(i in 1:length(fileList)){
  assign(fileList[i],get(fileList[i])[1:dim(get(fileList[i]))[1],])
  t <- get(fileList[i])
  names(t) <-  c("player_nfl","opp_nfl","gp_nfl","passYds_nfl","passTds_nfl","passInt_nfl","rushYds_nfl","rushTds_nfl","recYds_nfl","recTds_nfl","fumbleTds_nfl","twoPts_nfl","fumbles_nfl","pts_nfl")
  t[t == "-"] <- 0
  assign(fileList[i], t)
}

#Merge players within position
qb_nfl <- rbind(qb1_nfl,qb2_nfl)
rb_nfl <- rbind(rb1_nfl,rb2_nfl,rb3_nfl,rb4_nfl)
wr_nfl <- rbind(wr1_nfl,wr2_nfl,wr3_nfl,wr4_nfl,wr5_nfl,wr6_nfl)
te_nfl <- rbind(te1_nfl,te2_nfl)

#Add variable for player position
qb_nfl$pos <- as.factor("QB")
rb_nfl$pos <- as.factor("RB")
wr_nfl$pos <- as.factor("WR")
te_nfl$pos <- as.factor("TE")

#Merge players across positions
projections_nfl <- rbind(qb_nfl,rb_nfl,wr_nfl,te_nfl)

#Add missing variables
projections_nfl$passAtt_nfl <- NA
projections_nfl$passComp_nfl <- NA
projections_nfl$rushAtt_nfl <- NA
projections_nfl$rec_nfl <- NA
projections_nfl$returnTds_nfl <- NA

#Convert variables from character strings to numeric
projections_nfl[,c("gp_nfl","passAtt_nfl","passComp_nfl","passYds_nfl","passTds_nfl","passInt_nfl","rushAtt_nfl","rushYds_nfl","rushTds_nfl","rec_nfl","recYds_nfl","recTds_nfl","fumbleTds_nfl","returnTds_nfl","twoPts_nfl","fumbles_nfl","pts_nfl")] <-
  convert.magic(projections_nfl[,c("gp_nfl","passAtt_nfl","passComp_nfl","passYds_nfl","passTds_nfl","passInt_nfl","rushAtt_nfl","rushYds_nfl","rushTds_nfl","rec_nfl","recYds_nfl","recTds_nfl","fumbleTds_nfl","returnTds_nfl","twoPts_nfl","fumbles_nfl","pts_nfl")], "numeric")

#Player names
qbnames <- str_sub(projections_nfl$player_nfl, end=str_locate(string=projections_nfl$player_nfl, c("QB"))[,1]-2) #"QB -"
rbnames <- str_sub(projections_nfl$player_nfl, end=str_locate(string=projections_nfl$player_nfl, c("RB"))[,1]-2) #"RB -"
wrnames <- str_sub(projections_nfl$player_nfl, end=str_locate(string=projections_nfl$player_nfl, c("WR"))[,1]-2) #"WR -"
tenames <- str_sub(projections_nfl$player_nfl, end=str_locate(string=projections_nfl$player_nfl, c("TE"))[,1]-2) #"TE -"

qbnames <- qbnames[1:length(projections_nfl[which(projections_nfl$pos == "QB"),"pos"])]
rbnames <- rbnames[(length(projections_nfl[which(projections_nfl$pos == "QB"),"pos"]) + 1):(length(projections_nfl[which(projections_nfl$pos == "QB"),"pos"]) + length(projections_nfl[which(projections_nfl$pos == "RB"),"pos"]))]
wrnames <- wrnames[(length(projections_nfl[which(projections_nfl$pos == "QB"),"pos"]) + length(projections_nfl[which(projections_nfl$pos == "RB"),"pos"]) + 1):(length(projections_nfl[which(projections_nfl$pos == "QB"),"pos"]) + length(projections_nfl[which(projections_nfl$pos == "RB"),"pos"]) + length(projections_nfl[which(projections_nfl$pos == "WR"),"pos"]))]
tenames <- tenames[(length(projections_nfl[which(projections_nfl$pos == "QB"),"pos"]) + length(projections_nfl[which(projections_nfl$pos == "RB"),"pos"]) + length(projections_nfl[which(projections_nfl$pos == "WR"),"pos"]) + 1):(length(projections_nfl[which(projections_nfl$pos == "QB"),"pos"]) + length(projections_nfl[which(projections_nfl$pos == "RB"),"pos"]) + length(projections_nfl[which(projections_nfl$pos == "WR"),"pos"]) + length(projections_nfl[which(projections_nfl$pos == "TE"),"pos"]))]
  
projections_nfl$name_nfl <- c(na.omit(qbnames),na.omit(rbnames),na.omit(wrnames),na.omit(tenames))
projections_nfl$name <- nameMerge(projections_nfl$name_nfl)

#Player teams
projections_nfl$team_nfl <- str_trim(str_sub(projections_nfl$player_nfl, start=str_locate(string=projections_nfl$player_nfl, c(" - "))[,1]+3, end=str_locate(string=projections_nfl$player_nfl, c(" - "))[,1]+6)) #, end=str_locate(string=projections_nfl$player_nfl, c("-"))[,1]+5

#Remove duplicate cases
projections_nfl[projections_nfl$name %in% projections_nfl[duplicated(projections_nfl$name),"name"],]
#projections_nfl[which(projections_nfl$name_nfl=="Charles Clay"),"pos"] <- "TE"

#Rename players
projections_nfl[projections_nfl$name=="TIMOTHYWRIGHT", "name"] <- "TIMWRIGHT"

#Calculate overall rank
projections_nfl$overallRank_nfl <- rank(-projections_nfl$pts_nfl, ties.method="min")

#Calculate Position Rank
projections_nfl$positionRank_nfl <- NA
projections_nfl[which(projections_nfl$pos == "QB"), "positionRank_nfl"] <- rank(-projections_nfl[which(projections_nfl$pos == "QB"), "pts_nfl"], ties.method="min")
projections_nfl[which(projections_nfl$pos == "RB"), "positionRank_nfl"] <- rank(-projections_nfl[which(projections_nfl$pos == "RB"), "pts_nfl"], ties.method="min")
projections_nfl[which(projections_nfl$pos == "WR"), "positionRank_nfl"] <- rank(-projections_nfl[which(projections_nfl$pos == "WR"), "pts_nfl"], ties.method="min")
projections_nfl[which(projections_nfl$pos == "TE"), "positionRank_nfl"] <- rank(-projections_nfl[which(projections_nfl$pos == "TE"), "pts_nfl"], ties.method="min")

#Order variables in data set
projections_nfl <- projections_nfl[,c(prefix, paste(varNames, suffix, sep="_"))]

#Order players by overall rank
projections_nfl <- projections_nfl[order(projections_nfl$overallRank_nfl),]
row.names(projections_nfl) <- 1:dim(projections_nfl)[1]

#Density Plot
ggplot(projections_nfl, aes(x=pts_nfl), fill=pos) + geom_density(fill="green", alpha=.3) + xlab("Player's Projected Points") + ggtitle("Density Plot of NFL.com Projected Points")
ggsave(paste(getwd(),"/Figures/NFL projections.jpg", sep=""), width=10, height=10)
dev.off()

#Save file
save(projections_nfl, file = paste(getwd(),"/Data/NFL-Projections.RData", sep=""))
write.csv(projections_nfl, file=paste(getwd(),"/Data/NFL-Projections.csv", sep=""), row.names=FALSE)

save(projections_nfl, file = paste(getwd(),"/Data/Historical Projections/NFL-Projections-2014.RData", sep=""))
write.csv(projections_nfl, file=paste(getwd(),"/Data/Historical Projections/NFL-Projections-2014.csv", sep=""), row.names=FALSE)
