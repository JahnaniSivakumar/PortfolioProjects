![image](https://github.com/user-attachments/assets/71b69ac6-8aad-4495-afa4-15e021942030)

# Car Insurance Claim Preiction

## 1. Problem Statement
  The "Car Insurance Claim Prediction" project aims to develop a machine learning model to predict whether policyholders will file a claim in the next six months, helping insurance companies optimize risk assessment and pricing strategies through data-driven insights.

## 2. Solution Overview - [Link to Solution](BI_005_12_RCODE_Car_insurance_claim.R)
- To collect a comprehensive dataset of policy holder’s personal and vehicle insurance details
- To explore the dataset and understand the predictor & outcome variables and observation records within the dataset
- To gain a solid grasp of supervised learning data analytics methodologies based on the target outcome variable.
- To perform data pre-processing techniques to replace null values with data imputation, standardize the numerical values, and encode any categorical values.
- To build a predictive model to train the dataset using selective predictor variables to forecast whether policyholders will file a car insurance claim within the next six months.
- To validate the prediction model accuracy using the evaluation/validation dataset and techniques.
- To analyze and gather data-driven information from the model and optimize for accuracy.

## 3. Dataset Description
- Data mining techniques have a wide range of applications across various domains.
- For our project, we have chosen to work on the problem of predicting car insurance claims.
- We have collected 43 input attributes such as policy tenure, age of the car, model, segment, fuel type, etc.
- The target variable is whether a claim is made, represented by the binary variable 'is_claim.’
- This is a classification problem, and we have used four different algorithms - Logistic Regression, Decision Trees, Random Forests, and Neural Networks - to predict the loan status.
- The dataset we have taken is from Kaggle, and it has over 43 input attributes that help us understand the Claim prediction.
- We have plotted several graphs as part of our exploratory data analysis to understand our data better.

## 4. Exploratory Data Analysis
- Verifying the summary of the structure of the dataset to understand the data values
- Next, we verify that we have any NA value or NULL value in the dataset.
- The target variable has an imbalance in data - 93.4% - No Claims; and 6.4% - Yes
- Performed bivariate analysis, featured new variables, and pre-processing methods like one-hot encoding
- Used the 'fastDummies' library to convert categorical data into a numerical format by generating dummy variables. We remove original categorical columns and exclude specific extra dummy variables to avoid overfitting and ensure a streamlined and effective dataset for analysis and modeling
- We standardize column names by replacing spaces, periods, and hyphens with underscores
- To resolve the class imbalance issue in the training dataset, we are using an oversampling technique that involves replicating instances of the minority class (where 'is_claim' equals 1) until the count of both classes is equal. This oversampling is performed through the ovun.sample() function available in the 'ROSE' package.

## 5. Model Building
- Used Random Forest model with **10 Trees** to predict the target variable, the sensitivity was 61.62%, and the specificity was 56.43%, with an Area Under the Curve (AUC) value of 0.621.
  ![image](https://github.com/user-attachments/assets/2f85303d-bddd-45bd-a8f6-b542d08bb9ac)

- Used Random Forest model with **100 Trees** to predict the target variable, the sensitivity was recorded at 62.06% and specificity at 57.16%, with a marginally increased AUC of 0.6316.
  ![image](https://github.com/user-attachments/assets/4af5bdb8-e1bd-47dc-9753-7621a38109fb)

- Used Random Forest model with **500 Trees** to predict the target variable, the accuracy stabilized around 61.61%, with a sensitivity of 61.87% and a specificity of 57.89%. The AUC marginally increased to 0.6317
  ![image](https://github.com/user-attachments/assets/b9dbce69-063c-47ea-9eb7-df5002901c1d)

- Used Logistic Regression model to predict if policy holders will claim or not, an overall accuracy of approximately 56.49%. The confusion matrix showed significant differences in sensitivity and specificity, at 56.29% and 59.42%, respectively. The Area Under the Curve (AUC), was calculated at 0.6106,
![image](https://github.com/user-attachments/assets/11bffeb6-d153-47d7-ab50-e336f36449ba)

- Also used other different models like Decision Tree, Neural Network to solve the same problem

## 6. Performance Overview

![image](https://github.com/user-attachments/assets/b2aab388-1c6b-4e73-bbde-c7ae15fbf983)

## 7. Conclusion
- Logistic regression emerged as the top performer with the highest accuracy, implying strong predictive capabilities.
- However, unlike the Random Forest model, its lower AUC suggests a comparatively weaker ability to distinguish between classes.
- Despite its lower accuracy, Random Forest demonstrated superior discrimination between positive and negative cases, as indicated by its 
higher AUC.
- However, the trade-off is its reduced interpretability compared to logistic regression. 




