source("00_setup.R")

# Charts ----

chart_url <- "https://api.datawrapper.de/v3/charts"

r_chart <- POST(url = chart_url,
                add_headers(Authorization =  glue("Bearer {apikey}")),
                body = '{ "title": "Where do people live?", "type": "d3-bars-stacked" }',
                encode = "raw")
# OR
r_chart <- POST(url = chart_url,
                add_headers(.headers = c("Authorization" =  glue("Bearer {apikey}"),
                                         "content-type" = "application/json")),
                body = list(title = "Annual NO2 Data",
                type = "d3-bars-stacked"),
                encode = "json")

# get chart ID from response
chart_id <- r_chart %>% 
  content(as = "text") %>% 
  fromJSON() %>% 
  pluck("id")
 
r_chart %>% 
  content(as = "text") %>% 
  fromJSON() %>%
unlist() %>%
  enframe() %>%
  view()

  
# Data ----
path = "C:/Users/User/Documents/R Projects/R Projects/datawrappr/data/no2-diffusion-tube-data.csv"
created_chart_url <- glue("https://api.datawrapper.de/v3/charts/{chart_id}/data")
# put the data
PUT(created_chart_url,
    add_headers(.headers = c("Authorization" =  glue("Bearer {apikey}"),
                             "content-type" = "text/csv")),
    body = 'country;Share of population that lives in the capital;in other urban areas;in rural areas
Iceland (Reykjavík);56.02;38;6
Argentina (Buenos Aires);34.95;56.6;8.4
Japan (Tokyo);29.52;63.5;7
UK (London);22.7;59.6;17.7
Denmark (Copenhagen);22.16;65.3;12.5
France (Paris);16.77;62.5;20.7
Russia (Moscow);8.39;65.5;26.1
Niger (Niamey);5.53;12.9;81.5
Germany (Berlin);4.35;70.7;24.9
India (Delhi);1.93;30.4;67.6
USA (Washington, D.C.);1.54;79.9;18.6
China (Beijing);1.4;53;45.6')

# check with GET
GET(created_chart_url,
    add_headers(.headers = c("Authorization" =  glue("Bearer {apikey}"))))

chart_settings_url <- glue("https://api.datawrapper.de/v3/charts/{chart_id}")

r_chart_settings <- GET(chart_settings_url,
                        add_headers(.headers = c("Authorization" =  glue("Bearer {apikey}"))))

w <- r_chart_settings %>% 
  content(as = "text") %>% 
  fromJSON() %>%
  unlist() %>% 
  enframe() %>% 
  flatten()
  view()
