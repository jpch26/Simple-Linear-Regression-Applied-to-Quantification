R in the Lab: Simple Linear Regression Applied to Quantification
================

A R tutorial about how to perform a simple linear regression applied to
a quantification problem.

Note that I did not explain how I simulated the experimental data, but
you can see the code on data\_simulation.R

If you have cloned this repository and want to run this analysis from
scratch first run erase\_all\_outputs.R script and then run Main.R
script o whichever script you want.

The image and README\_files folders contain images that I’ve used on
this presentation.

Juan Pablo Carreón Hidalgo

<jpch_26@outlook.com>

 

## Problem

You need to quantify the lycopene quantity of three tomato varieties.
You take samples from these tomatoes and extract the compound of
interest. Then you use
[HPLC](https://en.wikipedia.org/wiki/High-performance_liquid_chromatography)
to quantify the lycopene concentration in the extracts.

![](images/tomato_extraction.jpg)

You HPLC equipment just gives to you signals data as milli-absorbance
units (mAU). The intensity of this signals is proportional to the
concentration in the samples.

You made four repetitions per variety and your data look like this:

<table class=" lightable-classic-2" style='font-family: "Arial Narrow", "Source Sans Pro", sans-serif; width: auto !important; margin-left: auto; margin-right: auto;'>

<thead>

<tr>

<th style="text-align:right;">

V

</th>

<th style="text-align:right;">

S

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

81.58

</td>

</tr>

<tr>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

85.55

</td>

</tr>

<tr>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

91.08

</td>

</tr>

<tr>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

86.09

</td>

</tr>

<tr>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

147.40

</td>

</tr>

<tr>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

144.76

</td>

</tr>

<tr>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

134.95

</td>

</tr>

<tr>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

130.00

</td>

</tr>

<tr>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

181.19

</td>

</tr>

<tr>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

189.29

</td>

</tr>

<tr>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

197.75

</td>

</tr>

<tr>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

185.99

</td>

</tr>

</tbody>

</table>

How can you estimate the concentration of the tomato extracts?

Lycopene is a pigment and its consumption is related with several health
benefits, more information in the paper: [Carotenoids: biochemistry,
pharmacology and treatment](https://pubmed.ncbi.nlm.nih.gov/27638711/).

 

## Solution

You can made a calibration curve to estimate the unknown concentrations.
You buy a lycopene standard (the compound in its pure state) and you
prepare solutions with a known concentration. Again you use your HPLC
equipment to obtain the signals data.

![](images/calibration_curve.JPG)

All analysis are made by triplicate and your first ten measurements may
look like this:

<table class=" lightable-classic-2" style='font-family: "Arial Narrow", "Source Sans Pro", sans-serif; width: auto !important; margin-left: auto; margin-right: auto;'>

<thead>

<tr>

<th style="text-align:right;">

C

</th>

<th style="text-align:right;">

S

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:right;">

20

</td>

<td style="text-align:right;">

43.77

</td>

</tr>

<tr>

<td style="text-align:right;">

30

</td>

<td style="text-align:right;">

74.00

</td>

</tr>

<tr>

<td style="text-align:right;">

40

</td>

<td style="text-align:right;">

88.42

</td>

</tr>

<tr>

<td style="text-align:right;">

50

</td>

<td style="text-align:right;">

115.73

</td>

</tr>

<tr>

<td style="text-align:right;">

60

</td>

<td style="text-align:right;">

144.06

</td>

</tr>

<tr>

<td style="text-align:right;">

70

</td>

<td style="text-align:right;">

159.54

</td>

</tr>

<tr>

<td style="text-align:right;">

80

</td>

<td style="text-align:right;">

182.97

</td>

</tr>

<tr>

<td style="text-align:right;">

90

</td>

<td style="text-align:right;">

205.44

</td>

</tr>

<tr>

<td style="text-align:right;">

100

</td>

<td style="text-align:right;">

229.57

</td>

</tr>

<tr>

<td style="text-align:right;">

110

</td>

<td style="text-align:right;">

253.95

</td>

</tr>

</tbody>

</table>

Let’s estimate the lycopene concentration of the tomato extracts using
the data obtained from the standard solutions. This will be done by a
simple linear regression analysis.

First, my files are organized this way:

![](images/files_organization.png)

  - The analysis folder contains my R scripts, one script for each
    individual analysis.  
  - The data folder contains my data, my experimental data products and
    my analysis products when their outputs produce text or CSV files.  
  - The graphs folder contains the graphical outputs produced by their
    correspond R scripts.

Remember, this organization is just a suggestion. Feel free to try
another one that makes you feel more comfortable, but remember, it is
important ensure that everyone who sees your organization and code be
capable to understand and reproduce your analysis.

 

### Simple linear regression analysis

To perform this analysis I used the follow R script:

``` r
# Linear regression analysis ----------------------------------------------

# Packages
if (!"ggplot2" %in% .packages()) library(ggplot2)

# 1 Import data ----------------------------------------------------------

# 1.1 Calibration curve data
curve_data <- read.csv("data/calibration_curve_data.csv")

# 1.2 Tomato extracts
sample_data <- read.csv("data/sample_data.csv")

# 2 Linear regression analysis -------------------------------------------

# 2.1 Fitting linear model
model_lm <- lm(C ~ S, data = curve_data)  

# 2.2 Linear model summary 
model_sum <- summary(model_lm)

# 2.3 ANOVA for linear summary
model_anova <- anova(model_lm)

# 2.4 Point plot for data and the model 
model_plot <- ggplot(curve_data, aes(x = S, y = C)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE) +
  xlab("Signal (mAU)") +
  ylab("Concentration (mmol)") +
  theme_classic() +
  theme(
    axis.text.x = element_text(color = "black", size = 13),
    axis.text.y = element_text(color = "black", size = 13),
    axis.title = element_text(color = "black", size = 15)
  )

# 3 Save model results ----------------------------------------------------

capture.output(model_sum, file = "data/model_summary.txt")
write.csv(model_anova, file = "data/model_ANOVA.csv", na = " ")
ggsave(filename = "graphs/model_plot.jpg", model_plot)


# 4 Sample concentration predictions ----------------------------------------

# 4.1 Predictions data frame 
sample_pred <- predict.lm(model_lm, newdata = sample_data)
sample_pred <- data.frame(C = round(sample_pred, 2))

# 4.2 Join both signals and predictions data frames
sample_pred <- cbind(sample_data, sample_pred)

# 4.3 Sample red points on model_plot
sample_plot <- model_plot +
  geom_point(data = sample_pred, aes(x = S, y = C), color = "red") 

# 5 Save prediction results -----------------------------------------------

write.csv(sample_pred, file = "data/sample_results.csv")
ggsave(filename = "graphs/sample_plot.jpg", sample_plot)
```

First I checked if the necessary packages are already loaded, in this
case I’ve used `ggplot2` to make a nice plot of the linear model. Then I
imported the data, both for the calibration curve and the tomato
extracts.

``` r
# Packages
if (!"ggplot2" %in% .packages()) library(ggplot2)

# 1 Import data ----------------------------------------------------------

# 1.1 Calibration curve data
curve_data <- read.csv("data/calibration_curve_data.csv")

# 1.2 Tomato extracts data
sample_data <- read.csv("data/sample_data.csv")
```

On the second step I fitted the linear model with the code `model_lm <-
lm(C ~ S, data = curve_data)`, where I specified a simple relation
between the standard concentrations and the signals from the HPLC. I
coded this as if C were dependent on S, this way the tomato extracts
predictions would be easy to obtain.

On the next lines of code I’ve made a nice summary:

``` r
# 2.2 Linear model summary 
model_sum <- summary(model_lm)
```

``` r
model_sum
```

    ## 
    ## Call:
    ## lm(formula = C ~ S, data = curve_data)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -2.3758 -0.9508  0.1241  0.7754  2.8895 
    ## 
    ## Coefficients:
    ##              Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept) -0.870306   0.638478  -1.363    0.184    
    ## S            0.439026   0.003901 112.529   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1.397 on 28 degrees of freedom
    ## Multiple R-squared:  0.9978, Adjusted R-squared:  0.9977 
    ## F-statistic: 1.266e+04 on 1 and 28 DF,  p-value: < 2.2e-16

An ANOVA table:

``` r
# 2.3 ANOVA for linear summary
model_anova <- anova(model_lm)
```

``` r
model_anova
```

<table class=" lightable-classic-2" style='font-family: "Arial Narrow", "Source Sans Pro", sans-serif; width: auto !important; margin-left: auto; margin-right: auto;'>

<thead>

<tr>

<th style="text-align:left;">

</th>

<th style="text-align:right;">

Df

</th>

<th style="text-align:right;">

Sum Sq

</th>

<th style="text-align:right;">

Mean Sq

</th>

<th style="text-align:right;">

F value

</th>

<th style="text-align:right;">

Pr(\>F)

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

S

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

24695.39

</td>

<td style="text-align:right;">

24695.39

</td>

<td style="text-align:right;">

12662.89

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

Residuals

</td>

<td style="text-align:right;">

28

</td>

<td style="text-align:right;">

54.61

</td>

<td style="text-align:right;">

1.95

</td>

<td style="text-align:right;">

</td>

<td style="text-align:right;">

</td>

</tr>

</tbody>

</table>

And a nice a plot:

``` r
# 2.4 Point plot for data and the model 
model_plot <- ggplot(curve_data, aes(x = S, y = C)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE) +
  xlab("Signal (mAU)") +
  ylab("Concentration (mmol)") +
  theme_classic() +
  theme(
    axis.text.x = element_text(color = "black", size = 13),
    axis.text.y = element_text(color = "black", size = 13),
    axis.title = element_text(color = "black", size = 15)
  )
```

``` r
model_plot
```

![](README_files/figure-gfm/model%20plot-1.png)<!-- -->

Note that in `geom_smooth` I set `se = FALSE`. By default `se = TRUE`,
and this displays a confidence interval around the regression line. I
also specified the model `y ~ x` just as I did with `lm()` function\`.

On the third step I saved all the analysis results, including the plot,
in their folders.

``` r
# 3 Save model results ----------------------------------------------------

capture.output(model_sum, file = "data/model_summary.txt")
write.csv(model_anova, file = "data/model_ANOVA.csv")
ggsave(filename = "graphs/model_plot.jpg", model_plot)
```

Finally, on the fourth step I made the concentration predictions of the
tomato extracts.

``` r
# 4 Sample concentration predictions ----------------------------------------

# 4.1 Predictions data frame 
sample_pred <- predict.lm(model_lm, newdata = sample_data)
sample_pred <- data.frame(C = round(sample_pred, 2))

# 4.2 Join both signals and predictions data frames
sample_pred <- cbind(sample_data, sample_pred)

# 4.3 Sample red points on model_plot
sample_plot <- model_plot +
  geom_point(data = sample_pred, aes(x = S, y = C), color = "red") 
```

I used the function `predict.lm()`. You need to specified the model
object (`model_lm`) that the function will use to made the predictions,
and the data with the signals from the tomato extracts (`sample_data`).

`predict.lm()` returns a numeric vector with the predictions, so I
converted it into a data frame and joined it with the sample signals
data frame. You can see the results table just by typing `sample_pred`:

``` r
sample_pred
```

<table class=" lightable-classic-2" style='font-family: "Arial Narrow", "Source Sans Pro", sans-serif; width: auto !important; margin-left: auto; margin-right: auto;'>

<thead>

<tr>

<th style="text-align:right;">

V

</th>

<th style="text-align:right;">

S

</th>

<th style="text-align:right;">

C

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

81.58

</td>

<td style="text-align:right;">

34.95

</td>

</tr>

<tr>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

85.55

</td>

<td style="text-align:right;">

36.69

</td>

</tr>

<tr>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

91.08

</td>

<td style="text-align:right;">

39.12

</td>

</tr>

<tr>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

86.09

</td>

<td style="text-align:right;">

36.93

</td>

</tr>

<tr>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

147.40

</td>

<td style="text-align:right;">

63.84

</td>

</tr>

<tr>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

144.76

</td>

<td style="text-align:right;">

62.68

</td>

</tr>

<tr>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

134.95

</td>

<td style="text-align:right;">

58.38

</td>

</tr>

<tr>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

130.00

</td>

<td style="text-align:right;">

56.20

</td>

</tr>

<tr>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

181.19

</td>

<td style="text-align:right;">

78.68

</td>

</tr>

<tr>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

189.29

</td>

<td style="text-align:right;">

82.23

</td>

</tr>

<tr>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

197.75

</td>

<td style="text-align:right;">

85.95

</td>

</tr>

<tr>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

185.99

</td>

<td style="text-align:right;">

80.78

</td>

</tr>

</tbody>

</table>

Or by looking in the data folder, I saved this data with the code
`write.csv(sample_pred, file = "data/sample_results.csv")`.

I also display as red dots the predictions data:

``` r
sample_plot
```

![](README_files/figure-gfm/predictions%20plot-1.png)<!-- -->

And I saved it with the code `ggsave(filename =
"graphs/sample_plot.jpg", sample_plot)`.

Having concentrations data, you should do some calculus and express your
quantities as lycopene units/tomato weight per sample. For this you will
need the total extract volume and the weight of each tomato sample.

In later steps, it’s usual to make a summary that presents the average
quantities and the standard deviations per variety. If you want to
compare and establish significant differences between varieties it’s
also necessary to perform an analysis of variance. I’ll cover this topic
in another tutorial.

You are free to clone the repository with the code and results of this R
tutorial:

[Simple Linear Regression Applied to Quantification
Repository](https://github.com/jpch26/Simple-Linear-Regression-Applied-to-Quantification.git)

Try to reproduce the analysis step by step, modify and improve the code.
It’s all yours\!
