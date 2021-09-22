source("00_setup.R")
#https://developer.datawrapper.de/docs/creating-a-locator-map
map_url <- "https://api.datawrapper.de/v3/charts"

# r_map <- POST(map_url, headers_auth, headers_content,
#               body = list(
#                 title = "My Locator Map",
#                 type = "locator-map"
#               ),
#               encode = "json")
# 
# (map_id <- r_map %>% get_id())
map_id <- "9AGV0"
# send the specs for the map to the created object
# they are in a json file
created_map_url <- glue("{map_url}/{map_id}")

PATCH(created_map_url,
      headers_auth, headers_content,
      body = '{ 
    "metadata": {
            "data": {
                "json": true
        },
        "visualize": {          
            "view": {
                "center": [ -2.59686, 51.455 ],
                "zoom": 2,
                 "fit": {
                    "top": [-2.6, 51.51],
                    "right": [-2.5, 51.47],
                    "bottom": [-2.58, 51.40],
                    "left": [-2.65, 51.469]
                },
                "height": 120,
                "pitch": 0,
                "bearing": 0
            },
            
            "style": "dw-light",

            "defaultMapSize": 500,
            
            "visibility": {
                "boundary_country": true,
                "boundary_state": true,
                "building": true,
                "green": true,
                "mountains": false,
                "roads": true,
                "urban": true,
                "water": true,
                "building3d": false
            },

            "mapLabel": true,
            "scale": false,
            "compass": true,

            "miniMap": {
                "enabled": false,
                "bounds": []
            },
            "key": {
                "enabled": false,
                "title": "",
                "items": []
            }
        }
     }
  }',
  encode = "json")
# OR using file
PATCH(created_map_url,
      headers_auth, headers_content,
      body = upload_file(path = "data/map.json"))

# check

r_map_patched <- GET(created_map_url, headers_auth)

r_map_patched %>% 
  response_as_tbl() %>% view()

# to get the "path" for the SVG icon so you can define it elsewhere
path_icon <- r_map_patched %>% 
  content(as = "text") %>%
  fromJSON() %>% 
  pluck("metadata", "visualize", "key", "items", "icon") %>%
  # icon is a df
  filter(id == "locator") %>% 
  pull(path)


# publish

map_pub_url <- glue("{created_map_url}/publish")
POST(map_pub_url, headers_auth)

# look at the data

map_data_url <- glue("{created_map_url}/data")

r_map_data <- GET(map_data_url,
                  headers_auth, headers_content)

# PUT new markers

# PUT(map_data_url, headers_auth,
#     body = upload_file("data/markers.json"))

r_map_data %>% 
  response_as_tbl() %>% 
  filter(str_detect(name, "markers.icon|markers.title")) %>% 
  # mutate(id = str_sub(name, start = -1L, end = -1L)) %>% 
  separate(col = name, into = c("marker", "type", "id"), extra = "drop") %>% 
  select(-marker) %>% 
 write_csv2(file = "data/icon_svg_paths.csv")


%>% 
  pivot_wider( names_from = id, values_from = value) %>% 
  mutate(icon_data = coalesce(`1`, `2`, `3`, `4`, `5`, `6`))

%>% 
   %>% 
  set_names(nm = janitor::make_clean_names(names(.))) %>% 
  coalesce(x1, x2, x3, x4, x5, x6)


