# UI

ui <- fluidPage (theme = shinytheme ("readable"), navbarPage (title = "California Energy Resources",

                                    
                                    
                                    # Start of Generator Portfolios Tab Panel---------------------------
                                    
                                    tabPanel ("Electric Generator Portfolios", 
                                             fluidRow (
                                               column (2,
                                                      
                                                                            
   
                                                    
                                                    # Select MP name input - filters both the map and table in Generator Portfolios Tab
                                                    pickerInput (inputId  = "prime_energy",
                                                                 label    = "Select Primary Energy Type:",
                                                                 choices  = sort (unique (CA$Prime_Mover_Description)),
                                                                 options  = list (`actions-box` = TRUE), 
                                                                 multiple = TRUE),


                                                    
                                                    
                                                    
                                                    # Select Input for Unit Type Dependent on MP Selection
                                                    uiOutput ("capacity"),
                                                    
                                                    
                                                    # Output for Resource selection - 
                                                    # used only when an MP is selected updates both Map and Parameters Table
                                                    uiOutput  ("resource")
                                                    
                                                    
                                             ),
                                             
                                             column (10,
                                                    
                                                    # Output for first panel loads the Generator Map
                                                    textOutput ('gen_map_title'), 
                                                    
                                                    tags$head (tags$style ("#gen_map_title{color:#302a29; 
               font-size: 30px; font-style: bold;}")),
                                                    
                                                    # Load the leaflet map 
                                                    withSpinner (leafletOutput ("gen_map", 
                                                                                width  = 1400,
                                                                                height = 700),
                                                                                type   = 1, 
                                                                                color  = "#0275D8", 
                                                                                size   = 1),
                                                    fluidRow (textOutput ('gen_help_text_1'), tags$head (tags$style ("#gen_help_text_1{color: #000000;
            font-size: 16px}"))),  

                                                    

                                                    
                                                    DT::dataTableOutput ("gen_map_table", 
                                                                         width = 1400)    
                                                    
                                                    
                                             )
                                             
                                           )
                                           
                                  ),
                                                          
                                                          
                                  #----------------------------------------
                                    
     
                                    navbarMenu ("More",
                                               tabPanel ("Data Dictionary"),
                                               tabPanel ("Help"))
            
                                    )
                                    )
            



