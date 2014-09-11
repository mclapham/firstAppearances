library(shiny)

#reads time interval names, ages, colors
time_int<-read.csv("http://paleobiodb.org/data1.1/intervals/list.txt?scale=1&limit=all")
periods<-subset(time_int,time_int$level==3)

# Define server logic for random distribution application
shinyServer(function(input, output) {
      
  dataInput<-reactive({
    occurrences<-read.csv(paste("http://paleobiodb.org/data1.1/occs/list.txt?base_name=",input$taxon,"&show=loc&limit=99999",sep=""))
    
    occurrences$mean_age<-rowMeans(cbind(occurrences$early_age,occurrences$late_age))
    
    return(occurrences)

  })
  
  
  output$plot<-renderPlot({
    dataset<-dataInput()
    hist_output<-hist(dataset$mean_age,breaks=seq(0,545,by=1),plot=F)
    hist_data<-data.frame(counts=hist_output$counts,mids=hist_output$mids)
    hist_data<-subset(hist_data,hist_data$counts>0)
    layout(matrix(c(1,2),ncol=2),widths=c(1,5))
    par(mar=c(5,4,1.25,0))
    plot(0,0,type="n",xlim=c(0,5),xaxt="n",xlab="",ylab="Age (Ma)",ylim=c(max(hist_data$mids),min(hist_data$mids)),bty="n")
    rect(0,periods$early_age,5,periods$late_age,col=paste(periods$color))
    text(rep(2.5,nrow(periods)),rowMeans(cbind(periods$early_age,periods$late_age)),periods$abbrev)
    mtext(input$taxon,side=3,adj=0,cex=1.5)
    par(mar=c(5,0,1.25,1))
    plot(hist_data$counts,hist_data$mids,type="n",xlab="Number of occurrences",xlim=c(0,max(hist_data$counts)),ylim=c(max(hist_data$mids),min(hist_data$mids)),yaxt="n",ylab="",bty="n")
    segments(rep(0,length(hist_data$mids)),hist_data$mids,hist_data$counts,hist_data$mids,lwd=3,col="steelblue3")
  })
  
  maxOcc<-reactive({
    dataset<-dataInput()
    subset(dataset,dataset$mean_age==max(dataset$mean_age))
  })
  
  maxOccSp<-reactive({
    dataset<-dataInput()
    species<-subset(dataset,dataset$matched_rank==3)
    subset(species,species$mean_age==max(species$mean_age))
  })
  
  output$table1<-renderTable({
    max_occ<-maxOcc()
    data.frame(taxon=max_occ$matched_name,
               collection=max_occ$collection_no,
               early_interval=max_occ$early_interval,
               max_age=max_occ$early_age,
               late_interval=max_occ$late_interval,
               min_age=max_occ$late_age
               )
    })
    
    
   output$table2<-renderTable({
      max_occ<-maxOccSp()
      data.frame(taxon=max_occ$matched_name,
                 collection=max_occ$collection_no,
                early_interval=max_occ$early_interval,
                 max_age=max_occ$early_age,
                 late_interval=max_occ$late_interval,
                 min_age=max_occ$late_age
                  )
    })  
})
