packages <- c("config", "fastverse", "tidyverse", "here", "janitor", "httr", "jsonlite", "DatawRappr", "glue")
library(xfun)
pkg_attach2(packages)
# devtools::install_github("munichrocker/DatawRappr")
# library(DatawRappr)

apikey <- get(file = "credentials/config.yml",
              config = "default",
              value = "access_token")

user <- get(file = "credentials/config.yml",
            config = "default",
            value = "user")

datawrapper_auth(api_key = apikey)
dw_get_api_key()

config <- list(
  add_headers(Authorization =  glue("Bearer {apikey}"))
)

check_url <- "https://api.datawrapper.de/v3/me/"

r <- GET(check_url, add_headers(Authorization =  glue("Bearer {apikey}")))

content(r, as = "text") %>% 
  fromJSON() %>% 
  unlist() %>% 
  enframe() 
