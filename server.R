# Coursera. Developing Data Products.
#
library(XML)
library(ggplot2) 
library(scales)  

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
  # Load a and parse webpage using reactive function. 
  # Reactive function will cash the result so we can re-use.     
  getWords <- reactive({
    # Fetch html page using "readLines" and merge all strings to single text 
    web.content <- paste(readLines(input$url),"\n", collapse='')
    # Parse html     
    web.tree <- htmlTreeParse(web.content, asText=TRUE, useInternalNodes=T)
    # Extract text content     
    web.text <- paste(xpathSApply(web.tree, '//p', xmlValue),' ', collapse=' ')
    # Parse text content     
    web.words <- tolower(unlist(strsplit(web.text,"[ .,;!?\"\\[\\)\\(]")))
    # Build table with words frequencies in the text. Exclude words less than 2 character length.   
    web.words.table <- data.frame(table(web.words[nchar(web.words)>2]), stringsAsFactors=F)
    # Sort table by frequencies  
    web.words.table <- web.words.table[order(web.words.table$Freq, decreasing=T), ]
    # Add word's rank to the table
    web.words.table[,3] <- seq(nrow(web.words.table))
    # Change row and column names
    names(web.words.table) <- c("Word","Freq","Rank")
    rownames(web.words.table) <- NULL
    # By default function return the result of the last command 
    web.words.table
  })
  # Output plot and table
  output$table <- renderPrint({print(getWords()[1:10, c(1, 2)])})  
  output$distPlot <- renderPlot({
    print(ggplot(getWords(), aes(x=Rank, y=Freq)) +
      geom_point(size=3)+
      xlab("Rank") + ylab("Frequency") + 
      theme_bw() + 
      scale_x_log10(breaks = trans_breaks('log10', function(x) 10^x),
                    labels = trans_format('log10', math_format(10^.x)))
    )
  })
  
})
