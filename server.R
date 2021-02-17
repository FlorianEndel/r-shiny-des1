
library(shiny)
library(shinyalert)

library(simmer)
library(simmer.plot)
library(magrittr)
library(parallel)


shinyServer(function(input, output, session) {

	des_single <- eventReactive(input$button_single, {

		print('ping')

		## model pathway/trajectory through hospital
		t0 <- trajectory("hospital") %>%

		  ## add an intake activity
		  seize("nurse", 1) %>%
		  timeout(function() abs(rnorm(1, mean = isolate(input$nurse_mean), sd = isolate(input$nurse_sd)))) %>%
		  release("nurse", 1) %>%

		  ## add a consultation activity
		  seize("doctor", 1) %>%
		  timeout(function() abs(rnorm(1, mean = isolate(input$doc_mean), sd = isolate(input$doc_sd)))) %>%
		  release("doctor", 1) %>%

		  ## add a planning activity
		  seize("administration", 1) %>%
		  timeout(function() abs(rnorm(1, mean = isolate(input$admin_mean), sd = isolate(input$admin_sd)))) %>%
		  release("administration", 1)


		print('ping')
		waiter_show( # show the waiter
			html = spin_fading_circles() # use a spinner
		)


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


		waiter_hide() # hide the waiter

		return(list(envs = envs, t0 = t0))

	})


	observeEvent(des_single(), {
		# Show a modal when the button is pressed
		shinyalert("Simulation finished", type = "success")
	})


  output$resource_utilization <- renderPlot({
  # 	validate(
  #     need(des_single(), 'Run simulation to get output!')
  #   )
  	envs <- des_single()$envs
  	resources <- get_mon_resources(envs)
  	plot(resources, metric="utilization", c("nurse", "doctor", "administration")) +
  		theme_bw(base_size = 18)
		#plot_resource_utilization(envs, c("nurse", "doctor","administration"))
  })

  output$resource_usage <- renderPlot({
  	envs <- des_single()$envs
  	resources <- get_mon_resources(envs)
		#plot_resource_usage(envs, input$resource_usage, items="server",
		#										steps=input$resource_usage_steps)
		plot(resources, metric="usage", input$resource_usage, items="server",
				 steps=input$resource_usage_steps) +
			theme_bw(base_size = 18)
  })

  output$evolution_arrival_times <- renderPlot({
  	envs <- des_single()$envs
  	arrivals <- get_mon_arrivals(envs)
		plot(arrivals, metric = input$evolution_arrival_times) +
			theme_bw(base_size = 18)

		#get_palette <- scales::brewer_pal(type = "qual", palette = 1)
		#plot(des_single()$t0, fill = get_palette)

  })



})
