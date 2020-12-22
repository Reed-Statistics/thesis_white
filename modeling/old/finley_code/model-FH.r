##=========================================================================
## FH MODEL
## see Appendix A of You & Zhou (2011) for  Full Conditional Distributions
##=========================================================================
## y := m x 1 matrix of direct estimates for response variable (i.e., Aboveground biomass)
## X := m x p matrix of covariates
## m := number of small areas (i.e., forest stands)
## sigma.sq := vector of length m for variance of direct estimate
## G := length of chain
## beta := p x 1 matrix of coefficients
## a0 := scalar shape parameter for prior of sigma.sq.v 
## b0 := scalar rate parameter for prior of sigma.sq.v
## sigma.sq.v := spatial dispersion parameter
## g := vector of length m for weighted variances (i.e., sigma.sq and sigma.sq.v)
FH.model <- function(y, X, m, sigma.sq, G, beta, a0, b0, sigma.sq.v){
    ##Construct Matrices
    theta.mat <- matrix(nrow = m, ncol = G)
    beta.mat <- matrix(nrow = nrow(beta), ncol = G)
    g.mat <- matrix(nrow = m, ncol = G)
    sigma.sq.v.vec <- vector(mode = "numeric", length = G)

    g <- vector(mode = "numeric", length = m)
    mu <- vector(mode = "numeric", length = m)
    var.t <- vector(mode = "numeric", length = m)
    theta <- matrix(nrow = m, ncol = 1)
    
    for(i in 1:G){
        ## (1): Draw from Full conditional for theta
        for(j in 1:m){
            g[j] <- sigma.sq.v / (sigma.sq.v + sigma.sq[j])
            mu[j] <- g[j]%*%y[j] + (1 - g[j])%*%t(X[j,])%*%beta
            var.t[j] <- sigma.sq[j]%*%g[j]
            theta[j,1] <- rnorm(1, mu[j], sqrt(var.t[j]))
        }

        ## (2): Draw from Full conditional for beta
        mu.beta <- solve(t(X)%*%X)%*%t(X)%*%theta
        var.beta <- sigma.sq.v*solve(t(X)%*%X)
        beta <- mvrnorm(1, mu.beta, var.beta)        

        ## (3): Draw from Full conditional for sigma.sq.v
        shape.v <- a0 + m/2
        scale.v <- b0 + (1/2)*t(theta - X%*%beta)%*%(theta - X%*%beta)
        sigma.sq.v <- rinvgamma(1, shape.v, scale.v)
                                       
        ##Parameters to monitor
        theta.mat[,i] <- theta
        beta.mat[,i] <- beta
        sigma.sq.v.vec[i] <- sigma.sq.v
        g.mat[,i] <- g
    }
    out <- list(theta.mat, beta.mat, sigma.sq.v.vec, g.mat)
}




