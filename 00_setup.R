packages <- c("config", "fastverse", "tidyverse", "here", "janitor", "httr", "jsonlite", "DatawRappr", "glue")
library(xfun)
pkg_attach2(packages)
# devtools::install_github("munichrocker/DatawRappr")
# library(DatawRappr)

# access the API key from config file
apikey <- get(file = "credentials/config.yml",
              config = "default",
              value = "access_token")
# get the user
user <- get(file = "credentials/config.yml",
            config = "default",
            value = "user")

# setup headers for ease
headers_auth <- add_headers(.headers = c("Authorization" =  glue("Bearer {apikey}")))
headers_content <- add_headers(.headers = c("content-type" = "application/json"))
headers_accept <- add_headers(.headers = c("Accept" = "*/*"))

# use datawRappr::

# datawrapper_auth(api_key = apikey)
dw_get_api_key()

# this checks to see we have a valid API key and returns some user data
check_url <- "https://api.datawrapper.de/v3/me/"

r <- GET(check_url, add_headers(Authorization =  glue("Bearer {apikey}")))

content(r, as = "text") %>% 
  fromJSON() %>% 
  unlist() %>% 
  enframe() 

response_as_tbl <- . %>% 
  content(as = "text") %>% 
  fromJSON() %>% 
  unlist() %>% 
  enframe()

# utility function to get id of a viz

get_id <- . %>% 
  content(as = "text") %>% 
  fromJSON() %>% 
  pluck("id")
