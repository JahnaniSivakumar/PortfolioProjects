![image](https://github.com/user-attachments/assets/9894fc38-faf0-494c-b814-dd99fe9c5fc6)

# Telecom Customer Churn Prediction

## Problem Statement 
- Telecom operators are facing customer churn, with users switching due to competitive pricing, service disruptions, and unmet expectations.
- Understanding the characteristics of churners and predicting churn behavior helps in retaining customers, improving satisfaction, and sustaining market share.
- This requires developing a data-driven predictive model to identify at-risk customers and segment them for targeted retention strategies.

## Solution Overview - [Link to Solution](Telecom_Customer_Churn_Prediction.ipynb)
- Initial Understanding of the domain: Exploring the possibilities of the churning customer pesonna and sourcing dataset from Kaggle
- Imbalanced target variable hence used SMOTEENN to re-sample
- Data wrangling methods to set the appropriate data types for every feature and handle any missing data
- Univariate and Bivariate analysis of all the features with the target variable along with correlation analysis
- Modeling using the supervised classification models like Decision Tree and Random Forest Classifier to predict whethere a customer will churn or not
- Segment the customers who are going to churn and strategize targeted retention methods
  
## Churning Customer Personna

### 1. Customer thinking not to churn
- Too complex to think about churning - inert subscriber (lazy)
- My operator is best so no idea to churn - unconditionally loyal

### 2. Customer thinking to churn
- Locked in any contract - want to churn but they are binded to an yearly contract - Locked in subscriber - CANNOT CHURN
- Not locked in by any contract
     - Though thought about churning, decided to stay - Conditionally Loyal
     - Decided to leave 
            a) Better offer from other company - Conditionally Churner
            b) Needs changed - Lifestyle Migrator
            c) Not satisfied - Unsatisfied Churner

## Dataset Overview
- Source: Kaggle
- Combination of numerical and categorical variables - 21 features & 7043 records
- The target variable churn is not balanced. i.e we can see the ratio of yes: no as - 73:27

## Exploratory Data Analysis
- 75% of customers has tenure less than 55 months
- Data is highly imbalanced, ratio = 73:27. So we analyse the data with other features while taking the target values separately to get insights.
  ![Untitled](https://github.com/user-attachments/assets/1da2fcfd-e1a1-438b-ab97-e4c83c5d91dc)

- **Data Cleaning** : Total Charges should be converted from object to numeric datatype
- Estimating the percentage of missing values for every feature and plotting it in a point plot

- **Univariate Analysis**: Exploring each feature against the target variable
- Perform one-hot encoding to convert all the category variables
- Total Charges increase as the montly charge increase as expected
- Churn is high when Monthly Charges are high
- Higher Churn at lower Total Charges. However if we combine the insights of 3 parameters i.e. Tenure, Monthly Charges & Total Charges - Higher Monthly Charge at lower tenure results into lower Total Charge. Hence, all these 3 factors are linked to High Churn.
  
- **Correlation Analysis**:
- HIGH Churn seen in case of Month to month contracts, No online security, No Tech support, First year of subscription and Fibre Optics Internet.
- LOW Churn is seens in case of Long term contracts, Subscriptions without internet service and The customers engaged for 5+ years
- Factors like Gender, Availability of PhoneService and # of multiple lines have alomost NO impact on Churn
  ![Untitled](https://github.com/user-attachments/assets/e6c7469a-51fc-4f2c-a09b-fd4f8ab65141)

- **Bi-variate Analysis**:
- Electronic check medium are the highest churners
- Contract Type - Monthly customers are more likely to churn because of no contract terms, as they are free to go customers.
- No Online security, No Tech Support category are high churners
- Non senior Citizens are high churners

## Model Building
- Splitting the dataset into test and train set : model the trained set to prdict the test dataset
- **Decision Tree classification model** is used to train the data initially, and we observe precision, recall and f1-score is minimum as the dependent variable has an imbalance.
- Therefore, **SMOTEENN** is used and we observe better Accuracy, Precision, Recall after resampling the dependent variable
  ![image](https://github.com/user-attachments/assets/8b153a91-d6c3-4f67-b7e5-e1acca42be59)
  
- Random Forest Ensembling method is used to train the model and we can observe a very good precision, recall and f1-score compared to previous model
- Finally, saving the model using pickling method, because later it can be used and deployed using flask in a webpage to predict whethere any customer will churn or not

## Customer Retention Strategies

The churning customers can be clustered into multiple churning persona clusters, and retention methods can be tailored accordingly.

### **1. Unsatisfied Churners**
- Resolve complaints promptly.
- Offer loyalty perks.

### **2. Lifestyle Migrators**
- Introduce flexible plans.
- Advertise location-specific benefits.

### **3. Monthly Contract Customers**
- Encourage upgrades to yearly contracts with discounts.
- Provide exclusive add-ons or services.


