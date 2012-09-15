# TODO: Add comment
# 
# Author: paul
###############################################################################


require(ggplot2)
require(plyr)
require(stringr)

datadir<-"/home/paul/workspace/world_cup/data/"

firstgoal<-read.csv(file=paste(datadir, "firstgoals.csv", sep=""))
top5firstgoal<-read.csv(file=paste(datadir, "top5firstgoal.csv", sep=""))
top5<-read.csv(file=paste(datadir, "top5.csv", sep=""))

qplot(Timen,data=firstgoal, geom="histogram", binwidth=1)
qplot(Timen,data=firstgoal, geom="histogram", binwidth=5)
qplot(Timen,data=firstgoal, geom="histogram", binwidth=10)

qplot(factor(Team), Timen, data=firstgoal, geom="boxplot")+geom_jitter()

qplot(factor(Team), Timen, data=world.cup.2006, geom="boxplot")+geom_jitter()

qplot(Timen,data=top5firstgoal, geom="histogram", binwidth=1)
qplot(Timen,data=top5firstgoal, geom="histogram", binwidth=5)

ggplot(top5firstgoal,aes(Timen, fill=Team))+geom_density(alpha=0.2)

qplot(factor(Team), Timen, data=top5firstgoal, geom="boxplot")+geom_jitter()

qplot(factor(Team), Timen, data=top5, geom="boxplot")+geom_jitter()





