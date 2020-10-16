##=========================================================================
## CARFH MODEL
## see Appendix A of You & Zhou (2011) for  Full Conditional Distributions
##=========================================================================
## y := m x 1 matrix of direct estimates for response variable (i.e., Aboveground biomass)
## X := m x p matrix of covariates
## m := number of small areas (i.e., forest stands)
## sigma.sq := vector of length m for unsmoothed or smoothed variance of direct estimate
## G := length of chain
## lambda := spatial autocorrelation paramter
## beta := p x 1 matrix of coefficients
## a0 := scalar shape parameter for prior of sigma.sq.v 
## b0 := scalar rate parameter for prior of sigma.sq.v
## sigma.sq.v := spatial dispersion parameter
## R := m x m neighborhood matrix
FHCAR.model <- function(y, X, m, sigma.sq, G, lambda, beta, a0, b0, sigma.sq.v, R){

    ##Construct Matrices
    ident <- diag(m)
    E <- diag(sigma.sq)
    Einv <- solve(E)

    theta.mat <- matrix(nrow = m, ncol = G)
    beta.mat <- matrix(nrow = nrow(beta), ncol = G)
    lambda.vec <- vector(mode = "numeric", length = G)
    sigma.sq.v.vec <- vector(mode = "numeric", length = G)
    count.vec <- vector(mode = "numeric", length = G)

    for(i in 1:G){
        ## (1): Draw from Full conditional for theta
        Dmat <- lambda*R + (1 - lambda)*ident
        Lambda <- solve(Einv + Dmat/sigma.sq.v)%*%Einv

        mu <- Lambda%*%y + (ident - Lambda)%*%X%*%beta
        var <- Lambda%*%E
        theta <- rmvn(1, mu, var)

        ## (2): Draw from Full conditional for beta
        mu.beta <- solve(t(X)%*%Dmat%*%X)%*%t(X)%*%Dmat%*%theta
        var.beta <- sigma.sq.v*solve(t(X)%*%Dmat%*%X)
        beta <- rmvn(1, mu.beta, var.beta)

        ## (3): Draw from Full conditional for sigma.sq.v
        shape.v <- a0 + m/2
        scale.v <- b0 + (1/2)*t(theta - X%*%beta)%*%Dmat%*%(theta - X%*%beta)
        sigma.sq.v <- rinvgamma(1, shape.v, scale.v)

        ## (4): Draw from lambda with Metropolis-Hastings step
        h <- det(solve(lambda*R + (1 - lambda)*ident))^(-1/2) * exp((-1/(2*sigma.sq.v))*t(theta - X%*%beta)%*%
                                                                    (lambda*R + (1 - lambda)*ident)%*%
                                                                    (theta - X%*%beta))

        l.star <- runif(n = 1, min = 0, max = 1)
        h.star <- det(solve(l.star*R + (1 - l.star)*ident))^(-1/2) * exp((-1/(2*sigma.sq.v))*t(theta - X%*%beta)%*%
                                                                         (l.star*R + (1 - l.star)*ident)%*%
                                                                         (theta - X%*%beta))

        accept <- min(c(h.star/h, 1))
        u <- runif(n = 1, min = 0, max = 1)

        if(u < accept){
            lambda <- l.star
            count <- 1
        }
        else{
            count <- 0
        }

        ##Parameters to monitor
        theta.mat[,i] <- theta
        beta.mat[,i] <- beta
        lambda.vec[i] <- lambda
        sigma.sq.v.vec[i] <- sigma.sq.v
        count.vec[i] <- count
    }
    out <- list(theta.mat, beta.mat, lambda.vec, sigma.sq.v.vec, count.vec)
}

