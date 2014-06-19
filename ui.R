# Coursera. Developing Data Products.
#
library(shiny)

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("Webpage Analyser"),

  sidebarPanel(
    # Display input widgets
    textInput("url","Enter web address and press Submit button.","http://news.yahoo.com/"),
    submitButton('Submit'),
    h5("Application Description"),
    p("This application loads web page content from address you entered above. 
      Then it parses HTML content to extract words and build table of word's frequencies. 
      The result presented on the graphic that shows dependency of word's frequency from logarithm of word's rank. 
      Also presented table with 10 of the most frequent words on the page.")
    ),

  mainPanel(
    # Display output
    h5("Dependency of word counts from logarithm of words rank"),
    plotOutput("distPlot"),
    h5("Most frequent words on the page"),
    verbatimTextOutput("table")
    )
))
