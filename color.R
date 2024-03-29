library(imager)
library(scales)
library(grid)

# you_are_chosen <- load.image(paste0("./img/",list.files("./img/")[sample(1:809,1)]))


p2 <- load.image("./img/magikarp.png")
p1 <- load.image("./img/gyarados.png")

get_KM <- function(image) {
    dimension <- dim(image)
    poke_color <- data.frame(
        x=rep(1:dimension[2],each=dimension[1]),
        y=rep(dimension[1]:1,each=dimension[2]),
        R=as.vector(image[,,1]),
        G=as.vector(image[,,2]),
        B=as.vector(image[,,3])
    )
    KM <- kmeans(poke_color[,c("R","G","B")], centers=12, iter.max=30)
    show_col(rgb(KM$centers))
    return(KM)
}

# the cluster with the largest size is the "background",
# the cluster with the 2nd largest size is the "border line".

# only match the rest.

k1 <- get_KM(p1)
k2 <- get_KM(p2)

palette1 <- order(k1$size,decreasing = T)[1:10]
palette2 <- order(k2$size,decreasing = T)[1:10]

r <- matrix(rep(0,30*40), 30)
g <- matrix(rep(0,30*40), 30)
b <- matrix(rep(0,30*40), 30)

for (i in 1:30) {
    for (j in 1:40) {
        # if (k1$cluster[i*30+j] %in% palette1) {
        c1 <- k1$cluster[(j-1)*40+i]
        c1_order <- match(c1, palette1)
        r[i,j] <- as.numeric(k2$centers[palette2[c1_order],][1])
        g[i,j] <- as.numeric(k2$centers[palette2[c1_order],][2])
        b[i,j] <- as.numeric(k2$centers[palette2[c1_order],][3])
    }
}

r[is.na(r)] <- 0
g[is.na(g)] <- 0
b[is.na(b)] <- 0

col <- rgb(r,g,b)
dim(col) <- dim(r)
grid.raster(col, interpolate=F)

