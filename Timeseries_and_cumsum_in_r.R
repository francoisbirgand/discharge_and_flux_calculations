#########################################################################
### This is an interesting observation we should all keep in mind
### when we calculate cumulative values in time series.  In hydrology
### we calculate water and nutrient fluxes.  
### One must keep a close eye on what data exactly one is dealing with.
### Some hydrological data, usually in big rivers, 
### are reported as, e.g., the mean discharge over
### an entire day.  In this case, to calculate the cumulative volume over
### a period of, e.g., 10 days, one can add all the discharge values and multiply 
### by the time interval (expressed in the same unit as the average daily discharge,
### e.g., m³/s).  In fact in r or in Matlab, the *cumsum()* function is very nice
### as it calculates for each value the cumulative sum 
### the With high frequency sensors
### we obtain 

setwd("~/jupyternotebook")
TS1<-read.csv("Q_TS.csv",header = FALSE)
names(TS1)<-c("date","Q")
TS1
as.vector(TS1$date)
as.vector(TS1$Q)
library(plotly)
date<-as.POSIXlt(c("1999-01-18 07:00:00","1999-01-18 07:10:00","1999-01-18 07:20:00","1999-01-18 07:30:00",
                   "1999-01-18 07:40:00","1999-01-18 07:50:00","1999-01-18 08:00:00","1999-01-18 08:10:00",
                   "1999-01-18 08:20:00","1999-01-18 08:30:00","1999-01-18 08:40:00","1999-01-18 08:50:00",
                   "1999-01-18 09:00:00","1999-01-18 09:10:00","1999-01-18 09:20:00","1999-01-18 09:30:00",
                   "1999-01-18 09:40:00","1999-01-18 09:50:00","1999-01-18 10:00:00","1999-01-18 10:10:00",
                   "1999-01-18 10:20:00","1999-01-18 10:30:00","1999-01-18 10:40:00","1999-01-18 10:50:00",
                   "1999-01-18 11:00:00","1999-01-18 11:10:00","1999-01-18 11:20:00","1999-01-18 11:30:00",
                   "1999-01-18 11:40:00","1999-01-18 11:50:00","1999-01-18 12:00:00"))
Q<-c(76.7,81.5,85.9,91.4,98.6,112.7,116.3,120.3,124.7,128.7,133.6,137.9,142.2,147.1,152.3,158.3,163.0,
     168.8,174.0,179.6,184.7,190.2,196.0,200.3,205.2,209.3,213.4,217.4,221.2,225.0,229.2)
data<-as.data.frame(cbind(date,Q))
plot(date,Q)
plot_ly(data) %>%
  add_lines(x=~date,y=~Q)

mean_discharge = function(interval){}
Qh<-as.matrix(Q[-1])
dim(Qh)=c(6,5)
mQh<-apply(Qh,2,mean)
dateh<-date[date$min==0]
dateh
dateh<-as.POSIXct(dateh)
for (i in 1:7){segments(dateh[i],mQh[i],dateh[i+1],mQh[i],col = "red",lwd = 2)}


Qh<-as.matrix(Q[-1])
dim(Qh)=c(6,5)
mQh<-apply(Qh,2,mean)
dateh<-date[date$min==0]
dateh<-as.POSIXct(dateh)
par(mar=c(4.5,4.5,1,1))
xlim=as.POSIXct(c(min(date),max(date)));ylim=c(min(Q),max(Q))
plot(date,Q,xlim=xlim,ylim=ylim, panel.first = c(abline(v=dateh, lty=2 ,col = 'grey')))
plot(date,Q,xlim=xlim,ylim=ylim)

for (i in 1:7){segments(dateh[i],mQh[i],dateh[i+1],mQh[i],col = "red",lwd = 2)}
par(new=TRUE)
plot(dateh[-1],mQh,pch=15,col="red",
     xlim=xlim,ylim=ylim,
     xaxt="n",yaxt="n",xlab="",ylab="")





date<-as.POSIXct(date)
date<-as.character(date)
polygx<-cbind(head(date,-1),head(date,-1),date[-1],date[-1],head(date,-1))
polygy<-cbind(rep(0,length(Q)-1),head(Q,-1),Q[-1],rep(0,length(Q)-1),rep(0,length(Q)-1))
for (j in 1:(length(Q)-1)){polygon(as.POSIXct(as.vector(polygx[j,])),as.vector(polygy[j,]),col="pink")}
date<-as.POSIXct(date)
plot(date,Q,xlim=xlim,ylim=ylim)

timeres<-600
cumQ<-matrix(0,length(Q),1)
for (i in 1:(length(Q)-1)){QQ=(Q[i]+Q[i+1])/2*timeres;cumQ[i+1]=cumQ[i]+QQ}
cumQ<-cumQ/1000

