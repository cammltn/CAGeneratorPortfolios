# Server

server <- function (input, output, session){
  
  # Start of Generator Portfolios Tab Filters ---------------------
  

   # Filters the table for MP after date has been selected
   type_filter <- reactive ({
     req (input$prime_energy)
     {
       (CA %>%
         filter (Prime_Mover_Description%in%input$prime_energy)
       )
        }
       
     
    }
   )
   
   
   
   # Resource selection output based on MP selection
   output$capacity <- renderUI ({
     
    sliderInput (
       inputId = "capacity_slider",
       label = "Select Unit Capacity Range:", 
       min = (min(type_filter()$Unit_MW)),
       max = (max(type_filter()$Unit_MW)),
       value = c(min(type_filter()$Unit_MW), max(type_filter()$Unit_MW))
    )

     
    }
  ) 
   
  # # Filter the table filtered for MP and unit typ to be used to filter the 
   capacity_filter <- reactive ({
     req ((input$prime_energy), (input$capacity_slider))
     {
       (CA %>%
         filter (Prime_Mover_Description%in%input$prime_energy &
                  Unit_MW >=  local (input$capacity_slider[1]) & Unit_MW <=  local (input$capacity_slider[2]))
       )
        }
       
    }
   )
   
   
  
  # # Resource selection output
   output$resource <- renderUI ({
     pickerInput (inputId = "resource_filter",
                 label = "Select Resource ID:",
                 choices = sort (unique (capacity_filter()$Resource_ID)),
                 options = list (
                   `actions-box` = TRUE), 
                 multiple = TRUE,
     )
     
    }
   )
   
   
   
  # # All filter applied to filter the Gen Map
   gen_filter_map <- reactive ({
     if (!isTruthy (input$prime_energy) & !isTruthy (input$capacity_slider) & !isTruthy (input$resource_filter))
     {
       
       (CA)
     }
     
     else if (isTruthy (input$prime_energy) & !isTruthy (input$capacity_slider) & !isTruthy (input$resource_filter))
       {
         (type_filter())
         
         }
        
     
     else if (!isTruthy (input$resource_filter))
       {
         (capacity_filter())
         
       } else {
         (capacity_filter() %>%
          filter (Resource_ID%in%input$resource_filter))
       }
       
     
    }
   )
   
   

  
  #----------------------------------------
  
  # All hard coded text outputs


  
  output$'gen_map_title' <- renderText ({
    paste ('Generators Portfolios')
    }
  )
  

  
  output$'gen_help_text_1' <- renderText ({
    paste ('Data from the California Energy Commission - last updated March 2, 2018')
    }
  )
  

  
  #----------------------------------------
  
  # param_table output
  
  # Load aggregated table based on daterange selection
  output$gen_map_table = DT::renderDataTable ({
    DT::datatable (gen_filter_map(), options = list (autoWidth = TRUE, pageLength = 5, scrollX = TRUE))
   }
  )
  
  
  #----------------------------------------  
  
  
  # Generator Map Output    
  output$gen_map <- renderLeaflet ({
    # Set color palette used for map legend to pal
    pal <- colorFactor (palette = "viridis", 
                       domain = c ((gen_filter_map()$Prime_Mover_Description),na.color = "#95A5A6"))
    # Assign color for values that are outside of the top 10 - grey
    
    # Start Leaflet web map
    map_generators <- leaflet() %>%  
      
      # Set base map styles - 3 to choose from
      addTiles (group = "OSM") %>% 

      
      
      
      
      # Add points for each resource using the data loaded from GEN_map_filters() -
      # set Lat/Lon points used, set a layer ID in case used for data layering in addLayerControl,
      # create popups for each point from data stored in the table, and set color palette for the nodes
      addCircleMarkers (data = gen_filter_map(), lng = ~X, lat = ~Y, radius = 5,  stroke = TRUE, group = "Generators",
                       
                       popup = paste (
                         "<b>Resource ID:</b>", gen_filter_map()$Resource_ID, "<br>",
                         "<b>Unit Type:</b>", gen_filter_map()$Prime_Mover_Description, "<br>",
                         "<b>Fuel Source:</b>", gen_filter_map()$Unit_MW, "<br>",
                         "<b>Unit Start Date:</b>", gen_filter_map()$Start_Date, "<br>",
                         "<b>Unit Retire Date:</b>", gen_filter_map()$Retire_Date, "<br>"),
                       
                       color = ~pal (Prime_Mover_Description)) %>%
      
      addGeoJSON (topodata, weight = 1, color = "#444444", fill = FALSE, group = "Tranmission Lines") %>%
    
      
      # Set layer groups - just layering basemaps here
      addLayersControl (baseGroups = c ("Generators","Transmission Lines")
      ) %>%
      
      # Add the legend from the query filter_top_mps() and set color palette as the one used for
      # circlemarker nodes - the legend with auto populate based on selected MPs
      addLegend ("bottomleft", pal = pal,
                values = gen_filter_map()$Prime_Mover_Description, 
                na.label = "Other",
                title = paste ("Primary Energy Type"),
                opacity = 1) %>%
      
      # Add a scale bar to bottom right
      addScaleBar (position = c ("bottomright")) %>%
      
      # Focus map view on California - central lat long point
      setView (lat = 37.3651, lng = -118.5383, zoom = 6)
    
    
    map_generators
   }
  )
  

  #----------------------------------------    
  
  # Add click to table function - 
  # clicking on a marker will highlight the corresponding row in the table
  observeEvent (input$gen_map_marker_click, { 
    map_click <- input$gen_map_marker_click
    output$gen_filter_map <- DT::renderDataTable ({
      DT::datatable (gen_filter_map()%>% 
                      filter (gen_filter_map()$Resource_ID == map_click$id))
     }
    )
    
    
   }
  ) 
}
  
  #----------------------------------------       
  

  
  