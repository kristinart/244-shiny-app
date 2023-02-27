
# This is a Shiny web application. You can run the application by clicking the 'Run App' button above.

library(shiny)
library(tidyverse)
library(here)
library(shinythemes)
library(bslib)

data <- read_csv(here('data','df_final.csv'))

# ui <- fluidPage(
#   theme = bs_theme(
#     version = 5,
#     bootswatch = NULL,
#     bg = "white",
#     fg = "black",
#     primary = "purple",
#     secondary = "turquoise",
#     success = "green",
#     info = "dodgerblue",
#     warning = "yellow",
#     danger = "red",
#     base_font = font_google("Merriweather"),
#     code_font = font_google("Asar"),
#     heading_font = font_google("Gravitas One"),
#     font_scale = 1
#   ), ### end of theme

ui <- navbarPage(title = "Brittlebush Productivity and Arthropod Community Characteristics",
                 tabPanel(title = "Background",
                 fluidPage(
                   titlePanel("Introduction and Background"),
                   img(src ="https://www.researchgate.net/profile/Christofer-Bang/publication/225081502/figure/fig2/AS:669081560707081@1536532883563/Map-of-the-Phoenix-metropolitan-area-with-approximate-location-of-the-two-weather.ppm"),
                   p("This study examined the species abundance, richness, and evenness of arthropods, and the plant productivity of brittlebush, in response to different habitats and treatment conditions. The purpose of the study was to better understand any potential impact of different habitat types and growing conditions on urban biodiversity."),
                   sidebarLayout(
                     sidebarPanel(
                       (radioButtons("habitat_type",
                                     label = "Choose habitat type",
                                     choices = c("Desert", "Remnant", "Urban"))
                       ) #end of radio buttons
                     ), #end of sidebar panel
                     mainPanel("output: summary map with sites of that habitat type highlighted/ selected and a short ~2-sentence summary blurb of what that habitat type refers to.",
                               plotOutput(outputId = "habitat_plot")
                               ) #end of main panel
                 ) #end of sidebar layout
                 ) #end of fluid page
                 ), #end of tab 1

                 tabPanel("Brittlebush",
                 fluidPage(titlePanel("Brittlebush Productivity Under Varying Conditions"),
                          p("Insert blurb on productivity of the plants under the various treatments"),
                          sidebarLayout(
                            sidebarPanel(
                              checkboxGroupInput(inputId = "water",
                                                 label = "Water treatment",
                                                 choices = c("LOW" = "LOW", "MEDIUM" = "MEDIUM", "HIGH" = "HIGH")),
                              checkboxGroupInput(inputId = "cage",
                                                 label = "Cage treatment",
                                                 choices = c(1, 0))
                          ), # end sidebar panel
                          mainPanel("output: box and whisker plot of plant productivity under the chosen combination of treatment conditions")
                 ) #end of sidebar layout
                 ) #end of fluidpage
                 ), #end of tab 2

                 tabPanel(title = "Arthropods",
                          fluidPage(
                            titlePanel("Arthropod Community Characteristics Under Varying Conditions"),
                            p("Insert blurb on arthropod community response to brittlebush productivity under varying conditions"),
                            sidebarLayout(
                              sidebarPanel(
                                checkboxGroupInput(inputId = "treatment_id",
                                                   label = "Select cluster treatment",
                                                   choices = unique(data$treatment_id)
                                )
                              ), #end of sidebar panel
                              mainPanel("output: ")
                              ) #end of sidebar layour
                            ) #end of fluidpage
                 ) #end of tab 3
                 )#end of navbarPage

server <-function(input, output){
  #widget_habitat_type data
  habitat_select <- reactive({
    data %>%
      filter(habitat_type == input$habitat_type)
  })

  #widget_habitat_type plot
  output$habitat_plot <- renderPlot({
    ggplot(data = habitat_select(),
           aes(x = habitat_type,
               y = plant_dry_mass) +
             geom_point()
    )

  })
  # widget_treatment_type data
  treatment_select <- reactive({
    df_final %>%
      filter(treatment_id == input$treatment_id)
  })

  #widget_treatment_type plot
  output$treatment_plot <- renderPlot({
    ggplot(data = treatment_select(),
           aes(x = treatment_id,
               y = plant_dry_mass)) +
      geom_boxplot()

  })

}


shinyApp(ui = ui, server = server)
