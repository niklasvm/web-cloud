
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
  titlePanel("Web Cloud"),
  
  sidebarLayout(
    sidebarPanel(
      h3('Text import'),
      textInput(inputId='input_url',label='Enter url:',value = 'http://www.ted.com/talks/sam_harris_can_we_build_ai_without_losing_control_over_it/transcript?language=en'),
      textInput(inputId='input_css',label='CSS selector:',value='.talk-transcript__para__text'),
      actionButton(inputId='button_scrape',label = 'Scrape Web Page'),
      textOutput('scrape_results'),
      
      h3('Text analysis'),
      numericInput('input_min_ngram','Min Ngrams:',value=1,min=1),
      numericInput('input_ngram','Max Ngrams:',value=3,min=1),
      numericInput('input_minwords','Minimum frequency:',value=3,min=1),
      textOutput('analysis_results')
    ),
    mainPanel(
      shiny::plotOutput('wordcloud')
    )
  )
))
