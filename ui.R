
library(shiny)
library(htmltools)

shinyUI(fluidPage(

  # Application title
  titlePanel("DES: hospital queue"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(

    	div(#style="display:inline-block",
	      actionButton("button_single", strong("Run simulation"), width = '90%', icon = icon('diagnoses')),
    		style="display:center-align", align = 'center'),
      br(),
    	tabsetPanel(
    		tabPanel("Resources",
    			h4('Stuff'),
					sliderInput("nurse", "Nurse(s):",
					            min = 1, max = 10, step=1,
					            value = 3, round=TRUE),
					sliderInput("doctor", "Doctor(s):",
					            min = 1, max = 10, step=1,
					            value = 4, round=TRUE),
					sliderInput("administration", "Administration:",
					            min = 1, max = 10, step=1,
					            value = 1, round=TRUE),
					hr(),

					h4('Patients'),
					sliderInput("patients_time_mean", "Mean time between patients:",
					            min = 1, max = 10, step=1,
					            value = 5, round=TRUE),
					sliderInput("patients_time_sd", "SD of time between patients:",
					            min = 1, max = 10, step=1,
					            value = 2, round=TRUE)
    		),
				tabPanel("Trajectory",
								 h4('Nurse consultation'),
								 sliderInput("nurse_mean", "Mean in minutes:",
								 						min = 1, max = 30, step = 5,
								 						value = 15, round = TRUE),
								 sliderInput("nurse_sd", "Standard Deviation in minutes:",
								 						min = 0, max = 10, step = 1,
								 						value = 1, round = TRUE),
								 hr(),
								 h4('Doctor'),
								 sliderInput("doc_mean", "Mean in minutes:",
								 						min = 1, max = 60, step = 5,
								 						value = 20, round=TRUE),
								 sliderInput("doc_sd", "Standard Deviation in minutes:",
								 						min = 0, max = 10, step = 1,
								 						value = 1, round = TRUE),
								 hr(),
								 h4('Administration'),
								 sliderInput("admin_mean", "Mean in minutes:",
								 						min = 1, max = 30, step = 1,
								 						value = 5, round=TRUE),
								 sliderInput("admin_sd", "Standard Deviation in minutes:",
								 						min = 0, max = 10, step = 1,
								 						value = 1, round = TRUE),

				),
    		tabPanel("Runtime",
    			h4('Environment'),
					sliderInput("steps",
					            "Simulation steps (hours * 60):",
					            min = 1, max = 8, step=1,
					            value = 8, round=TRUE),
		      sliderInput("iterations",
		                  "number of simulation runs:",
		                  min = 1, max = 180, step=10,
		                  value = 30, round=TRUE),
		      sliderInput("cores",
		                  "number of parallel processes:",
		                  min = 1, max = 4, step=1,
		                  value = 3, round=TRUE)
    		),
    		tabPanel("Plot",
    			h4("Resource usage"),
  				selectInput('resource_usage',
      						'Show resource usage for:',
      						c('Nurse(s)' = 'nurse',
      							'Doctor(s)' = 'doctor',
      							'Administration' = 'administration')
		      ),
		      checkboxInput('resource_usage_steps', 'show steps in resource usage', value=FALSE),
		      hr(),
  				h4("Evolution of arrival times"),
		      selectInput('evolution_arrival_times',
		      						'Show evolution of arrival times for:',
		      						c('Waiting time' = 'waiting_time',
		      							'Activity time' = 'activity_time',
		      							'Flow time' = 'flow_time')
		      )
    		)
    	)
    ),

    # Show a plot of the generated distribution
    mainPanel(
    	tabsetPanel(
    		tabPanel("Outline", img(src = 'fig/Trajectory_annotated.png', align = "center", height = '750px')),
    		tabPanel("Utilization", plotOutput("resource_utilization", height = '600px')),
    		tabPanel("Usage", plotOutput("resource_usage", height = '600px')),
    		tabPanel("Patients", plotOutput("evolution_arrival_times", height = '600px'))
    	)

    )
  )
))
