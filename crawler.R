# get the sprites

library(rvest)
library(httr)

url <- "https://pokemondb.net/sprites"

imgsrc <- read_html(url) %>%
    html_nodes(xpath = "//div[@class='infocard-list infocard-list-pkmn-sm']/a/span") %>%
    html_attr('data-src')


timer0 <- Sys.time()
# set step to be 100
index <- 1
last_part <- length(imgsrc) %% 100 # which is 9
stop_index <- length(imgsrc) - last_part
while (index <= stop_index) {
    t0 <- Sys.time()
    download.file(paste0(imgsrc[index:(index+99)]),
                  destfile = basename(imgsrc[index:(index+99)]),
                  cacheOK = TRUE)
    t1 <- Sys.time()
    response_delay <- as.numeric(t1-t0)
    index <- index + 100
    Sys.sleep(0.5*response_delay)
}

# download the last batch
download.file(paste0(imgsrc[stop_index:length(imgsrc)]),
              destfile = basename(imgsrc[stop_index:length(imgsrc)]),
              cacheOK = TRUE)

timer1 <- Sys.time()
cat("Total time:", timer1-timer0, "seconds.\n")

# might take a while. also the scaped images tend to spread themselves inside the current directory. might want them to allocate in another separate directory in the end.

# the face recognition would be the hard part since images are two small with limited number of.
