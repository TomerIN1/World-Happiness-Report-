
DATASET ACTIVATE DataSet1.
ONEWAY HappinessScore BY Year
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /POSTHOC=SCHEFFE ALPHA(0.05).


DATASET ACTIVATE DataSet1.
T-TEST GROUPS=TopTenVSLowTen(1 0)
  /MISSING=ANALYSIS
  /VARIABLES=HappinessScore EconomyGDPperCapita Family HealthLifeExpectancy Freedom 
    TrustGovernmentCorruption Generosity DystopiaResidual
  /CRITERIA=CI(.95).


ONEWAY HappinessScore EconomyGDPperCapita Family HealthLifeExpectancy Freedom 
    TrustGovernmentCorruption Generosity DystopiaResidual BY TopTenVSLowTen
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /POSTHOC=SCHEFFE ALPHA(0.05).


ONEWAY HappinessScore BY Region
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /POSTHOC=SCHEFFE ALPHA(0.05).


EXAMINE VARIABLES=HappinessScore BY Region
  /PLOT=BOXPLOT
  /STATISTICS=NONE
  /NOTOTAL
  /MISSING=REPORT.


USE ALL.
COMPUTE filter_$=(Region=4).
VARIABLE LABELS filter_$ 'Region=4 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

## Please exclude oman CountryID = 22 ## 

ONEWAY HappinessScore EconomyGDPperCapita Family HealthLifeExpectancy Freedom 
    TrustGovernmentCorruption Generosity DystopiaResidual BY CountryID
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /POSTHOC=SCHEFFE ALPHA(0.05).

FILTER OFF.
USE ALL.
EXECUTE.


CORRELATIONS
  /VARIABLES=HappinessScore EconomyGDPperCapita Family HealthLifeExpectancy Freedom 
    TrustGovernmentCorruption Generosity DystopiaResidual
  /PRINT=TWOTAIL NOSIG
  /STATISTICS DESCRIPTIVES
  /MISSING=PAIRWISE.


REGRESSION
  /DESCRIPTIVES MEAN STDDEV CORR SIG N
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT HappinessScore
  /METHOD=STEPWISE EconomyGDPperCapita Family HealthLifeExpectancy
  /SAVE PRED.


DATASET ACTIVATE DataSet1.
GRAPH
  /SCATTERPLOT(BIVAR)=EconomyGDPperCapita WITH HappinessScore
  /MISSING=LISTWISE.

GRAPH
  /SCATTERPLOT(BIVAR)=Family WITH HappinessScore
  /MISSING=LISTWISE.

GRAPH
  /SCATTERPLOT(BIVAR)=HealthLifeExpectancy WITH HappinessScore
  /MISSING=LISTWISE.

GRAPH
  /SCATTERPLOT(BIVAR)=Value_X_from_GDP_Family_Health_for_Multiple_Regression WITH HappinessScore
  /MISSING=LISTWISE.
