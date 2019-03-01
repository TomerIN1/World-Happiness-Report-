
## one way anova - difference between year mean score of happines rank

DATASET ACTIVATE DataSet1.
ONEWAY HappinessScore BY Year
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /POSTHOC=SCHEFFE ALPHA(0.05).

## t tests between the top ten happiness score countries and low ten happiness score counties by all the variabels.  

DATASET ACTIVATE DataSet1.
T-TEST GROUPS=TopTenVSLowTen(1 0)
  /MISSING=ANALYSIS
  /VARIABLES=HappinessScore EconomyGDPperCapita Family HealthLifeExpectancy Freedom 
    TrustGovernmentCorruption Generosity DystopiaResidual
  /CRITERIA=CI(.95).

##one way anova between the top ten happiness score countries, the middle happiness score countries and low ten happiness score counties by all the variabels.
 
ONEWAY HappinessScore EconomyGDPperCapita Family HealthLifeExpectancy Freedom 
    TrustGovernmentCorruption Generosity DystopiaResidual BY TopTenVSLowTen
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /POSTHOC=SCHEFFE ALPHA(0.05).

## one way anova to test the difference between the region in the world by happiness score. 

ONEWAY HappinessScore BY Region
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /POSTHOC=SCHEFFE ALPHA(0.05).

## boxplot - visualize the varience between the regions. 

EXAMINE VARIABLES=HappinessScore BY Region
  /PLOT=BOXPLOT
  /STATISTICS=NONE
  /NOTOTAL
  /MISSING=REPORT.

## filter the middle east region for deeper analysis. 

USE ALL.
COMPUTE filter_$=(Region=4).
VARIABLE LABELS filter_$ 'Region=4 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

## Please exclude oman CountryID = 22 ## 

### one way anova to test the difference between the variabels in the middle east region.  

ONEWAY HappinessScore EconomyGDPperCapita Family HealthLifeExpectancy Freedom 
    TrustGovernmentCorruption Generosity DystopiaResidual BY CountryID
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /POSTHOC=SCHEFFE ALPHA(0.05).

FILTER OFF.
USE ALL.
EXECUTE.

### correlations tests between happiness score and the other vairables. 

CORRELATIONS
  /VARIABLES=HappinessScore EconomyGDPperCapita Family HealthLifeExpectancy Freedom 
    TrustGovernmentCorruption Generosity DystopiaResidual
  /PRINT=TWOTAIL NOSIG
  /STATISTICS DESCRIPTIVES
  /MISSING=PAIRWISE.

### stepwise regression between to most corelated variables from the last correlation test - economy, health and family. 

REGRESSION
  /DESCRIPTIVES MEAN STDDEV CORR SIG N
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT HappinessScore
  /METHOD=STEPWISE EconomyGDPperCapita Family HealthLifeExpectancy
  /SAVE PRED.

### scatterplot visualization between each one of the three variables. 
-- economy and happiness score

DATASET ACTIVATE DataSet1.
GRAPH
  /SCATTERPLOT(BIVAR)=EconomyGDPperCapita WITH HappinessScore
  /MISSING=LISTWISE.

--- family and happiness score

GRAPH
  /SCATTERPLOT(BIVAR)=Family WITH HappinessScore
  /MISSING=LISTWISE.

-- health and happiness score

GRAPH
  /SCATTERPLOT(BIVAR)=HealthLifeExpectancy WITH HappinessScore
  /MISSING=LISTWISE.

--- combined values of economy, family and health with happiness score. 

GRAPH
  /SCATTERPLOT(BIVAR)=Value_X_from_GDP_Family_Health_for_Multiple_Regression WITH HappinessScore
  /MISSING=LISTWISE.
