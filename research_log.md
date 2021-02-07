Spring, Week 2
----------------

### This Week's Work

* Major edits to diagrams for Context chapter.     
* Aligned existing work in Data chapter to color palette of diagrams in Context chapter. Attempting to stay with these colors throughout thesis for aesthetics.     
* Added informative Figure captions in Context chapter.     

(WANT TO DO BY WEDS):     
* Major edits to Methods chapter.     
* Finish aligning existing work to color palette.


### Upcoming Work


### Points of confusion
* Should I include diagrams for the EBLUP unit and area models? Based on their derivations and intuition behind the models, I think it would be hard to make elegantly.     
* I need help with the PS direct estimate. I haven't been able to get it to work out and have been using the mean. So, to really finalize the results dataframe we need to have that. 



Spring, Week 1
----------------

### This Week's Work

* I made many diagrams in Keynote for the Context chapter    
* Full restructure of the Context chapter: applied edits, implemented diagrams, restruture/add more details, change phrasing, add more motivation, etc.     
* I made quick edits to the data chapter to align better with the writing I did in the Context chapter (phrasing, abbreviations, formatting titles)


### Upcoming Work

* Similar operation to the Methods chapter as I did to the Context chapter. Will need to add more significant contently likely, but won't need to spend hours in Keynote.

### Points of confusion

* I'd like to talk about pacing of the these in the `writing/spring_schedule.Rmd` document. I am hoping to end up turning in a bit early to give myself a breather between the paper and thesis, but I want to think about how practical the timeline I laid out is. 

Spring, Week 0
----------------

### This Week's Work

Over break I implemented the models over the entire interior west for all four response variables and saved the results in a dataframe. I also have made some summaries of these results. 


Fall, Week 13
----------------

### This Week's Work

This week, I wrote functions for modeling. I wrote five main modeling functions: `hb_unit()`, `hb_area()`, `freq_unit()`, `freq_area()`, and `direct_estimate()`. I also wrote functions to grab the coefficient of variation from each function. Each of the modeling functions take in the same three basic arguments (data, formula, small_area) and none of the functions require any data pre-processing. There `hb_*()` functions use `hbsae` while the `freq_*()` functions use `sae`. To get the CoV's for the frequentist models, I had to bootstrap, but that worked pretty seamlessly.

I also made an rmd that uses these functions on M333 and plots their CoV at the end. 


### Upcoming Work

* Implementing these over the entire Interior West!


### Points of confusion

* I had a few errors when I tried to `map()` these over the whole interior west. I think it is how I am specifying one of my priors that is causing this error, but I did not have enough time to debug that yet. 

* I am not sure which column to use for weights for post-stratification, so currently the `direct_estimate()` function is just the mean. 


Fall, Week 12
----------------

### This Week's Work

* Revised Data chapter once more for any adjustments to just talk about `nlcd11` and the entire Interior West (rather than any large specific details about M333)

* Wrote content for the context chapter

* Wrote content for the methods chapter

### Upcoming Work

* (Once we get the population level data) set up all the models, run them, and save as R data object for analysis.

* More writing in methods. Maybe extensions to context? Really curious to hear what I should be trying to expand on there.


### Points of confusion

* I had a lot of trouble making the context chapter longer. I wrote over it a few times and often changed things significantly, but whenever I would end up writing more than a few pages it would get "off topic" in the sense that I would be diving into things that are more suited for a methods chapter. 

* I have a few logistical questions as well. 


Fall, Week 11
----------------

### This Week's Work

This week, I initally tied up loose ends from last week by finishing my revisions to the Data chapter. I then read chapters from Small Area Estimation to try to see what was going wrong with the modeling. After not being able to figure out what (if anything) needed to change for the unit level model, I eventually took a deep dive back into `hbsae`, which was the package that I really thought didn't work. However, I was eventually able to get an output that made sense and aligned with my results from `rstanarm`! The `hbsae` package also has a few built in features to asses model quality, and these functions yeild really, really, good results in terms of coefs of variation. 

