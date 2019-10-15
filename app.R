
require(shinydashboard)
require(plotly)
require(ggplot2)
require(dplyr)
require(shinyBS)
require(networkD3)
require(data.table)
require(readxl)
require(shinyFiles)
require(scales)
require(ggmosaic)
require(rpivotTable)
require(plyr)
require(dplyr)
require(shinyjqui)

options(shiny.maxRequestSize = 1000*1024^2)

shinyApp(
  ui = fluidPage(
    dashboardPage(
      dashboardHeader(title = "Vowel Plot",
                      dropdownMenu(type = "messages", icon = icon('info-circle', 'fa-2x'), badgeStatus = "warning", headerText = 'App Info',
                                   messageItem(
                                     from = "Simon Gonzalez",
                                     message = "Author (Link)",
                                     href = 'https://www.visualcv.com/simongonzalez'
                                   ),
                                   messageItem(
                                     from = "Sydney Speaks",
                                     message = "Project (Link)",
                                     icon = icon("commenting"),
                                     href = 'http://www.dynamicsoflanguage.edu.au/sydney-speaks/'
                                   ),
                                   messageItem(
                                     from = "CoEDL (Link)",
                                     message = "ARC CoE for the Dynamics of Language",
                                     icon = icon("bookmark"),
                                     href = 'http://www.dynamicsoflanguage.edu.au/'
                                   )
                      )
      ),
      dashboardSidebar(
        
        tags$head(    
          tags$style("label {display:inline;}")
        ),
        fileInput('files', 'Choose File',
                  accept=c('text/csv/xlsx',
                           'text/comma-separated-values,text/plain',
                           c('.csv', '.xlsx'))),
        
        uiOutput('selectLabels_ui'),
        
        lapply(1:20, function(i) {
          uiOutput(paste0('filter', i))
        }),
        
        uiOutput('plotType_ui'),
        uiOutput('xlims_ui'),
        uiOutput('ylims_ui')
      ),
      dashboardBody(
        
        fluidRow(
          column(3,
                 uiOutput('f1_ui')
          ),
          column(3,
                 uiOutput('f2_ui')
          ),
          column(3, offset = 1,
                 hr()
          )
        ),
        
        fluidRow(
          tabBox(
            title = "Plots", width = 100,
            # The id lets us use input$tabset1 on the server to find the current tab
            id = "tabset1",
            tabPanel("Plot", 
                     jqui_resizable(plotOutput('plot')),
                     uiOutput('inverse_axes_ui'),
                     fluidRow(
                       column(4,
                              uiOutput('select_colour_ui')
                       ),
                       column(4, 
                              uiOutput('select_facet_ui')
                       )
                     ))
            
          )
        ),
        fluidRow(
          
          bsCollapse(id = "showdata", multiple = T, open = "Data Summary",
                     bsCollapsePanel("Data Summary", 
                                     DT::dataTableOutput('dataSummary'),
                                     style = "info"),
                     bsCollapsePanel("Numeric Data", 
                                     DT::dataTableOutput('numeric_summary'),
                                     style = "success"),
                     bsCollapsePanel("Categorical Data", 
                                     DT::dataTableOutput('categorical_summary'),
                                     style = "success"),
                     bsCollapsePanel("Plot Data", 
                                     DT::dataTableOutput('plotData'),
                                     style = "success"))
          
        )
      )
    )
  ), 
  server = function(input, output, session) {
    
    column_vals = reactiveValues(v=NULL)
    subset_vals = reactiveValues(v=NULL)
    
    source('./functions/summarise_data.R')
    
    shinyFileChoose(input,'files', session=session,roots=c(wd='.'))
    
    #shinyFileChoose(input, 'files', root=c(root='.'), filetypes=c('', 'csv', 'xlsx'))
    
    source(file.path("server", "server_data_in.R"),  local = TRUE)$value
    source(file.path("server", "server_selectLabels.R"),  local = TRUE)$value
    source(file.path("server", "server_createLabels.R"),  local = TRUE)$value
    source(file.path("server", "server_inputTypes.R"),  local = TRUE)$value
    source(file.path("server", "server_extraSettings.R"),  local = TRUE)$value
    source(file.path("server", "server_numericPlotTypes.R"),  local = TRUE)$value
    source(file.path("server", "server_categoricalPlotTypes.R"),  local = TRUE)$value
    source(file.path("server", "server_mainPlot.R"),  local = TRUE)$value
    source(file.path("server", "server_inverseAxes.R"),  local = TRUE)$value
    source(file.path("server", "server_proportions.R"),  local = TRUE)$value
    source(file.path("server", "server_plotBars.R"),  local = TRUE)$value
    source(file.path("server", "server_dataOutput.R"),  local = TRUE)$value
    source(file.path("server", "server_sankeyPlot.R"),  local = TRUE)$value
    source(file.path("server", "server_addColumns.R"),  local = TRUE)$value
    source(file.path("server", "server_pivotOutput.R"),  local = TRUE)$value
    
    source(file.path("server", "server_f1.R"),  local = TRUE)$value
    source(file.path("server", "server_f2.R"),  local = TRUE)$value
    source(file.path("server", "server_plotType.R"),  local = TRUE)$value
    source(file.path("server", "server_xlims.R"),  local = TRUE)$value
    source(file.path("server", "server_ylims.R"),  local = TRUE)$value
    
  }
)