# TODO: Add comment
# 
# Author: paul
###############################################################################


require(ggplot2)
require(plyr)
require(stringr)
require(RCurl) 
require(XML) 
sortframe<-function(df,...){df[do.call(order,list(...)),]}

datadir<-"/home/paul/workspace/world_cup/data/"

world.cup.2006<-read.csv(paste(datadir, "worldcup2006.csv", sep=""))

world.cup.2006$Timen<-as.numeric(str_extract(as.character(world.cup.2006$Time)," [0-9]*"))

teamgoals<-ddply(subset(world.cup.2006,!is.na(Team)),.(Team),nrow)

top5<-subset(world.cup.2006,Team %in% (with(teamgoals,sortframe(teamgoals,-V1))$Team[1:5]))

top5$Team<-factor(top5$Team)

write.csv(top5, paste(datadir, "top5.csv", sep=""))

firstgoal<-ddply(world.cup.2006,.(match),function(df) {
			with(df,sortframe(df,Timen))
			return(df[1,])
		})

write.csv(firstgoal,paste(datadir, "firstgoals.csv", sep=""))

top5firstgoal<-ddply(top5,.(match),function(df) {
			with(df,sortframe(df,Timen))
			return(df[1,])
		})

write.csv(top5firstgoal,paste(datadir, "top5firstgoal", sep=""))
