###### Stonks Team - Enzo, Mariah, Raul ##############



#################### GLobal Variables ##################

money <- 50000

ticker_big <- "REV"

price_we_bought <- Inf 

current_price <- Inf

transactions <- 0

big_token <- "0bc28c33-8e8d-11eb-adad-da11bc1fe3d8"

getting_data_cycles <- 0 

###################### The algo ########################


repeat{
  
  if(price_we_bought != Inf){
    
    getting_data_cycles <- getting_data_cycles + 1
    
  }
  
  old_price <- current_price
  
  cat("Getting data", "\n")
  
  hot <-fromJSON("https://api.tiingo.com/tiingo/crypto/top?tickers=revusd&token=3c0aef2d84350cebf792c29fa361a5b5539059e6")
  
  data <- hot$topOfBookData
  
  current_price <- data[[1]]$lastPrice
  
  if(price_we_bought == Inf){  
    
    # buy
    
    cat("Buying", "\n")
    
    quantity <- money%/%current_price
    
    
    receipt <- fromJSON(paste("https://bigdataforall.com/crypto/?key=",
                              big_token,
                              "&request=buy&symbol=REV&quantity=",
                              quantity, sep = ""))
    
    price_we_bought <- receipt$price
    
    
    getting_data_cycles <- 0
  }  
  
  
  if(price_we_bought != Inf & price_we_bought <= current_price){
    
    if(current_price/price_we_bought >= 0.9998 | getting_data_cycles > 5){
      
      #sell with no profit
      
      cat("Selling (loss)", "\n")
      
      receipt <- fromJSON(paste("https://bigdataforall.com/crypto/?key=",
                                big_token,
                                "&request=sell&symbol=REV&quantity=",
                                quantity, sep = ""))
      
      
      transactions <- transactions + 2
      
      money <- receipt$cash/2
      
      price_we_bought <- Inf 
      
      getting_data_cycles <- 0
    }
    
  }else if(price_we_bought != Inf & price_we_bought/current_price > 1.0001 & current_price < old_price){
    
    
    #sell with profit
    
    cat("Selling (profit)", "\n")
    
    receipt <- fromJSON(paste("https://bigdataforall.com/crypto/?key=",
                              big_token,
                              "&request=sell&symbol=REV&quantity=",
                              quantity, sep = ""))
    
    
    transactions <- transactions + 2
    
    money <- receipt$cash/2
    
    price_we_bought <- Inf 
    
    getting_data_cycles <- 0
    
    
    
  }
  
  if(transactions > 3){
    
    cat("waiting", "\n")
    
    Sys.sleep(75)
    
    transactions <- 0
    
    profile <- fromJSON(paste("https://bigdataforall.com/crypto/?key=",
                              big_token,
                              "&request=profile", 
                              sep = ""))
    
    money <- profile$cash/2
    
  }else{
    
    Sys.sleep(1)
    
  }  
  
}