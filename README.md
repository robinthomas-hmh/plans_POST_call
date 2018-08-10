<HTML><BODY>
<h1>USD data fetch - Paying customers</h1>
</BODY></HTML>
POST API call to UDS server using httr library in R


## Adding Libraries

```
library("curl")
library("jsonlite")
library("httr")
```
## Fetch csv
```
user_list <- read.csv("paying50.csv")
summary(user_list)
```
Output
```
##                                   userId   actor.userName.raw..Descending
##  e45a4dd0-8297-4b8e-87ac-a3fd249a3213: 1   100911@hcps.net: 1            
##  e47e6778-566b-4e01-8747-95c96248f4b6: 1   133011@hcps.net: 1            
##  e53107d1-50eb-4b42-8b0b-129937ab2ce7: 1   135961@hcps.net: 1            
##  e6062e45-cee1-42b0-803e-7c1fa15d7dd1: 1   143148@hcps.net: 1            
##  e780ebac-dd4d-444b-8812-212d1d0d76d4: 1   168355@hcps.net: 1            
##  e880011e-84ac-4acd-8882-67777cef5080: 1   177841@hcps.net: 1            
##  (Other)                             :43   (Other)        :43            
##      Count       
##  Min.   : 1.000  
##  1st Qu.: 1.000  
##  Median : 1.000  
##  Mean   : 2.041  
##  3rd Qu.: 1.000  
##  Max.   :33.000  
## 
```
## Function for POST call
```
len = NROW(user_list)
description = list()

plan_disc <- function(user) {
  
  #key values
  app <- "planner"
  keyPrefix <- "plan-"
  requestor <- user
  
  #authentication
  sif <-
    "SIF_HMACSHA256 SE1IX0RNUFM6emFsZXVvbXdaNHp2OG1EaEY1M0JEMUNrMWFDQ0tCLzdCQlJoNENjMzVYZz0K"
  #Add URL
  url <-
    "http://uds.prod.hmheng-uds.brnp.internal/api/v1/data.app.query"
  
  #Add key values to body
  body <- list(app = app,
               keyPrefix = keyPrefix,
               requestor = requestor)
  #POST call
  r <-
    POST(url,
         body = body,
         encode = "json",
         add_headers(
           .headers = c("Authorization" = sif,
                        "Content-Type" = "application/json")
         ))
  
  #Get content value from the output
  res <- rawToChar(r$content)
  #Convert chars to json format
  result <- fromJSON(res)
  return(result)
}

#Create empty data frame for adding description data
disc_list = data.frame(userid = character(), plan = character(), desc = character() )

j<-1
k<-1
for (z in 1:len) {
  username <- user_list$userId[j]
  
  out <- plan_disc(username)
  val <- out$result$data$meta
    
  if(!is.null(val) ){
    print(out$result$createdBy)
    print(out$result$data$meta$description)
    
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
```
Output
```
## [1] "ffdea647-59de-4202-8d4b-115d865f57b4"
## NULL
## [1] "ffd7fc7b-a04e-420b-8c9c-b6605e864bae"
## NULL
## [1] "fe9f5a12-d61c-4c16-8f52-c43ccb26b78b"
## NULL
## [1] "fe72a13e-0f8e-481a-87bb-aba2275885bb"
## [1] "Students will be able to understand how the United States, though mistakes were made, formed a government that would be a model for the world."
## [1] "fd66366a-e83f-493c-8ca2-424de003f622"
## [2] "fd66366a-e83f-493c-8ca2-424de003f622"
## [3] "fd66366a-e83f-493c-8ca2-424de003f622"
## [1] NA                                          
## [2] NA                                          
## [3] "HS-ESS2-2, HS-ESS2-4, HS-ESS2-7, HS-ESS2-6"
## [1] "fd2e731f-9db8-4e6b-8cea-5dc352b822e2"
## NULL
## [1] "fd179508-ebcd-4471-8a28-99195cf1e37c"
## [1] "Goal: To introduce the students toScience."
## [1] "fc8eaef9-6dde-4384-8c8c-9f8e75498a5f"
## NULL
## [1] "fa92ba85-6b88-4952-8dd6-11caecca88ca"
## NULL
## [1] "fa0ccefa-f8ff-4d89-8b36-a47b78e0f393"
## NULL
## [1] "f9d9c992-a4e7-4b30-80d3-3857ccf4e6c2"
## NULL
## [1] "f9505a58-a654-4450-8f1e-0f08e5d7862e"
## [1] "Using Our Senses\n"
## [1] "f78de100-8e5d-4b6e-8a83-0a39ea2e0f30"
## NULL
## [1] "f6b70258-73f8-4f5c-8cd7-4a001f3cd3bf"
## [1] "goals"
## [1] "f623571d-f5b8-42d0-80df-57d605383f69"
```
## Final Output
```
disc_list
```
Output
```
--------------------------------------------------------------------------------------------------------
userid                                plan
--------------------------------------------------------------------------------------------------------
ffdea647-59de-4202-8d4b-115d865f57b4	1A United States History	
ffd7fc7b-a04e-420b-8c9c-b6605e864bae	Unit 3	
fe9f5a12-d61c-4c16-8f52-c43ccb26b78b	Magazine 1	
fe72a13e-0f8e-481a-87bb-aba2275885bb	Module 5: Forming a Government	
fd66366a-e83f-493c-8ca2-424de003f622	Earth Semester	
fd66366a-e83f-493c-8ca2-424de003f622	Intro A & A	
fd66366a-e83f-493c-8ca2-424de003f622	Unit 1 Intro Earth & space	
fd2e731f-9db8-4e6b-8cea-5dc352b822e2	hjkh	
fd179508-ebcd-4471-8a28-99195cf1e37c	Unit 1 Nature of Science Lesson 1 Scientific Knowledge	
fc8eaef9-6dde-4384-8c8c-9f8e75498a5f	Unit 1 - Matter and Change
```
