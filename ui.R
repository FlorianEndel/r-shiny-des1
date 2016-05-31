
library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("DES: hospital queue"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
    	div(style="display:inline-block",
	      actionButton("button_single", "Run simulation"),
    		style="display:center-align"),
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
					h4('Patients'),
					sliderInput("patients_time_mean", "Mean time between patients:",
					            min = 1, max = 10, step=1,
					            value = 5, round=TRUE),
					sliderInput("patients_time_sd", "SD of time between patients:",
					            min = 1, max = 10, step=1,
					            value = 2, round=TRUE)
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
      plotOutput("resource_utilization"),
      plotOutput("resource_usage"),
      plotOutput("evolution_arrival_times")
    )
  )
))
