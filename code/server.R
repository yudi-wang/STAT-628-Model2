library(shiny)
library(bslib)
library(bsicons)
library(shinyjs)
library(shinybrowser)

# Define server
server <- function(input, output) {
  # Use our model's coefficients
  coefficients <- c(
    intercept = -41.547,
    WEIGHT = -0.124,
    ABDOMEN = 0.894
  )
  
  # Reactive expression to make prediction when the button is clicked
  observeEvent(input$predict, {
    weight <- input$weight
    abdomen <- input$abdomen
    
    # change unit
    if (input$unit_weight == "kg") {
      weight <- weight/0.45359237
    }
    
    # Apply model
    predicted_body_fat <- coefficients["intercept"] +
      coefficients["WEIGHT"] * weight +
      coefficients["ABDOMEN"] * abdomen
    
    # Body fat can't be less than 0. 
    if(predicted_body_fat < 0){
      predicted_body_fat <- 0
      predicted_density <- 0
    } else if(predicted_body_fat > 50){
      predicted_body_fat <- 0
      predicted_density <- 0
    } else{
      predicted_density <- 495/(predicted_body_fat+450)
    }
    
    # Find the position of indicator
  
    if(predicted_body_fat > 40){
      position <- 92
    } else if(predicted_body_fat < 0){
      position <- 37
    } else{
      position <- 37 + (predicted_body_fat / 40 * 55) # right position:92, with bodyfat = 40%
    }
  
    output$indicator <- renderUI({
      tagList(
        div(
          bsicons::bs_icon("hand-index-thumb", fill = "red", size = "24px"),
          style = paste0("position: absolute; top: 50%; left: ", 
                         position, "%; transform: translateY(-50%);
                         visibility: visible; margin-top: 50px;")
        )
      )
    })
    
    # Show the prediction and indicator
    output$prediction <- renderUI({
      tagList(
        layout_columns(
          style = "margin-top:-40px",
          value_box(
            title = "Body fat (%)",
            value = round(predicted_body_fat,2),
            showcase = bsicons::bs_icon("cake"),
            theme = "purple",
            class = "text-light"
          ),
          value_box(
            title = "Density (gm/cm^3)",
            value = round(predicted_density,2),
            showcase = bsicons::bs_icon("Droplet"),
            theme = "blue",
            class = "text-light"
          )
        )
      )
    })
    
    #show tips
    if(predicted_body_fat < 11 & predicted_body_fat > 0){
      output$tips <- renderText("You are too thin! It's time to eat something : ) ")
    } else if(predicted_body_fat >= 11 & predicted_body_fat < 15){
      output$tips <- renderText("You have a great body! Continue to maintain : ) ")
    } else if(predicted_body_fat >= 15 & predicted_body_fat < 25){
      output$tips <- renderText("You are a little overweight! Leave off with an appetie : ) ")
    } else if(predicted_body_fat >= 25){
      output$tips <- renderText("Take care of your health! Don't forget to work out today : ) ")
    } else if(predicted_body_fat == 0){
      output$tips <- renderText("It seems that you are not like a human. Please check your input : ) ")
    }
    
    
  })
  
  # Import the image
  output$Image1 <- renderImage({
    list(src = "www/1.png",
         contentType = "image/png",
         alt = "Badger",
         width = 280,
         height = 75)
  }, deleteFile = FALSE)
  
  output$Image2 <- renderImage({
    list(src = "www/2.png",
         contentType = "image/png",
         alt = "Body Fat Prediction Image",
         width = 900,
         height = 320,
         style = "margin-left: 40px;")
  }, deleteFile = FALSE)
  
  output$Image3 <- renderImage({
    list(src = "www/3.png",
         contentType = "image/png",
         alt = "picture3",
         width = 350,
         height = 250)
  }, deleteFile = FALSE)
  
  output$Image4 <- renderImage({
    list(src = "www/4.png",
         contentType = "image/png",
         alt = "picture4",
         width = 380,
         height = 250)
  }, deleteFile = FALSE)
  
  output$Image5 <- renderImage({
    list(src = "www/5.png",
         contentType = "image/png",
         alt = "picture5",
         width = 380,
         height = 250)
  }, deleteFile = FALSE)
  
  output$Image6 <- renderImage({
    list(src = "www/6.png",
         contentType = "image/png",
         alt = "picture6",
         width = 380,
         height = 250)
  }, deleteFile = FALSE)
 
  # Adapt to mobile users
  observe({
    req(input$width)
    if (input$width < 800) {
      hide("Image5")
      hide("Image2")
      hide("Image3")
      hide("Image4")
      hide("Image6")
      hide("indicator")
      hide('formula')
      show('formula2')
    } else {
      show("Image3")
      show("Image2")
      show("Image4")
      show("Image5")
      show("Image6")
      show("indicator")
      hide('formula2')
      show('formula')
    }
  })
  
}