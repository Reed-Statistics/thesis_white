##Clear workspace
rm(list=ls())

##------------
## PACKAGES
##------------
library(sp)
library(coda)
library(MCMCpack)  ##inverse gamma distribution

##==========================================================================
## Load Image of data.frame called "dat" along with neighborhood matrix "R"
##==========================================================================
load(file = "data.RData")

##-----------
## CONSTANTS
##-----------
##number of small areas (i.e., stands)
m <- 226
##length of each chain
G <- 6000

##----------------------------------
## Multivariate Normal Distribution
##----------------------------------
rmvn <- function(n, mu=0, V = matrix(1)){
  p <- length(mu)
  if(any(is.na(match(dim(V),p))))
    stop("Dimension problem!")
  D <- chol(V)
  t(matrix(rnorm(n*p), ncol=p)%*%D + rep(mu,rep(n,p)))
}

##-----------
## Data
##-----------
sigma.sq <- as.numeric(dat[, "Var.AGBM"])
smooth.sigma.sq <- as.numeric(dat[, "Smooth.Var.AGBM"])

y <- as.matrix(dat[, "Mean.AGBM"], nrow = m)

##Select covariates
X <- dat[, c("OBJECTID", "p25", "p75")]
X <- as.data.frame(X[order(X$OBJECTID, decreasing = FALSE),])
X <- as.matrix(X[,c("p25", "p75")], nrow = m)
##Create Design Matrix
X <- cbind(1, X)

##Starting values for beta from linear model
lm.beta <- lm(Mean.AGBM ~ p25 + p75, data = dat)
beta.start <- as.matrix(coef(lm.beta), nrow = 3)

##-------------------
## Source the models
##-------------------
##Three chains for FH Model
source(file = "model-FH.R")
set.seed(19)
FH.chain1 <- FH.model(y = y, X = X, m = m, sigma.sq = sigma.sq, G = G,
             beta = beta.start, a0 = 2, b0 = round(mean(sigma.sq)), sigma.sq.v = 10000)

FH.chain2 <- FH.model(y = y, X = X, m = m, sigma.sq = sigma.sq, G = G,
             beta = as.matrix(c(-100,5,1), nrow = 3), a0 = 2, b0 = round(mean(sigma.sq)), sigma.sq.v = 1000)

FH.chain3 <- FH.model(y = y, X = X, m = m, sigma.sq = sigma.sq, G = G,
             beta = as.matrix(c(-500,50,10), nrow = 3), a0 = 2, b0 = round(mean(sigma.sq)), sigma.sq.v = 100)

##Three chains for FHCAR Model
source(file = "model-FHCAR.R")
set.seed(19)
FHCAR.chain1 <- FHCAR.model(y = y, X = X, m = m, sigma.sq = sigma.sq, G = G, lambda = 0.5,
             beta = beta.start, a0 = 2, b0 = round(mean(sigma.sq)), sigma.sq.v = 10000, R = R)

FHCAR.chain2 <- FHCAR.model(y = y, X = X, m = m, sigma.sq = sigma.sq, G = G, lambda = 0.8,
             beta = as.matrix(c(-100,5,1), nrow = 3), a0 = 2, b0 = round(mean(sigma.sq)), sigma.sq.v = 1000, R = R)

FHCAR.chain3 <- FHCAR.model(y = y, X = X, m = m, sigma.sq = sigma.sq, G = G, lambda = 0.1,
             beta = as.matrix(c(-500,50,10), nrow = 3), a0 = 2, b0 = round(mean(sigma.sq)), sigma.sq.v = 100, R = R)

## Three chains for FHCAR-SMOOTH Model
## Note: sigma.sq now equals smooth.sigma.sq
set.seed(19)
FHCAR.SMOOTH.chain1 <- FHCAR.model(y = y, X = X, m = m, sigma.sq = smooth.sigma.sq, G = G, lambda = 0.5,
             beta = beta.start, a0 = 2, b0 = round(mean(smooth.sigma.sq)), sigma.sq.v = 500, R = R)

FHCAR.SMOOTH.chain2 <- FHCAR.model(y = y, X = X, m = m, sigma.sq = smooth.sigma.sq, G = G, lambda = 0.8,
             beta = as.matrix(c(-100,5,1), nrow = 3), a0 = 2, b0 = round(mean(smooth.sigma.sq)), sigma.sq.v = 1000, R = R)

FHCAR.SMOOTH.chain3 <- FHCAR.model(y = y, X = X, m = m, sigma.sq = smooth.sigma.sq, G = G, lambda = 0.1,
             beta = as.matrix(c(-500,50,10), nrow = 3), a0 = 2, b0 = round(mean(smooth.sigma.sq)), sigma.sq.v = 100, R = R)


##-----------------------------------
## SUMMARIZE OUTPUT for theta and cv
##-----------------------------------
##warm-up
B <- 3000
##post warm-up and thinned samples
sub <- seq(B+1, G, by = 3)
##post warm-up and unthinned samples
sub2 <- seq(B+1, G, by = 1)

##---------------
##FH mcmc objects
##---------------
FH.tsamps.list <- mcmc.list(mcmc(t(FH.chain1[[1]][,sub])),
                            mcmc(t(FH.chain2[[1]][,sub])),
                            mcmc(t(FH.chain3[[1]][,sub])))