dateh<-as.character(dateh)
rectxy<-cbind(head(dateh,-1),rep(0,length(mQh)),dateh[-1],mQh)
for (i in 1:length(mQh)){rect(as.POSIXct(rectxy[i,1]),rectxy[i,2],as.POSIXct(rectxy[i,3]),rectxy[i,4],col = "tomato")} 

CumQh<-c(0,cumsum(mQh)*timeres*6/1000)
CumQh


library(knitr)
date<-as.POSIXlt(date)
resable<-cbind(as.character(dateh),cumQ[date$min==0],cumQh,paste(signif((cumQh-cumQ[date$min==0])/cumQh*100,3),"%",sep=" "))
kable(resable)


date<-as.POSIXct(date)
dateh<-as.POSIXct(dateh)
subdate=date[date>=as.POSIXct("1999-01-18 09:00:00") & date<=as.POSIXct("1999-01-18 10:00:00") ]
subQ=subset(Q,date>=as.POSIXct("1999-01-18 09:00:00") & date<=as.POSIXct("1999-01-18 10:00:00") )
xlimzoom=as.POSIXct(c(min(date)+(max(date)-min(date))/3,min(date)+2*(max(date)-min(date))/3))
plot(date,Q,xlim=xlimzoom,ylim=ylim, panel.first = c(abline(v=dateh, lty=2 ,col = 'grey')),col="grey")
rect(as.POSIXct(rectxy[3,1]),rectxy[3,2],as.POSIXct(rectxy[3,3]),rectxy[3,4],col = "tomato")
par(new=TRUE)
plot(subdate[-1],subQ[-1],xlim=xlimzoom,ylim=ylim,cex=1.15)
subdate=as.character(subdate)
subrectxy=cbind(head(subdate,-1),rep(0,(length(subQ)-1)),subdate[-1],subQ[-1])
for (i in 1:(length(subQ)-1)){rect(as.POSIXct(subrectxy[i,1]),subrectxy[i,2],as.POSIXct(subrectxy[i,3]),subrectxy[i,4],col = "transparent")} 
polygx<-cbind(head(subdate,-1),head(subdate,-1),subdate[-1],subdate[-1],head(subdate,-1))
polygy<-cbind(rep(0,length(subQ)-1),head(subQ,-1),subQ[-1],rep(0,length(subQ)-1),rep(0,length(subQ)-1))
for (j in 1:(length(subQ)-1)){polygon(as.POSIXct(as.vector(polygx[j,])),as.vector(polygy[j,]),col="lightblue")}

  
filename<-"Lin_10min_A1_NO3_98-99_SI.csv"
temppath<-"~/Google Drive/Echantillonnage/Methods/Data/A1/NO3/98-99/"
data<-read.csv(file=paste(temppath,filename,sep=""),sep=",") 
names(data)=c("date","Q","NO3")
QQQ<-data[,2]
length(QQQ)/6
timeres<-600
cumQQQ<-matrix(0,length(QQQ),1)
for (i in 1:(length(QQQ)-1)){QQ=(QQQ[i]+QQQ[i+1])/2*timeres;cumQQQ[i+1]=cumQQQ[i]+QQ}
dim(QQQ)=c(6,8760)
QQQh<-apply(QQQ,2,mean)
cumQQQh=cumsum(QQQh)*timeres*12
tail(cumQQQh)  
  
dim(QQQ)= c(12,4380)
Q2h<-apply(QQQ,2,mean)
cumQ2h=cumsum(Q2h)*timeres*12
tail(cumQ2h) 

dim(QQQ)= c(24*6,4380*12/24/6)
nrow(QQQ)


plot_ly(data) %>%
  add_lines(x = ~date,y=~Q)










TS1<-1:10
xlim=c(0,11);ylim=c(0,11)
plot(TS1,xlim=xlim,ylim=ylim)
cumsum(TS1)
polygx<-cbind(TS1,TS1,TS1+1,TS1+1,TS1)
polygx<-head(polygx,-1)
polygy<-cbind(rep(0,10),TS1,TS1+1,rep(0,10),rep(0,10))
polygy<-head(polygy,-1)
for (j in 1:9){polygon(as.vector(polygx[j,]),as.vector(polygy[j,]),col="pink")}
rectxy<-cbind(TS1-1,rep(0,10),TS1,TS1)
for (i in 1:10){rect(rectxy[i,1],rectxy[i,2],rectxy[i,3],rectxy[i,4],col = "skyblue")} 
for (j in 1:9){polygon(as.vector(polygx[j,]),as.vector(polygy[j,]),col="pink")}
par(new=TRUE)
plot(TS1,xlim=xlim,ylim=ylim)
par(new=TRUE)
ylim2<-c(0,max(cumsum(TS1)))
plot(cumsum(TS1),xlim=xlim,ylim=ylim2,type = "l",xaxt="n",yaxt="n",xlab="",ylab="")
axis(2,)

x<-1:10
TS2<-25-(x-5)^2
xlim=c(0,11);ylim=c(0,25)
plot(x,TS2,xlim=xlim,ylim=ylim)
