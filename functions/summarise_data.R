summarise_data <- function(data = NULL, inColumns = NULL, exclude = NULL){
  data = as.data.table(data %>%
                       na.omit()%>%
                       count_(inColumns))
  
  if(!is.null(exclude)){
    inColumns = inColumns[inColumns != exclude]
  }
  
  for(changei in inColumns){
    
    tmp_total = data[, list(total = sum(n)), by = changei]
    names(tmp_total) = c(changei, paste0(changei, '_n'))
    
    data = merge(data, tmp_total, by = changei)
    
    data[[changei]] = paste0(data[[changei]], ':', data[[paste0(changei, '_n')]])
    
    data[[paste0(changei, '_n')]] = NULL
  }
  
  return(data)
}