\name{sl.time}
\alias{sl.time}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Super Learner for Censored Outcomes
}
\description{
This function allows to compute a Super Learner (SL) to predict survival outcomes.
}
\usage{
sl.time(methods, metric, data, times, failures, group, cov.quanti, cov.quali, cv, 
param.tune, pro.time, optim.local.min, ROC.precision, param.weights.fix,
 param.weights.init, keep.predictions, verbose)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{methods}{A vector of characters with the names of the algorithms included in the SL. At least two algorithms have to be included.}
    \item{metric}{The loss function used to estimate the weights of the algorithms in the SL. See details.}
  \item{data}{A data frame in which to look for the variables related to the status of the follow-up time (\code{times}), the event (\code{failures}), the optional treatment/exposure (\code{group}) and the covariables included in the previous model (\code{cov.quanti} and \code{cov.quali}).}
  \item{times}{The name of the variable related the numeric vector with the follow-up times.}
  \item{failures}{The name of the variable related the numeric vector with the event indicators (0=right censored, 1=event).}
  \item{group}{The name of the variable related to the exposure/treatment. This variable shall have only two modalities encoded 0 for the untreated/unexposed patients and 1 for the treated/exposed ones. The default value is NULL: no specific exposure/treatment is considered. When a specific exposure/treatment is considered, it will be forced in the algorithm or related interactions will be tested when possible.}
  \item{cov.quanti}{The name(s) of the variable(s) related to the possible quantitative covariates. These variables must be numeric.}
  \item{cov.quali}{The name(s) of the variable(s) related to the possible qualitative covariates. These variables must be numeric with two levels: 0 and 1. A complete disjunctive form must be used for covariates with more levels.}
 \item{cv}{The number of splits for cross-validation. The default value is 10.}
 \item{param.tune}{A list with a length equals to the number of algorithms included in \code{methods}. If \code{NULL}, the tunning parameters are estimated (see details).}
 \item{pro.time}{This optional value of prognostic time represents the maximum delay for which the capacity of the variable is evaluated. The same unit than the one used in the argument times. Not used for the following metrics: "loglik", "ibs", "bll", and "ibll". Default value is the time at which half of the subjects are still at risk.}
 \item{optim.local.min}{An optional logical value. If \code{TRUE}, the optimization is performed twice to better ensure the estimation of the weights. If \code{FALSE} (default value), the optimization is performed once.}
 \item{ROC.precision}{The percentiles (between 0 and 1) of the prognostic variable used for computing each point of the time dependent ROC curve. Only used when \code{metric="auc"}. 0 (min) and 1 (max) are not allowed. By default: \code{seq(.01,.99,.01)}.}
  \item{param.weights.fix}{A vector with the parameters of the multinomial logistic regression which generates the weights of the algorithms declared in \code{methods}. When completed, the related parameters are not estimated. The default value is NULL: the parameters are estimated by a \code{cv}-fold cross-validation. See details.}
   \item{param.weights.init}{A vector with the initial values of the parameters of the multinomial logistic regression which generates the weights of the algorithms declared in \code{methods}. The default value is NULL: the initial values are equaled to 0. See details.}
   \item{keep.predictions}{A logical value specifying if all the predictions for all the \code{methods} are saved. If \code{FALSE}, only the predictions related to the SL are saved (for space saving). The default is \code{TRUE}.}
   \item{verbose}{A logical value to print progress (\code{TRUE}) in the fitting process to the console. The default is \code{TRUE}}
 }
 