One notable thing about `hbsae` is that it uses integration rather than MCMC to compute its estimates. This doesn't seem to be a problem as the results align well with `rstanarm`. I think that I will try to use this package for our models as the model fitting is almost instant and it has those nice helper functions that would allow us to easily compare the models to those fit with a package like `sae`. 

### Upcoming Work

* Context chapter

* Cleaning up modeling, doing more modeling, comparison to frequentist models, etc. 

### Points of confusion

* Not a point of confusion, but I'd like to talk through the `hbsae` code to make sure you think everything looks good before I go all out in using it for the models. 

Fall, Week 10
----------------

### This Week's Work

This week, I have primarily been writing in the thesis document:

* I set up thesisdown and bibTeX and those seem to be working well.
* I added sections to the results chapter for unit-level models and an a section with a brief overview of modeling.
* I went through (almost) all the edits in the Data chapter and I think it is really quite good shape now. 

Besides writing, I also experimented with some modeling and watched videos from the FIA conference:

* I watched Cory Green's video and began to understand the EBLUP a little better
* I found a way to calculate effective sample size (`bayestestR::effective_sample()`).
* I started using the `sae` package for frequentist models. Still need to do a writeup there but this package seems really useful for comparing Bayesian models to standard frequentist models and direct estimators.
* I read through the Green Book's section on post-stratification. I think I understand it much better now in the context of forestry, but I could use help actually implementing it (which variable do we use to stratify?)


### Upcoming Work

* Context chapter: write on all the model types, benefits of bayes, currently used methods etc.

* Priors: still not set in stone yet, but I am understanding them better. Just frustrated with the lack of a gamma or inverse gamma prior in `rstanarm`. I think I need to come up with a different reguarlizing prior because `rstanarm` does not seem to support an inverse-gamma prior. 

* Area-level results and methods. 

* Use `sae` to compare EBLUP with our HB models.

### Points of confusion

* Area level models. We spoke about confusion on what to vary our intercepts over however I think it would be good to talk more there and consider fitting the model on a larger scale. 

Fall, Week 9
----------------

### This Week's Work

This week, I have been working on quantifying uncertainty of our Bayesian estimates, looking at comparisons between relationships of predictors and response at unit/area level, watching FIA videos, and learning a tad about post-stratification. In particular, I have found that the area level models seem to do much better on a variety of metrics, and with the unit level models where they are at now I am not sure how viable they are. I also watched the FIA video from Radke which was informative in terms of talking about things like the coefficient of variation. When looking at relationships between the predictors and response variables, I found much stronger linear relationships at the area level. Currently, I am feeling somewhat lost in terms of whether or not the unit level models I created are salvagable due to their seemingly large confidence intervals/coefs of variation. 

### Upcoming Work

* Modeling: Figuring out what models are working well, and which are not. I think there is some work to be done to organize what I have done already and taking a good look at making sure quantification of uncertainty is consistent across models. Also, I think it would be good to asses the goals of which models will be in the thesis and what comparisons need to be made across models. 

* Writing: Start the context chapter

* Other: Watch the other videos Gretchen was talking about

### Points of confusion

I really feel like I need to get to a solid model form and have been struggling there (area vs. unit, what to vary intercepts over, what models to compare the HB model to). 

In general, refocusing onto what precise work needs to be done to compare models in the thesis. 


Fall, Week 8
----------------

### This Week's Work

This week, I worked mainly on two things: writing the rough draft of the Data chapter, and quantifying the uncertainty in the mean estimates of the model. Writing the data chapter took a good deal of time, along with creating the figures that I wanted to include in it. However, I think its in a pretty good spot now, and with some finetuning will be a really nice chapter. 

To quantify uncertainty, rather than finding an exact mathematical formula for the standard errors of the estimates, I bootstrapped the results for both the direct mean estimate and the hierarchial bayesian model. The direct mean bootstrap loop takes just a few minutes to run, but the HB model took overnight (approx 11-12 hours) to get 1000 bootstrap estimates. 

