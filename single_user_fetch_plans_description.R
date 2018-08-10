library("curl")
library("jsonlite")
library(httr)

app <- "planner"
keyPrefix <- "plan-"
requestor <- "f0c5600b-0cf1-4d0b-89b1-fd2481e790e0"

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
print(result$result$data)

tab_len = NROW(result$result$data$meta)
val = result$result$data$meta

disc_list = data.frame(userid = character(), plan = character())
disc_list <- rbind(disc_list, data.frame(userid = toString('val[i,1]'), plan = toString('val[i,2]')))

i<-1
for (j in 1:tab_len) {
  #print(val[i,1:2])
  #disc_list$username [i] <-val[i,1]
  #disc_list[i,2]<-val[i,2]
  disc_list <- rbind(disc_list, data.frame(userid = toString(val[i,1]), plan = toString(val[i,2])))
  
  i<-i+1
}
