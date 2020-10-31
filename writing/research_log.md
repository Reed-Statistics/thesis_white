Fall, Week 9
----------------

### This Week's Work

This week, I have been working on quantifying uncertainty of our Bayesian estimates, looking at comparisons between relationships of predictors and response at unit/area level, watching FIA videos, and learning a tad about post-stratification. 

### Upcoming Work


### Points of confusion


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