Also: (Did this today (Monday) morning). I worked through Finley's code and fit a model which gave different (but not wildly different) results. 


### Upcoming Work

In the coming week, I still need to do some finetuning of my first model.     

* Getting the priors "right"     
* Running my data using Finley's code to see if we get the same estimates


### Points of confusion

* I feel like the data chapter is still a little fuzzy on FIA's sampling design -- I think I would benefit from talking through the data collection to make sure I wrote about that correctly in the data chapter. 

* Priors - so confusing.

Fall, Week 7
----------------

### This Week's Work

This week, I spent a large amount of time figuring out how to make the modeling work. Initially, I used `hbsae`, but found that when I inputted data into the model, the output was perfectly correlated with the input data. Next, I tried to use `tidymodels` but was not getting the output I wanted. So, I found Finley's code from the LiDAR paper and tried to use it. However, I eventually went back to `tidymodels` and found a few errors in my code which had made me think that I was not creating a good model when in fact it was working as it should. However, now I think I have a model that is (almost) there! I have some questions, but I think the output is really, really close!

I have also started working on the data chapter. I think that I need to add a bit to it to make it a bit more descriptive, but the outline is getting there pretty well. 

### Upcoming Work

* Finish a rough draft of the data chapter

* More modeling -- different response variables. Compare performance of models. Credible intervals. Get the priors right. 

### Points of confusion

* I want to make sure the model output is correct. This has been throwing me for a bit of a loop. The response variable is at the plot level, so we get plot level estimates. But we want ecosubsection level estimates. So, I took the mean of the plot level estimates grouped by ecosubsection, but I am not sure if that is the correct way to do things. 

* Trying to quantify uncertainty in a "good" way. Not sure how to do so when I am aggregating the model output. 

* I would like to know what to expand on in the data chapter. 

Fall, Week 6
----------------

### This Week's Work

This week, I did a few things:

* performed ANOVAs to verify that the key variables vary less at the ecosubsection levels vs ecosections vs. provinces; 

* looked at Finley's model specification and figured out that it is just a varying intercept model by group with fixed effect slopes;

* did a (somewhat short) writing about the frequentist mixed model form;

* began experimenting with `hbsae` to fit a baby model;

* and watched some of the videos from the FIA conference. 


### Upcoming Work

* Fit better models in `hbsae`

* Start data chapter? (Due Oct 23 on thesis repo)
    * Start `thesisdown` document?

### Points of confusion

* 

Fall, Week 5
----------------

### This Week's Work

This week, I primarily worked on two things: (1) data analysis that helped (a) understand the structure of ecosubsections within ecosections, and ecosections within provinces and (b) quantified how much key variables changed within sections and within provinces vs. within the interior west. (2) Completed the writing goal for this week. I wrote about what hierarchial bayesian modeling is, why someone might want to use it, and created an example of hierarchical bayesian modeling and explained what specific benefits that model would have in that setting. This writing goal took suprisingly longer than expected, when I began writing about the model it really made me realize what I did and didn't know. Writing down exact model forms really helped me solidify my understanding. 

### Upcoming Work

* Pick software to use

* Watch the recorded videos
    * Only got to the introductory one this week. 


* Start modeling?

* Start the thesis doc?

### Points of confusion

* I'd love to talk about the data analysis I did to make sure I am comparing apples to apples in the sense that I am measuring variability across groups accurately. 

* I think I would also benefit from going through and writing out a sketch of a potential model -- looking at what explanatory variables would be used. 

* I would also love feedback on what I wrote this week. I think that most of it is correct, but hierarchical models are explained quite differently in different books/papers and I would benefit from knowing if I am explaining everything correctly. 

Fall, Week 4
----------------

### This Week's Work

This week, I have been primarily doing three things: exploratory data analysis, gaining knowledge about hierarchical bayesian modeling, and looking into software. 

