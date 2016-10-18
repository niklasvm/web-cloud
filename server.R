library(shiny)
library(rvest)
library(dplyr)
library(tm)
library(text2vec)
library(tagcloud)

shinyServer(function(input, output) {

  # text import
  web_results <- eventReactive(input$button_scrape,{
    page <- read_html(input$input_url)
    
    css <- input$input_css
    if (css!='') {
      text <- page %>% 
        html_nodes(css) %>% 
        html_text()
    } else {
      text <- page %>% 
        html_text()
    }
    return(text)
  })
  
  output$scrape_results <- renderText({
    text <- web_results()
    return(
      paste0(length(text),' element(s) downloaded')
    )
  })
  
  # text analysis
  text_results <- reactive({
    text <- web_results()
    
    prep_fun = tolower
    tok_fun = word_tokenizer
    it = itoken(text,preprocessor=prep_fun,tokenizer = tok_fun)
    
    sw <- stopwords()
    vocab = create_vocabulary(it, ngram = c(input$input_min_ngram, input$input_ngram),stopwords = sw,sep_ngram = ' ')
    pruned_vocab = prune_vocabulary(vocabulary = vocab, term_count_min = input$input_minwords)
    
    vectorizer = vocab_vectorizer(pruned_vocab)
    dtm = create_dtm(it, vectorizer)
    
    
    return(dtm)
  })
  
  output$analysis_results <- renderText({
    dtm <- text_results()
    freq <- sort(apply(dtm,2,sum))
    return(paste0(length(freq),' ngram(s) created'))
  })
  
  output$wordcloud <- renderPlot({
    dtm <- text_results()
    freq <- sort(apply(dtm,2,sum))
    tagcloud(tags = names(freq),weights = freq,fvert = 0.3)
  })

})