FH.tsamps <- rbind(FH.tsamps.list[[1]], FH.tsamps.list[[2]], FH.tsamps.list[[3]])

##posterior mean of theta
FH.theta.mean <- apply(FH.tsamps, 2, mean)

##posterior variance and cv of theta
FH.var.theta <- apply(FH.tsamps, 2, var)
FH.cv.theta <- sqrt(FH.var.theta) / FH.theta.mean

##-------------------
##FHCAR mcmc objects
##-------------------
FHCAR.tsamps.list <- mcmc.list(mcmc(t(FHCAR.chain1[[1]][,sub])),
                               mcmc(t(FHCAR.chain2[[1]][,sub])),
                               mcmc(t(FHCAR.chain3[[1]][,sub])))
FHCAR.tsamps <- rbind(FHCAR.tsamps.list[[1]], FHCAR.tsamps.list[[2]], FHCAR.tsamps.list[[3]])

##posterior mean of theta
FHCAR.theta.mean <- apply(FHCAR.tsamps, 2, mean)

##posterior variance and cv of theta
FHCAR.var.theta <- apply(FHCAR.tsamps, 2, var)
FHCAR.cv.theta <- sqrt(FHCAR.var.theta) / FHCAR.theta.mean

##-------------------------
##FHCAR-SMOOTH mcmc objects
##-------------------------
FHCAR.SMOOTH.tsamps.list <- mcmc.list(mcmc(t(FHCAR.SMOOTH.chain1[[1]][,sub2])),
                               mcmc(t(FHCAR.SMOOTH.chain2[[1]][,sub2])),
                               mcmc(t(FHCAR.SMOOTH.chain3[[1]][,sub2])))
FHCAR.SMOOTH.tsamps <- rbind(FHCAR.SMOOTH.tsamps.list[[1]], FHCAR.SMOOTH.tsamps.list[[2]], FHCAR.SMOOTH.tsamps.list[[3]])

##posterior mean of theta
FHCAR.SMOOTH.theta.mean <- apply(FHCAR.SMOOTH.tsamps, 2, mean)

##posterior variance and cv of theta
FHCAR.SMOOTH.var.theta <- apply(FHCAR.SMOOTH.tsamps, 2, var)
FHCAR.SMOOTH.cv.theta <- sqrt(FHCAR.SMOOTH.var.theta) / FHCAR.SMOOTH.theta.mean

##-------------------------------------
## DATA FRAME OF THETA and CV ESTIMATES
##-------------------------------------
theta.dat <- data.frame(OBJECTID = dat$OBJECTID, Direct = dat$Mean.AGBM,
                     FH = FH.theta.mean, FHCAR = FHCAR.theta.mean, FHCAR.SMOOTH = FHCAR.SMOOTH.theta.mean)
CV.dat <- data.frame(OBJECTID = dat$OBJECTID, Direct.CV = with(dat, sqrt(Var.AGBM) / Mean.AGBM),
                     FH.CV = FH.cv.theta, FHCAR.CV = FHCAR.cv.theta, FHCAR.SMOOTH.CV = FHCAR.SMOOTH.cv.theta)

##------------------------------
## SCATTER PLOTS from Manuscript
##------------------------------
brewcols <- c('#e66101','#fdb863','#5e3c99', '#b2abd2')

##Figure 3 in Manuscript
plot(Direct ~ FH, data = theta.dat, pch = 19, col = brewcols[2],
     xlab = expression(paste("Posterior Mean of Aboveground Biomass (Mg ", ha^-1,")", sep = '')),
     ylab = expression(paste("Direct Estimate of Aboveground Biomass (Mg ", ha^-1,")", sep = '')))
points(Direct ~ FHCAR.SMOOTH, data = theta.dat, pch = 19, col = brewcols[4])
points(Direct ~ FHCAR, data = theta.dat, pch = 19, col = brewcols[3])
abline(0,1)
legend("topleft",
       legend = c("FH", "FHCAR", "FHCAR-SMOOTH"),
       col = brewcols[2:4],
       lty = rep(NULL, 3),
       pch = rep(19, 3),
       bty = "n")

##Figure 5 in Manuscript
CV.dat.ordered <- CV.dat[order(CV.dat$Direct.CV, decreasing = FALSE),]

plot(1:m, CV.dat.ordered$Direct.CV, ylim = c(0,1.2),
     ylab = "Coefficient of Variation", xlab = "Stands (ordered from smallest to largest CV Direct)", xaxt = "n",
     pch = 19, col = brewcols[1])
axis(1, at = seq(1, m, by = 1), labels = rep("", m), cex.axis = 0.4)
points(1:m, CV.dat.ordered$FH.CV, pch = 19, col = brewcols[2])
points(1:m, CV.dat.ordered$FHCAR.SMOOTH.CV, pch = 19, col = brewcols[4])
points(1:m, CV.dat.ordered$FHCAR.CV, pch = 19, col = brewcols[3])
abline(h = 0.15, lty = 2)
  legend("topleft",
    legend = c("DIRECT", "FH", "FHCAR", "FHCAR-SMOOTH"),
    col = brewcols,
    lty = rep(NULL, 4),
    pch = rep(19, 4),
    bty = "n")

