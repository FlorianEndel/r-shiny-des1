
library(shiny)
library(simmer)
library(magrittr)
library(parallel)


shinyServer(function(input, output) {

	des_single <- eventReactive(input$button_single, {
		## model pathway/trajectory through hospital
		t0 <- create_trajectory("hospital") %>%

		  ## add an intake activity
		  seize("nurse", 1) %>%
		  timeout(function() abs(rnorm(1, 15))) %>%
		  release("nurse", 1) %>%

		  ## add a consultation activity
		  seize("doctor", 1) %>%
		  timeout(function() abs(rnorm(1, 20))) %>%
		  release("doctor", 1) %>%

		  ## add a planning activity
		  seize("administration", 1) %>%
		  timeout(function() abs(rnorm(1, 5))) %>%
		  release("administration", 1)


		envs <- mclapply(1:isolate(input$iterations), function(i) {
		  simmer("HospitalDES") %>%
				## create environment and assign resouces by quantity
		    add_resource("nurse", isolate(input$nurse)) %>%
		    add_resource("doctor", isolate(input$doctor)) %>%
		    add_resource("administration", isolate(input$administration)) %>%

				## add generator for events (patients) with an tracetory
		    add_generator("patient", t0,
		    							function() abs(rnorm(1, isolate(input$patients_time_mean),
		    																	 isolate(input$patients_time_sd)))
		    ) %>%

		    run(isolate(input$steps)*60) %>%
		    wrap()
		}, mc.cores=isolate(input$cores))

		return(envs)

	})

  output$resource_utilization <- renderPlot({
  	validate(
      need(des_single(), 'Run simulation to get output!')
    )
  	envs <- des_single()
		plot_resource_utilization(envs, c("nurse", "doctor","administration"))
  })

  output$resource_usage <- renderPlot({
  	envs <- des_single()
		plot_resource_usage(envs, input$resource_usage, items="server",
												steps=input$resource_usage_steps)
  })

  output$evolution_arrival_times <- renderPlot({
  	envs <- des_single()
		plot_evolution_arrival_times(envs, type = input$evolution_arrival_times)
  })



})
