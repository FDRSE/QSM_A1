* Import the data set
clear all

import excel "C:\Users\susan\OneDrive\Escritorio\1. QSM\data_problemset1 (1).xlsx", sheet("Car Prices") firstrow 


* Cleaning the data set
* Drop observations missing 
drop if missing(Car_Price)
drop M-Z
drop if missing(MP)

* a) Estimate first a simple model where the only explanatory variable is kilometers.

regress Car_Price Kilometers

* b) 95% confidence interval ( a conventional level in econometrics)
regress Car_Price Kilometers, level(95)

* Estimate the regression
regress Car_Price Kilometers

* Generate predicted prices = the difference actual price and the predicted price
predict predicted_price, xb

* Generate residuals
predict residuals, residuals

*Results:  
*The residual is positive because the actual price is higher than the predicted price.

* c) Graph residuals against kilometers
scatter residuals Kilometers, yline(0) title("Residuals vs. Kilometers") xtitle("kms") ytitle("residuals")

* Test statistically whether the effect of kilometers is nonlinear
*To be more easy to interpret: Express kilometers in thousands
generate km_thousands = Kilometers/1000

* Generate the squared term, allowing the relationship between car prices and kilometers to be curved.
generate km_thousands_sq = km_thousands^2

* Estimate the model with a quadratic term
regress Car_Price km_thousands km_thousands_sq

* Tests whether the coefficient on the squared term is statistically different from zero.
test km_thousands_sq = 0

* d) Estimate a more complete linear model

* Estimate the complete model by adding relevant explanatory variables
* Estimate the full model
regress Car_Price Kilometers CC HP Year Gas_1Diesel_0 ABS ABD CD AW A_C MP

* Test whether the seven excluded variables are jointly significant
test CC ABS ABD CD AW A_C MP

*****
*
*==================================================
* (e) HYPOTHESIS TESTING
*==================================================

*--------------------------------------------------
* Test 1: The price increases by 1,200 euros per year
* Model: Reduced model (m_comp)
* H0: beta_Year = 1200
* H1: beta_Year != 1200
*--------------------------------------------------

regress Car_Price Kilometers HP Year Gas_1Diesel_0
test Year = 1200


*--------------------------------------------------
* Test 2: CC and ABS are jointly insignificant
* Model: Full model (m_full)
* H0: beta_CC = 0 and beta_ABS = 0
* H1: At least one coefficient differs from zero
*--------------------------------------------------

regress Car_Price Kilometers CC HP Year Gas_1Diesel_0 ABS ABD CD AW A_C MP
test CC ABS


*--------------------------------------------------
* Test 3: The coefficients of CD and Gas are equal
* Model: Full model (m_full)
* H0: beta_CD = beta_Gas
* H1: beta_CD != beta_Gas
*--------------------------------------------------

regress Car_Price Kilometers CC HP Year Gas_1Diesel_0 ABS ABD CD AW A_C MP
test CD = Gas_1Diesel_0


*--------------------------------------------------
* Test 4: The net effect of 20,000 additional km
* and 4 additional years is zero
* Model: Reduced model (m_comp)
* H0: 20000*beta_Kilometers + 4*beta_Year = 0
* H1: 20000*beta_Kilometers + 4*beta_Year != 0
*--------------------------------------------------

regress Car_Price Kilometers HP Year Gas_1Diesel_0
test 20000*Kilometers + 4*Year = 0

*--------------------------------------------------
* Test 5: White's test for heteroskedasticity
* Model: Reduced model (m_comp)
* H0: Homoskedasticity
* H1: Heteroskedasticity
*--------------------------------------------------

regress Car_Price Kilometers HP Year Gas_1Diesel_0
estat imtest, white


*--------------------------------------------------
* Test 6: Breusch-Pagan test
* Test whether heteroskedasticity is related to Year and HP
* Model: Reduced model (m_comp)
* H0: Year and HP do not explain the error variance
* H1: At least one variable explains the error variance
estat hettest Year HP

*************************++
*f)
* Model 1: Regular OLS standard errors
regress Car_Price Kilometers HP Year Gas_1Diesel_0
estimates store model1

* Model 2: Robust standard errors
regress Car_Price Kilometers HP Year Gas_1Diesel_0, vce(robust)
estimates store model2

* Compare both models
estimates table model1 model2, b se stats(N r2)








