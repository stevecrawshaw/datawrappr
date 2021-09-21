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

# use datawRappr::

datawrapper_auth(api_key = apikey)
dw_get_api_key()

# this checks to see we have a valid API key and returns some user data
check_url <- "https://api.datawrapper.de/v3/me/"

r <- GET(check_url, add_headers(Authorization =  glue("Bearer {apikey}")))

content(r, as = "text") %>% 
  fromJSON() %>% 
  unlist() %>% 
  enframe() 
