# This is the GUI part of the shiny script to plot
# graph for displaying presence of symptoms. 

# Define UI for displaying presence of symptoms
shinyUI(fluidPage(
  #theme="/bootstrap/spacelab_bootstrap.css",
  
  # Application title ####
  titlePanel("medplot"),
  
  # Layout of the GUI ####
  sidebarLayout(
    # Define the sidebar panel ####
    sidebarPanel(
      width=3,
      textOutput("medplotVersion"),
      uiOutput("messageSelectVars"),
      # greyed out panel
      wellPanel(
        conditionalPanel(
          condition="input.dataFileType =='Demo'",
          h4("Working with DEMO data")),
        
        # selection of type of data file
        selectInput(inputId="dataFileType",
                    label="Select type of data file:",
                    choices=c(
                      " "=NA,
                      "Excel template"="Excel",
                      "Tab separated values (TSV) file"="TSV",
                      "Demo data"="Demo"
                    )),
        
        # show file upload control if user selects she will upload a file
        conditionalPanel(
          condition="input.dataFileType =='Excel' || input.dataFileType =='TSV'",
          fileInput(inputId="dataFile",
                    label={h5("Upload data file:")},
                    multiple=FALSE,
                    accept=c("application/vnd.ms-excel",
                             "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                             "text/plain"))
        ),
        
        # selection of various variables needed in the analysis
        uiOutput("selectPatientIDVar"),
        
        uiOutput("selectDateVar"),
        
        uiOutput("selectMeasurementVar"),
        
        uiOutput("selectGroupingVar"),
        
        uiOutput("selectSymptoms"), # these are our outcome variables
        
        uiOutput("selectTreatasBinary"),
        
        uiOutput("selectThresholdValue")
      )
    ),
    
    # Define the main panel ####
    mainPanel(
      tabsetPanel(
        # TAB - welcome page with copyright info ####
        tabPanel(title="Welcome",
                 includeHTML("www/welcome.html")),
        
        # TAB - summary of data ####
        tabPanel(title="Data overview",
                 verbatimTextOutput("dataSummary")), 
        
        # TAB - Graphical exploration over time ####
        tabPanel(title="Graphical exploration",
                 uiOutput("selectGraphOverTime"),
                 
                 # Profile plots
                 uiOutput("selectGraphType"),
                 uiOutput("selectRandomSampleSize"),
                 uiOutput("selectMaxGroupSize"),
                 plotOutput("plotTimelineProfiles", height="auto"),
                 conditionalPanel(condition="input.selectedGraphOverTime=='profilePlot'",
                                  downloadButton("downLoadplotTimelineProfiles", label="Download")),
                 uiOutput("plotTimelineProfilesDescr"),
                 
                 # Lasagna plot
                 uiOutput("plotLasagna"),
                 conditionalPanel(condition="input.selectedGraphOverTime=='lasagnaPlot'",
                                  uiOutput("downloadLasagna")),
                 uiOutput("plotLasagnaDesc"),
                 
                 # Boxplots
                 uiOutput("selectFacetingType"),
                 plotOutput("plotTimelineBoxplots", height="auto"),
                 conditionalPanel(condition="input.selectedGraphOverTime=='boxPlot'",
                                  downloadButton("downLoadplotTimelineBoxplot", label="Download")),
                 uiOutput("plotTimelineBoxplotsDesc"),
                 
                 # Timeline graph
                 uiOutput("selectDisplayFormat"),
                 plotOutput("plotTimeline", height="auto"),
                 conditionalPanel(condition="input.selectedGraphOverTime=='timelinePlot'",
                                  downloadButton("downLoadplotTimeline", label="Download")),
                 uiOutput("plotTimelineDesc"),
                 
                 # Presence of symptoms graph
                 uiOutput("selectMeasurementForPresencePlot"),
                 plotOutput("plotProportion", height="auto"),
                 conditionalPanel(condition="input.selectedGraphOverTime=='presencePlot'",
                                  downloadButton("downLoadplotProportion", label="Download")),
                 uiOutput("plotProportionDesc")
        ),
        
        # TAB - Summary ####
        tabPanel(title="Summary",
                 plotOutput("plotPyramid", height="auto"),
                 conditionalPanel(condition="input.treatasBinary==true",
                                  downloadButton("downLoadplotPyramid", label="Download")),
                 uiOutput("selectEvaluationTime2"),
                 dataTableOutput("tableforBoxplots"),
                 dataTableOutput("tableforProportions"),
                 plotOutput("plotPresence", height="auto"),
                 conditionalPanel(condition="input.treatasBinary==true",
                                  downloadButton("downLoadplotPresence", label="Download")),
                 plotOutput("plotMedians", height="auto"),
                 conditionalPanel(condition="input.treatasBinary==false",
                                  downloadButton("downLoadplotMedians", label="Download")),
                 uiOutput("mediansDescr"),
                 uiOutput("proportionsDescr")
        ),
        
        # TAB - Summary tables : grouping variable ####
        tabPanel(title="Summary tables : grouping variable",
                 
                 plotOutput("plotPropCIs", height="auto"),
                 conditionalPanel(condition="input.treatasBinary==true",
                                  downloadButton("downLoadPropPositiveCI", label="Download")),
                 
                 uiOutput("UIpropTable"),
                 uiOutput("UIdoPvalueAdjustments"),
                 
                 dataTableOutput("tablePropGroups"),
                 uiOutput("textTablePropGroups"),
                 
                 dataTableOutput("tableMedianGroups"),
                 uiOutput("textTableMedianGroups")
        ),
        
        # TAB - Clustering ####
        tabPanel(title="Clustering",
                 uiOutput("clusteringUI"),
                 
                 plotOutput("plotClusterDendrogram", height="auto"),
                 downloadButton("downLoadplotClusterDendrogram", label="Download"),
                 uiOutput("dendrogramDescr"),
                 
                 plotOutput("plotClusterCorrelations", height="auto"),
                 downloadButton("downLoadplotClusterCorrelations", label="Download"),
                 uiOutput("correlationDescr"),
                 
                 uiOutput("selectClusterAnnotations"),
                 plotOutput("plotClusterHeatmap", height="auto"),
                 downloadButton("downLoadplotClusterHeatmap", label="Download"),
                 uiOutput("heatmapDescr")
                 
        ),
        
        # TAB - Regression model : one evaluation time ####
        tabPanel(title="Regression model : one evaluation time",
                 
                 uiOutput("selectEvaluationTime"),
                 uiOutput("selectCovariate"),
                 uiOutput("checkUseFirthCorrection"),
                 uiOutput("checkUseRCSModel"),
                 
                 # Graphs
                 # Logistic regression with Firth correction
                 plotOutput("plotLogistf", height="auto"),
                 uiOutput("logistfRegDownload"),
                 dataTableOutput("tableLogistf"),
                 dataTableOutput("tableLogistfIntercept"),
                 uiOutput("logistfDescr"),
                 
                 # Logistic regression 
                 plotOutput("plotLogist", height="auto"),
                 uiOutput("logistRegDownload"),
                 dataTableOutput("tableLogist"),
                 dataTableOutput("tableLogistIntercept"),
                 uiOutput("logistDescr"),
                 
                 # Linear regression
                 plotOutput("plotLinear", height="auto"),
                 uiOutput("linearRegDownload"),
                 dataTableOutput("tableLinear"),
                 dataTableOutput("tableLinearIntercept"),
                 uiOutput("linearDescr"),
                 
                 # RCS regression
                 plotOutput("plotRCS", height="100%"),
                 uiOutput("RCSRegDownload"),
                 dataTableOutput("tableRCS"),
                 uiOutput("RCSDescr")
        ),
        
        # TAB - Regression model : all evaluation times ####
        tabPanel(title="Regression model : all evaluation times",
                 uiOutput("selectCovariate1st"),
                 uiOutput("selectMixedModelType"),
                 textOutput("mixedModelTable0Caption"),
                 dataTableOutput("mixedModelTable0"),
                 textOutput("mixedModelTable1Caption"),
                 dataTableOutput("mixedModelTable1"),
                 plotOutput("mixedModelGraph1", height="auto"),
                 uiOutput("graph1Download"),
                 textOutput("mixedModelTable2Caption"),
                 dataTableOutput("mixedModelTable2"),
                 plotOutput("mixedModelGraph2", height="auto"),
                 uiOutput("graph2Download"),
                 textOutput("mixedModelTable3Caption"),               
                 dataTableOutput("mixedModelTable3"),
                 plotOutput("mixedModelGraph3", height="auto"),
                 uiOutput("graph3Download"),
                 uiOutput("regressionAllDescr")
        ),
        
        # TAB - Selected data ####
        tabPanel(title="Uploaded data", 
                 dataTableOutput("data")),
        
        # TAB - Debug ####
        tabPanel("Selected variables",
                 verbatimTextOutput("selectedVariables"),
                 textOutput("debug"))
        )
    )
  )
)
)