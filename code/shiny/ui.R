library(shiny)
library(bslib)
library(bsicons)
library(shinyjs)
library(shinybrowser)

# Define UI for application
ui <- fluidPage(
  useShinyjs(),
  
  tags$head(
    tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.7/MathJax.js?config=TeX-AMS-MML_HTMLorMML")
  ),
  
  theme = bs_theme(
    bootswatch = "morph",
    base_font = font_google("Noto Serif"),
    navbar_bg = "#44ABE6"
  ),
  
  br(),
  
  div(
    style = "text-align: center; font-weight: bold; ",
    titlePanel("Body Fat Percentage Prediction")
  ),
  
  br(),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("unit_weight","Unit of Weight:",
                  choices = c("lbs","kg"), selected = "lbs"),
      numericInput("weight", "Weight:", value = 67, min = 40, max = 100), 
      numericInput("abdomen", "Abdomen Circumference (cm):", value = 85, min = 50, max = 150),
      div(
        style = "text-align: center;",
        actionButton("predict", "Predict Body Fat",icon = icon("calculator"), )
      ),
      div(
        style = "text-align: left; color: grey; line-height: 1.4;margin-top: 30px;",  # Adjust line-height for spacing, left align the text
        HTML("<strong>How to measure Abdomen Circumference:</strong> Men measure the waist horizontally around the navel. 
        And for reliable results, the belly should not be pulled inward.")
      )
      
    ),
    
    
    
    mainPanel(
      
      # Body Fat picture
      div(
        style = "align:center; width: 100%;",
        imageOutput("Image2")
      ),
      
      div(
        uiOutput("indicator"), 
        style = "font-size: 24px; font-weight: bold; margin-top: 20px"
      ),
      
      div(
        uiOutput("prediction"), 
        style = "font-size: 24px; font-weight: bold; margin-top: 40px"
      ),
      
      #Show tips
      div(
        textOutput("tips"),
        style = "align:right; font-size: 24px; margin-top: 20px;"
      ),
      
    )
  ),
  
  # Below sidebar
  div(
    style = "display: flex; width: 80%; align-items: center; margin-top: 20px;",
    id = "pictures",
    imageOutput("Image3", inline = TRUE),
    imageOutput("Image4", inline = TRUE),
    imageOutput("Image5", inline = TRUE),
    imageOutput("Image6", inline = TRUE)
  ),
  
  div(
    style = "text-align: center; margin-top:40px; margin-left:40px; margin-right:40px; font-weight: bold; color:black;",
    h3("The model used in this Body Fat Calculator"),
    div(
      style = "text-align:left; margin-top:20px;",
      HTML("<p> We established a linear regression model using weight and abdomen as predictors to forecast body fat. 
         After testing the model and conducting statistical analysis on the prediction results, 
         we believe that our model as below can accurately and robustly predict male body fat based on the data from weight and abdomen.
         And the density is calculated by \"Siri's equation\" ( Katch and McArdle(1977), p. 111).
         ")
    ),
    div(
      style = "text-align: center; font-size: 20px; font-weight: normal; color: black;",
      id = "formula",
      HTML("
            <p>\\(\\text{BODYFAT(%)} = -41.547 - 0.124 \\times \\text{WEIGHT (lbs)} + 0.894 \\times \\text{ABDOMEN (cm)}\\)</p>
            <p>\\(\\text{DENSITY (gm/cm}^3\\text{)} = \\frac{495}{\\text{BODYFAT} + 450}\\)</p>
          ")
    ),
    div(
      style = "text-align: center; margin-left:-20px; font-size: 12px; font-weight: normal; color: black; visibility = hidden",
      id = "formula2",
      HTML("
             <p>\\[ \\begin{aligned}
                    \\text{BODYFAT(%)} & = -41.547 - 0.124 \\times \\text{WEIGHT (lbs)} \\\\
                                          & + 0.894 \\times \\text{ABDOMEN (cm)} 
                    \\end{aligned}\\\\
                    \\text{DENSITY (gm/cm}^3\\text{)}  = \\frac{495}{\\text{BODYFAT} + 450}
                    \\]</p>
          ")
    ),
    
    div(
      style = "text-align:left; margin-top:20px;",
      HTML("<p> This means that for every centimeter increase in abdomen, 
      the model predicts that the body fat will increase 0.894%. 
      And for every pound increase in weight, the model predicts that the body fat will decrease 0.124%. 
      The second interpretation may seem weird, but it's actually reasonable, 
      for the increase of weight will lead to the increase of abdomen, 
      contributing to the increase of body fat ultimately.
         ")
    ),
    
  ),
  
  
  # Badger picture!
  div(
    style = "text-align: center; width: 100%; margin-top: 30px; position: relative; font-size: 12px;",
    imageOutput("Image1")         # Display the image
  ),
  
  div(
    style = "text-align: center; margin-top: -30px; font-size: 12px;",
    HTML("<p><b>Contact Info: </b><u>rma235@wisc.edu</u>
          <p><b>Contributor:</b> Yuchen Xu, Mario Ma, Yiteng Tu, Yudi Wang")
  ),
  
  nav_panel(title = "App with navbar", 
            id = "page", 
            position = "fixed-bottom" ),
  
  # Adapt to mobile users
  tags$head(tags$script('
                        var width = 0;
                        $(document).on("shiny:connected", function(e) {
                          width = window.innerWidth;
                          Shiny.onInputChange("width", width);
                        });
                        $(window).resize(function(e) {
                          width = window.innerWidth;
                          Shiny.onInputChange("width", width);
                        });
                        '))
  
)