\details{
Each object of the list declared in \code{param.tune} must have the same name than the names of the \code{methods} included in the SL. If \code{param.tune} = \code{NULL}, the tunning parameters of each algorithm are estimated by \code{cv}-fold cross-validation. Otherwise, the user can propose a tunning grid for each method, as explained in the following table. The following metrics can be used: "brier" for the Brier score at the prognostic time \code{pro.time}, "loglik" for the Log-likelihood, "ibs" for the Integrated Brier score up to the last observed time of event, "ibll" for the Integrated Binomial Log-likelihood up to the last observed time of event, "bll" for the binomial Log-likelihood, "ribs" for the restricted Integrated Brier score up to the prognostic time \code{pro.time}, "ribll" for the restricted Integrated Binomial Log-likelihood Log-likelihood up to the last observed time of event, "bll" for the binomial Log-likelihood, "auc" for the area under the time-dependent ROC curve up to the prognostic time \code{pro.time}.

Methods:
  \tabular{llll}{ 
  Names \tab Description \tab Package \tab assumption \cr
  \code{"aft.gamma"} \tab Gamma \tab flexsurv \tab AFT \cr 
  \code{"aft.ggamma"} \tab  Generalized Gamma \tab flexsurv \tab AFT \cr 
  \code{"aft.weibull"} \tab  Weibull \tab flexsurv \tab AFT \cr 
  \code{"ph.exponential"} \tab  Exponential \tab flexsurv \tab PH \cr 
  \code{"ph.gompertz"} \tab  Gompertz \tab flexsurv \tab PH \cr 
  \code{"cox.all"} \tab  Usual Cox model \tab survival \tab PH \cr 
  \code{"cox.aic"} \tab  Cox model with selected covariates\tab MASS \tab PH \cr 
  \code{"cox.en"} \tab  Elastic Net Cox \tab glmnet \tab PH \cr 
  \code{"cox.lasso"} \tab  Lasso Cox \tab glmnet \tab PH \cr 
  \code{"cox.ridge"} \tab   Ridge Cox \tab glmnet \tab PH \cr 
  \code{"rf.time"} \tab Survival Random Forest \tab
  randomForestSRC \tab RF \cr 
  \code{"nn.time"} \tab Neural Network  \tab survivalmodels \tab
  PH \cr }

Loss Function \code{metric}:
\itemize{
  \item Brier Score (\code{"bs"}) 
  \item Binomial log likelihood (\code{"bll"}) 
  \item Integrated brier score (\code{"ibs"})
  \item Integrated binomial log likelihood (\code{"ibll"})
  \item Restricted Integrated Brier Score (\code{"ribs"})
  \item Restricted Integrated Binomial Log-Likelihood (\code{"ribll"})
}
}

\value{
\item{times}{A vector of numeric values with the times of the \code{predictions}.}
\item{predictions}{A list of matrices with the predictions of survivals of each subject (lines) for each observed time (columns). Each matrix corresponds to the included \code{methods} and the resulted SL (the last item entitled "sl"). If \code{keep.predictions=TRUE}, it corresponds to a matrix with predictions related to the SL.}
\item{data}{The data frame used for learning. The first column is entitled \code{times} and corresponds to the observed follow-up times. The second column is entitled \code{failures} and corresponds to the event indicators. The other columns correspond to the predictors.}
\item{predictors}{A list with the predictors involved in \code{group}, \code{cov.quanti} and \code{cov.quali}.}
\item{ROC.precision}{The percentiles (between 0 and 1) of the prognostic variable used for computing each point of the time dependent ROC curve.}
\item{cv}{The number of splits for cross-validation.}
\item{pro.time}{The maximum delay for which the capacity of the variable is evaluated.}
\item{models}{A list with the estimated models/algorithms included in the SL.}
\item{weights}{A list composed by two vectors: the regressions \code{coefficients} of the logistic multinomial regression and the resulting weights' \code{values}}
\item{metric}{A list composed by two vectors: the loss function used to estimate the weights of the algorithms in the SL and its value.}
\item{param.tune}{The estimated tunning parameters.}
}

\references{
Polley E and van der Laanet M. Super Learner In Prediction. http://biostats.bepress.com/ucbbiostat/paper266. 2010.
}

\examples{
data(dataDIVAT2)

#The outcome model base on a Super Learner and the first 150 individuals of the data base
sl1<-sl.time( methods=c("aft.gamma", "ph.gompertz"),  metric="ibs",
  data=dataDIVAT2[1:150,],  times="times", failures="failures", group="ecd",
  cov.quanti=c("age"),  cov.quali=c("hla", "retransplant"), cv=3)
  
# Individual prediction
pred <- predict(sl1, newdata=data.frame(age=c(52,52), hla=c(0,1),
retransplant=c(1,1), ecd=c(0,1)))

plot(y=pred$predictions$sl[1,], x=pred$times, xlab="Time (years)",
ylab="Predicted survival", col=1, type="l", lty=1, lwd=2, ylim=c(0,1))

lines(y=pred$predictions$sl[2,], x=pred$times, col=2, type="l", lty=1, lwd=2)

legend("topright", col=c(1,2), lty=1, lwd=2, c("Subject #1", "Subject #2"))
}

\keyword{Super Learner}