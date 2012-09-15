# Script to Scrape web pages to collect World Cup 2006 score data
# 
# Author: Paul Hurley
###############################################################################

require(ggplot2)
require(plyr)
require(stringr)
require(RCurl) 
require(XML) 

#' Function to Sort a dataframe with a given list of columns
#' Cribbed from Spector, P. (2008). "Data Manipulation with R", UseR! Springer. Pg78
#' @param df Dataframe to be sorted
#' @param ... list of columns to sort on
#' @returnType 
#' @return A sorted dataframe
#' @author "Paul Hurley"
#' @export
#' @
#' @usage with(dataframe,sortframe(dataframe,column1, column2, column3))
#' @examples with(iris,sortframe(iris,Sepal.Length,Sepal.Width,Petal.Length))
sortframe<-function(df,...){df[do.call(order,list(...)),]}


goals<-function(match) {
	theURL <-paste("http://www.fifa.com/worldcup/archive/germany2006/results/matches/match=974100",match,"/report.html",sep="")
	
	webpage = tryCatch(getURL(theURL, header=FALSE, verbose=TRUE),
			HTTPError = function(e) {
				cat("HTTP error: ", e$message, "\n")
			})
	message(paste("Webpage size is ",nchar(webpage),sep=""))
	webpagecont <- readLines(tc <- textConnection(webpage)); close(tc)
	
	fifa.doc<-htmlParse(webpagecont)
	fifa <- xpathSApply(fifa.doc, "//*/div[@class='cont']", xmlValue) 
	goals.scored <- grep("Goals scored", fifa, value=TRUE) 
	goals.scored<-gsub("Goals scored", "", strsplit(goals.scored, ", ")[[1]])
	goals.scored<-strsplit(goals.scored,"\\(|\\)")
	goals.table<-as.data.frame(matrix(unlist(goals.scored),ncol=3,byrow=TRUE))
	names(goals.table)<-c("Player","Team","Time")
	message(paste("There were ",nrow(goals.table)," goals",sep=""))
	if(nrow(goals.table)==0){
		goals.table<-data.frame(Player=NA,Team=NA,Time=NA)
	}
	
#Now get the match details
	#fifa[[1]]	#  Contains the teams and the final score
	#fifa[[2]]	#  Contains the match number, date, venue, Attendance
	goals.table$teams<-strsplit(fifa[[1]],"[0-9]")[[1]][1]
	goals.table$score<-strsplit(fifa[[1]],"[A-Za-z ]* \\- [A-Za-z ]*")[[1]][2]
	goals.table$fullmatch<-fifa[[2]]
	tempfifa<-strsplit(unlist(strsplit(fifa[[2]],"MatchDateTimeVenue / StadiumAttendance"))[2]," ")[[1]][1]
	goals.table$match<-substr(tempfifa,1,
			nchar(tempfifa)-2)
	tempfifa2<-unlist(strsplit(fifa[[2]],"MatchDateTimeVenue / StadiumAttendance"))[2]
	goals.table$date<-paste(substr(strsplit(tempfifa2,"2006")[[1]][1],1+nchar(match),1000),"2006",sep="")
	goals.table$venue<-strsplit(strsplit(tempfifa2,"2006")[[1]][2],"[0-9][0-9]:[0-5][0-9]")[[1]][1]
	goals.table$attendance<-strsplit(strsplit(tempfifa2,"2006")[[1]][2],"[0-9][0-9]:[0-5][0-9]")[[1]][2]
	return(goals.table)
}

groupa<-c("01","02","17","18","33","34")
groupb<-c("03","04","19","20","35","36")
groupc<-c("05","06","21","22","37","38")
groupd<-c("07","08","23","25","39","40")
groupe<-c("09","10","25","26","41","42")
groupf<-c("11","12","27","28","43","44")
groupg<-c("13","14","29","30","45","46")
grouph<-c("15","16","31","32","47","48")
round16<-c("49","50","51","52","53","54","55")
quater<-c("57","58","59","60")
semi<-c("61","62")
final<-c("64")
wooden<-c("63")

groupar<-ldply(groupa,goals)
groupbr<-ldply(groupb,goals)
groupcr<-ldply(groupc,goals)
groupdr<-ldply(groupd,goals)
grouper<-ldply(groupe,goals)
groupfr<-ldply(groupf,goals)
groupgr<-ldply(groupg,goals)
grouphr<-ldply(grouph,goals)
round16r<-ldply(round16,goals)
quaterr<-ldply(quater,goals)
semir<-ldply(semi,goals)
finalr<-ldply(final,goals)
woodenr<-ldply(wooden,goals)

datadir<-"/home/paul/workspace/world_cup/data/"
write.csv(groupar,paste(datadir, "groupar.csv", sep=""))
write.csv(groupbr,paste(datadir, "groupbr.csv", sep=""))
write.csv(groupcr,paste(datadir, "groupcr.csv", sep=""))
write.csv(groupdr,paste(datadir, "groupdr.csv", sep=""))
write.csv(grouper,paste(datadir, "grouper.csv", sep=""))
write.csv(groupfr,paste(datadir, "groupfr.csv", sep=""))
write.csv(groupgr,paste(datadir, "groupgr.csv", sep=""))
write.csv(grouphr,paste(datadir, "grouphr.csv", sep=""))
write.csv(round16r,paste(datadir, "round16r.csv", sep=""))
write.csv(quaterr,paste(datadir, "quaterr.csv", sep=""))
write.csv(semir,paste(datadir, "semir.csv", sep=""))
write.csv(finalr,paste(datadir, "finalr.csv", sep=""))
write.csv(woodenr,paste(datadir, "woodenr.csv", sep=""))

world.cup.2006<-rbind(groupar,groupbr,groupcr,groupdr,grouper,groupfr,groupgr,grouphr,round16r,quaterr,semir,finalr,woodenr)

write.csv(world.cup.2006,paste(datadir, "worldcup2006.csv", sep=""))