In terms of exploratory data analysis, I have created the EDA folder which include an `.Rmd` with the work I have done there. I looked into a particular province and tried to see how much I could learn about it through data visualization and summary statistics. While the findings are not extremely exciting, working with the data has given me a much better grasp of the variables that we have along with just an overall good sense of the data. 

I have also been looking more at Hierarchical Bayesian Modeling. I found a lecture online from Richard McElreath which was very useful in understanding the concepts on HB modeling and how it will be useful for us. I was also able to source an electronic copy of his book (Statistical Rethinking), which has been very helpful. The book uses the package `rethinking` to specify hierarchical models, which seems like a powerful package. It is educational however, so it requires the user to specify every piece of the model explicitly. 

The most promising software I have found is the `spbayes` package by Finley, I will need more time to figure out if it will work for our purposes as I found it late in the week, but so far the examples I have seen of it being used have been for similar things to the goal of my thesis. 


### Upcoming Work

* Decide on which package to use to do the modeling

    * Dive deep into `spbayes` (and maybe `hbsae`)

### Points of confusion

* Clarification on what type(s) of HB models we are going to use. I want to make sure the software is flexible enough to specify these models easily and be able to change small details about the models easily. There seems to be a tradeoff in some of the software, where a package like `rethinking` is extremely flexible and you specify every tiny piece of the model, vs. some other packages where much less is needed to run the model but some assumptions are made for you. 

Fall, Week 3
----------------

### This Week's Work

This week, I have been reviewing relevant literature on both Hierarchical Bayesian modeling and forestry research, along with familiarizing myself with the data. I wrote summaries of the papers I read in the literature review document. I also read through a good portion of the selected chapters of Monika's book. 

I was able to source a few more papers, and one that seemed extremely relevant was a draft version of Finley's LiDAR paper. This paper gave some great background on forestry data and SAE along with nice reporting of results. They did a simulation study to understand how well their (FH and FHCAR) models performed. 

I also breifly looked into the `hbsae` package. The `fSAE.Unit()` function seems to be the main function and it looks very well set up with nice documentation and great explanations for what each argument of the function does and what dimensions that object should have. Other than that, I didn't look much further into the package. 

I also looked into the data, but I think I would benefit from walking through it at some point. I will definitely spend more time on that front soon as well, I think it's going to take awhile to get a good sense of the data. 

### Upcoming Work

* Read, source, and summarize more relevant papers

* Figure out best software to do the analysis (eventually, might not be pressing now?)
    * STAN, JAGS, `rstan` in `tidymodels`, `hbsae`, etc.
        * `hbsae` seems quite promising from an inital look
        
* Dig deeper into the data

* Learn about more HB modeling techniques outside of the FH family

### Points of confusion

* Can I post scripts that use the data on github or does that uses/visualizes the data in any way need to stay local on my computer?

* I am trying to better understand the data and it is going to be used in the models. I think I would really benefit from getting a bit more of a concrete understanding of the process.
    * In my mind, the large overview of the project looks like: 1) gain significant domain knowledge and a fuller understanding of HB modeling. 2) Implement models on multiple small areas. 3) Compare model performance across models I specified and frequentist models in existing literature by looking at things like MSE, bias, etc. 4) Understand benefits and costs of using the HB framework for trying to answer SAE questions. Does this seem reasonable? Are there significant missing steps/analyses that are needed? 
        * This stepwise plan seems to fit really well with the Finley (2017) draft paper and what they did there. 

* Outside of making sure I have the scope and goals of the thesis in my mind correctly and the steps I feel should be taken are somewhat accurate, I also feel that there is a *lot* for me to learn about forestry variables and the data itself. 

*******************************

## Research Log


You will use this document to keep track of where you are in the project and where you are going. Each week, complete the following:

- Summarize what you learned and worked.
    + Don't forget to push all update to your GitHub repository.
    + Update the Notes/Issues in your GitHub Project.
- Summarize and prioritize the next things that need to be done.
    + Create informative "To Dos" in your GitHub repository.
- Identify any (big/small/technical/conceptual/anything) ideas that are fuzzy/confusing/baffling.

