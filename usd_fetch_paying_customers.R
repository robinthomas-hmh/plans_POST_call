library("curl")
library("jsonlite")
library("httr")


user_list <- read.csv("500other.csv")
summary(user_list)
len = NROW(user_list)
description = list()

plan_disc <- function(user) {
  app <- "planner"
  keyPrefix <- "plan-"
  requestor <- user
  #"ffdea647-59de-4202-8d4b-115d865f57b4"
  
  sif <-
    "SIF_HMACSHA256 SE1IX0RNUFM6emFsZXVvbXdaNHp2OG1EaEY1M0JEMUNrMWFDQ0tCLzdCQlJoNENjMzVYZz0K"
  
  url <-
    "http://uds.prod.hmheng-uds.brnp.internal/api/v1/data.app.query"
  
  body <- list(app = app,
               keyPrefix = keyPrefix,
               requestor = requestor)
  
  r <-
    POST(url,
         body = body,
         encode = "json",
         add_headers(
           .headers = c("Authorization" = sif,
                        "Content-Type" = "application/json")
         ))
  res <- rawToChar(r$content)
  result <- fromJSON(res)
  return(result)
}

disc_list = data.frame(userid = character(), plan = character(), desc = character() )
j<-1
k<-1
for (z in 1:len) {
  #print(user_list$userId[j])
  username <- user_list$userId[j]
  
  out <- plan_disc(username)
  val <- out$result$data$meta
    
  if(!is.null(val) ){#&& !is.na(val)){
    #print(out$result$createdBy)
    # print(out$result$data$meta$description)
    
    val = out$result$data$meta
    tab_len = NROW(val)
    
    i<-1
    for (x in 1:tab_len) {
      disc_list <- rbind(disc_list, data.frame(userid = username,
                                               plan = toString(val[i,1]),
                                               desc = toString(val[i,2])
                                               )
                         )
      i<-i+1
    }
  } 
  j<-j+1
}

write.csv(disc_list, file = "500_other.csv")

summary(disc_list)