library(jsonlite)
library(mapreduce)
library(ggplot2)
library(cowplot)
library(patchwork)

file<-"data/flight_data.jdat"

initial_time<-as.numeric(as.POSIXct(strptime("2024/01/25 16:20:10", "%Y/%m/%d %H:%M:%S")))
processRow <- function(row){
  if(startsWith(row,"{")){
    json_final<-fromJSON(row)
    if(!is.null(json_final[["flightData"]])){
      timeStamp<-as.numeric(as.POSIXct(strptime(json_final[["time"]], "%Y/%m/%d %H:%M:%S")))
      if(timeStamp>=initial_time)
        return(data.frame(json_final[["flightData"]],time=json_final[["time"]],timestamp=((timeStamp-initial_time)/60)))
      else
        return(data.frame())
    }
    else
      return(data.frame())
  } else {
    return(data.frame())
  }
}

con = file(file, "r")

list_data <- mapReduce_map_ndjson(con,processRow)
close(con)


fdr_data <- mapReduce_reduce(list_data)

p1 <- ggplot(fdr_data, aes(fdr_data$timestamp, simDR_vvi_fpm_pilot))+
  geom_line() +
  labs(y = "VVI (fpm)") +
  theme(axis.line = element_line())


p2 <- ggplot(fdr_data, aes(fdr_data$timestamp, simDR_ind_airspeed_kts_pilot)) +
  geom_line()+
  labs(y = "Airspeed (kts)") +
  expand_limits(x = 0, y = 0)+
  theme(axis.line = element_line())

p3 <- ggplot(fdr_data, aes(timestamp, simDR_pressureAlt1)) +
  geom_line(aes(color = "simDR_pressureAlt1"))+
  labs(y = "Pressure Altitude (feet)") +
  geom_line(aes(y=simDR_ind_airspeed_kts_pilot,color = "simDR_ind_airspeed_kts_pilot"))+
  geom_line(aes(y=simDR_vvi_fpm_pilot,color = "simDR_vvi_fpm_pilot"))+
  theme(axis.line = element_line(),
        plot.margin = margin(10, 10, 10, 30))
p1yMax=layer_scales(p1)$y$range$range[2]
p1yMin=layer_scales(p1)$y$range$range[1]
p2yMax=layer_scales(p2)$y$range$range[2]
p3yMax=layer_scales(p3)$y$range$range[2]
p1Mul=p3yMax/(p1yMax-p1yMin)
p2Mul=p3yMax/p2yMax

p3 <- ggplot(fdr_data, aes(timestamp, simDR_pressureAlt1)) +
  geom_line(aes(color = "Pressure Altitude (feet)"))+
  labs(y = "Pressure Altitude (feet)") +
  geom_line(aes(y=simDR_ind_airspeed_kts_pilot*p2Mul,color = "Airspeed (kts)"))+
  geom_line(aes(y=(-1*p1yMin*p1Mul+simDR_vvi_fpm_pilot*p1Mul),color = "VVI (fpm)"))+
  theme(axis.line = element_line(),
        plot.margin = margin(10, 10, 10, 30))
wrap_elements(get_plot_component(p1, "ylab-l")) +
  wrap_elements(get_y_axis(p1)) +
  wrap_elements(get_plot_component(p2, "ylab-l")) +
  wrap_elements(get_y_axis(p2)) +
  p3 +
  labs(x = "Time (mins)") +
  plot_layout(widths = c(3, 1, 3, 1, 40))
