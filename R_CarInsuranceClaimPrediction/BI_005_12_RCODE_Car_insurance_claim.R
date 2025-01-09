############ Importing Libraries ###############
# Load necessary library
library(dplyr)
library(stringr)
library(ggplot2)

########### Training Data set #################

########### Loading Data ##############

# Load the data
df.train <- read.csv('train.csv')

# Display the first few rows
head(df.train)

# Summary of data types
str(df.train)
colnames(df.train)

# Basic statistical summary 
summary(df.train)

########### Exploratory Data Analysis #############

# Count the number of missing values (NA) in each column of the dataframe 'df.train'
na_count <- colSums(is.na(df.train))
na_count

# The dataset comprises 44 columns and 58592 rows, including both categorical (28) and numerical (16)  data.
# There are no missing values in any of the columns

# Dropping policy_id column
df.train_filter <- df.train[,-c(1)]

# Calculate counts of 'No Claim' and 'Claim'
claim_counts <- table(df.train_filter$is_claim)

# Create a pie chart
pie(claim_counts, labels = c('No Claim', 'Claim'), radius = 1, col = c('mediumaquamarine', 'peachpuff'),
    init.angle = 45, clockwise = TRUE, border = NA, cex = 1.5,
    main = 'Distribution of Claims')

# The target variable has imbalance data and we will address this while building the model
# Add legend
legend("topright", c('No Claim', 'Claim'), fill = c('mediumaquamarine', 'peachpuff'), title = 'Outcome')

# Assuming you have a dataframe 'df', replace column names with your actual columns
for (col in colnames(df.train_filter)) {
  hist_data <- df.train_filter[[col]]
  hist <- ggplot(data = NULL, aes(x = hist_data)) +
    geom_bar(fill = "mediumaquamarine", color = "peachpuff", bins = 20, stat = "count") +
    labs(title = paste("Histogram of", col)) +
    theme_minimal()
  
  print(hist)
}

# Count plot for 'area_cluster'
plot_area_cluster <- ggplot(df.train_filter, aes(x = area_cluster, fill = factor(is_claim))) +
  geom_bar(position = 'dodge') +
  labs(title = "Countplot for area_cluster", y = "Count") +
  scale_fill_manual(values = c("mediumaquamarine", "peachpuff"), labels = c("No Claim", "Claim")) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Count plot for 'segment'
plot_segment <- ggplot(df.train_filter, aes(x = segment, fill = factor(is_claim))) +
  geom_bar(position = 'dodge') +
  labs(title = "Countplot for segment", y = "Count") +
  scale_fill_manual(values = c("mediumaquamarine", "peachpuff"), labels = c("No Claim", "Claim")) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Count plot for 'model'
plot_model <- ggplot(df.train_filter, aes(x = model, fill = factor(is_claim))) +
  geom_bar(position = 'dodge') +
  labs(title = "Countplot for model", y = "Count") +
  scale_fill_manual(values = c("mediumaquamarine", "peachpuff"), labels = c("No Claim", "Claim")) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Count plot for 'fuel_type'
plot_fuel_type <- ggplot(df.train_filter, aes(x = fuel_type, fill = factor(is_claim))) +
  geom_bar(position = 'dodge') +
  labs(title = "Countplot for fuel_type", y = "Count") +
  scale_fill_manual(values = c("mediumaquamarine", "peachpuff"), labels = c("No Claim", "Claim")) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Count plot for 'max_torque'
plot_max_torque <- ggplot(df.train_filter, aes(x = max_torque, fill = factor(is_claim))) +
  geom_bar(position = 'dodge') +
  labs(title = "Countplot for max_torque", y = "Count") +
  scale_fill_manual(values = c("mediumaquamarine", "peachpuff"), labels = c("No Claim", "Claim")) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Count plot for 'max_power'
plot_max_power <- ggplot(df.train_filter, aes(x = max_power, fill = factor(is_claim))) +
  geom_bar(position = 'dodge') +
  labs(title = "Countplot for max_power", y = "Count") +
  scale_fill_manual(values = c("mediumaquamarine", "peachpuff"), labels = c("No Claim", "Claim")) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Count plot for 'engine_type'
plot_engine_type <- ggplot(df.train_filter, aes(x = engine_type, fill = factor(is_claim))) +
  geom_bar(position = 'dodge') +
  labs(title = "Countplot for engine_type", y = "Count") +
  scale_fill_manual(values = c("mediumaquamarine", "peachpuff"), labels = c("No Claim", "Claim")) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Count plot for 'is_speed_alert'
plot_speed_alert <- ggplot(df.train_filter, aes(x = is_speed_alert, fill = factor(is_claim))) +
  geom_bar(position = 'dodge') +
  labs(title = "Countplot for is_speed_alert", y = "Count") +
  scale_fill_manual(values = c("mediumaquamarine", "peachpuff"), labels = c("No Claim", "Claim")) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Display individual plots
plot_area_cluster
plot_segment
plot_model
plot_fuel_type
plot_max_torque
plot_max_power
plot_engine_type
plot_speed_alert

###################### Convert Torque into Torque/rpm ############

# Extract torque values from 'max_torque' column using regex pattern
df.train_filter$torque <- str_extract(df.train_filter$max_torque, "\\d+\\.?\\d*(?=Nm)")
df.train_filter$rpm <- str_extract(df.train_filter$max_torque, "\\d+\\.?\\d*(?=rpm)")

# Convert 'torque' column from character to numeric
df.train_filter$torque <- as.numeric(df.train_filter$torque)
df.train_filter$rpm <- as.numeric(df.train_filter$rpm)

# Calculate torque to RPM ratio and add as a new column
df.train_filter$torque_to_rpm_ratio <- df.train_filter$torque / df.train_filter$rpm

#Remove max_torque
cols_rmv <- c("max_torque","torque", "rpm")

df.train_filter <- df.train_filter[,!(names(df.train_filter) %in% cols_rmv)]

##################### Convert Power into Power/rpm ##############

# Extract torque values from 'max_power' column using regex pattern
df.train_filter$power <- str_extract(df.train_filter$max_power, "\\d+\\.?\\d*(?=bhp)")
df.train_filter$rpm <- str_extract(df.train_filter$max_power, "\\d+\\.?\\d*(?=rpm)")

# Convert 'Power' column from character to numeric
df.train_filter$power <- as.numeric(df.train_filter$power)
df.train_filter$rpm <- as.numeric(df.train_filter$rpm)

# Calculate power to RPM ratio and add as a new column
df.train_filter$power_to_rpm_ratio <- df.train_filter$power / df.train_filter$rpm

#Remove max_torque and max_power
cols_rmv <- c("max_power", "power", "rpm")

df.train_filter <- df.train_filter[,!(names(df.train_filter) %in% cols_rmv)]

######### Convert "is_" column's 'Yes' and 'No' into 1 and 0 ##########

# Get column names that contain "is_" in the dataframe 'df.train_filter'
is_cols <- grep("^is_", names(df.train_filter), value = TRUE)

# Replace "Yes" with 1 and "No" with 0 in columns specified in is_cols within df.train_filter
df.train_filter <- df.train_filter %>%
  mutate_at(vars(is_cols), ~ ifelse(. == "No", 0, ifelse(. == "Yes", 1, .)))

# List of columns to convert to numeric
columns_to_convert <- c("is_esc", "is_adjustable_steering", "is_tpms", "is_parking_sensors",
                        "is_parking_camera", "is_front_fog_lights", "is_rear_window_wiper",
                        "is_rear_window_washer", "is_rear_window_defogger", "is_brake_assist",
                        "is_power_door_locks", "is_central_locking", "is_power_steering",
                        "is_driver_seat_height_adjustable", "is_day_night_rear_view_mirror",
                        "is_ecw", "is_speed_alert")

# Loop through the columns and convert each one to numeric
for (col in columns_to_convert) {
  df.train_filter[[col]] <- as.numeric(df.train_filter[[col]])
}

############ Validate and split numerical and categorical columns ###############

# Identify numeric columns
numeric_cols <- sapply(df.train_filter, is.numeric)

# Select numerical columns
dataset_num_col <- names(df.train_filter)[numeric_cols]

# Display numerical column names
print("Data Set Numerical columns:")
print(length(dataset_num_col))  # Print the count of numerical columns
print(dataset_num_col)  # Print the names of numerical columns

# Identify categorical columns
categorical_cols <- sapply(df.train_filter, is.factor) | sapply(df.train_filter, is.character)

# Select categorical columns
dataset_cat_cols <- names(df.train_filter)[categorical_cols]

# Display categorical column names
print("Data Set categorical columns:")
print(length(dataset_cat_cols))  # Print the count of categorical columns
print(dataset_cat_cols)  # Print the names of categorical columns

#Finding the class of each variables so that we can identify categorical variable and create dummy variables
sapply(df.train_filter,class)

categorical_columns <- sapply(df.train_filter, is.character)

# List of column names that are categorical, excluding those starting with "is_"
cat_column_names <- names(df.train_filter)[categorical_columns]
cat_column_names <- cat_column_names[!(cat_column_names %in% is_cols)]
# Print the categorical column names
print(cat_column_names)

###################### Dummy variables #######################

# install.packages("fastDummies")
library(fastDummies)

# create dummy variables for the categorical variables
df.train_filter <- dummy_cols(df.train_filter, select_columns = cat_column_names, remove_selected_columns = TRUE)
View(df.train_filter)
extra_dummy<-c("area_cluster_C22","segment_Utility","model_M11","fuel_type_Petrol"
               ,"engine_type_K10C","rear_brakes_type_Drum","transmission_type_Manual","steering_type_Power")

filter1_extra_dummy<-(names(df.train_filter) %in% extra_dummy)

#removing the extra dummy variables from the data set
df.train_filter<-df.train_filter[,!filter1_extra_dummy]

################ Cleaning column name #############

library(rpart)
library(ROSE)
library(rpart) #used to construct decision tree means recursive partitioning  
library(rpart.plot)
library(caret)

# Replace spaces and periods with underscores in column names
names(df.train_filter) <- gsub(" ", "_", names(df.train_filter))
names(df.train_filter) <- gsub("\\.", "_", names(df.train_filter))
names(df.train_filter) <- gsub("-", "_", names(df.train_filter))

# Now the column names are sanitized
print(names(df.train_filter))

############### Splitting the data into Training and validating dataset ########

set.seed(1)  
train.index <- sample(c(1:dim(df.train_filter)[1]), dim(df.train_filter)[1]*0.6)  
train_dataset <- df.train_filter[train.index, ]
valid.dataset <- df.train_filter[-train.index, ]

###### Balance training dataset by oversampling imbalance data #####

balanced_data <- ovun.sample(as.factor(is_claim) ~ ., 
                             data = train_dataset, 
                             method = "over", 
                             N = 2 * table(train_dataset$is_claim)[1])$data

count_ones_in_column <- sum(balanced_data$is_claim == 1, na.rm = TRUE)
print(count_ones_in_column)

count_ones_in_column <- sum(balanced_data$is_claim == 0, na.rm = TRUE)
print(count_ones_in_column)

######### Claim Distribution after oversampling ############

# Calculate counts of 'No Claim' and 'Claim'
claim_counts_balance <- table(balanced_data$is_claim)

# Create a pie chart
pie(claim_counts_balance, labels = c('No Claim', 'Claim'), radius = 1, col = c('mediumaquamarine', 'peachpuff'),
    init.angle = 45, clockwise = TRUE, border = NA, cex = 1.5,
    main = 'Distribution of Claims After oversampling')

# The target variable has imbalance data and we will address this while building the model
# Add legend
legend("topright", c('No Claim', 'Claim'), fill = c('mediumaquamarine', 'peachpuff'), title = 'Outcome')


################# Model Training ###########################
############################################################
################# Random Forest ############################

library(randomForest)
library(pROC)

######Random Forest with 10 trees########
rf <- randomForest(as.factor(is_claim) ~ .,
                   data = balanced_data,  
                   ntree = 10,  
                   mtry = 10, 
                   nodesize = 5, 
                   importance = TRUE,
                   do.trace = 10,
                   randomForest.seed = 42) 
#variable imp plot
varImpPlot(rf, type = 1)

# Predict using the random forest model on training data
predictions <- predict(rf, balanced_data)

# Calculate the confusion matrix
# Replace 'data$y' with the actual target variable
conf_matrix <- confusionMatrix(predictions, as.factor(balanced_data$is_claim))  
# Print the confusion matrix
print(conf_matrix)

# Roc Curve
rf_probs <- predict(rf, balanced_data, type = "prob")[, 2]

# Replace 'data$target' with your actual target variable
rf_roc_curve <- roc(balanced_data$is_claim, rf_probs)  

# Print the AUC
auc_value <- auc(rf_roc_curve)
print(auc_value)

plot(rf_roc_curve, main = "ROC Curve for Random Forest")

########## Valid.dataset ###########

# Predict using the random forest model on vaidation data
predictions <- predict(rf, valid.dataset)


# Calculate the confusion matrix
# Replace 'data$y' with the actual target variable
conf_matrix <- confusionMatrix(predictions, as.factor(valid.dataset$is_claim))  

# Print the confusion matrix
print(conf_matrix)

# Roc Curve
rf_probs <- predict(rf, valid.dataset, type = "prob")[, 2]

# Replace 'data$target' with your actual target variable
rf_roc_curve <- roc(valid.dataset$is_claim, rf_probs)  

# Print the AUC
auc_value <- auc(rf_roc_curve)
print(auc_value)

plot(rf_roc_curve, main = "ROC Curve for Random Forest")

######### Random Forest with 100 trees ###########

rf <- randomForest(as.factor(is_claim) ~ .,
                   data = balanced_data,  
                   ntree = 100,  
                   mtry = 10, 
                   nodesize = 5, 
                   importance = TRUE,
                   do.trace = 10,
                   randomForest.seed = 42) 
#variable imp plot
varImpPlot(rf, type = 1)

# Predict using the random forest model on training data
predictions <- predict(rf, balanced_data)

# Calculate the confusion matrix
# Replace 'data$y' with the actual target variable
conf_matrix <- confusionMatrix(predictions, as.factor(balanced_data$is_claim))  
# Print the confusion matrix
print(conf_matrix)

# Roc Curve
rf_probs <- predict(rf, balanced_data, type = "prob")[, 2]

# Replace 'data$target' with your actual target variable
rf_roc_curve <- roc(balanced_data$is_claim, rf_probs)  

# Print the AUC
auc_value <- auc(rf_roc_curve)
print(auc_value)

plot(rf_roc_curve, main = "ROC Curve for Random Forest")

########## Valid.dataset ###########

# Predict using the random forest model on vaidation data
predictions <- predict(rf, valid.dataset)

# Calculate the confusion matrix
# Replace 'data$y' with the actual target variable
conf_matrix <- confusionMatrix(predictions, as.factor(valid.dataset$is_claim))  
# Print the confusion matrix
print(conf_matrix)

# Roc Curve
rf_probs <- predict(rf, valid.dataset, type = "prob")[, 2]

# Replace 'data$target' with your actual target variable
rf_roc_curve <- roc(valid.dataset$is_claim, rf_probs)  

# Print the AUC
auc_value <- auc(rf_roc_curve)
print(auc_value)

plot(rf_roc_curve, main = "ROC Curve for Random Forest")


######## Random Forest with 500 trees ########

rf <- randomForest(as.factor(is_claim) ~ .,
                   data = balanced_data,  
                   ntree = 500,  
                   mtry = 10, 
                   nodesize = 5, 
                   importance = TRUE,
                   do.trace = 10,
                   randomForest.seed = 42) 
#variable imp plot
varImpPlot(rf, type = 1)

# Predict using the random forest model on training data
predictions <- predict(rf, balanced_data)

# Calculate the confusion matrix
# Replace 'data$y' with the actual target variable
conf_matrix <- confusionMatrix(predictions, as.factor(balanced_data$is_claim))  
# Print the confusion matrix
print(conf_matrix)

# Roc Curve
rf_probs <- predict(rf, balanced_data, type = "prob")[, 2]

# Replace 'data$target' with your actual target variable
rf_roc_curve <- roc(balanced_data$is_claim, rf_probs)  

# Print the AUC
auc_value <- auc(rf_roc_curve)
print(auc_value)

plot(rf_roc_curve, main = "ROC Curve for Random Forest")

########## Valid.dataset ###########

# Predict using the random forest model on vaidation data
predictions <- predict(rf, valid.dataset)

# Calculate the confusion matrix
# Replace 'data$y' with the actual target variable
conf_matrix <- confusionMatrix(predictions, as.factor(valid.dataset$is_claim))  

# Print the confusion matrix
print(conf_matrix)

# Roc Curve
rf_probs <- predict(rf, valid.dataset, type = "prob")[, 2]

# Replace 'data$target' with your actual target variable
rf_roc_curve <- roc(valid.dataset$is_claim, rf_probs)  

# Print the AUC
auc_value <- auc(rf_roc_curve)
print(auc_value)

plot(rf_roc_curve, main = "ROC Curve for Random Forest")


#####################################################################
####################### LOGISTIC REGRESSION #########################

logit.reg <- glm(is_claim ~ ., data = balanced_data, family = "binomial") 
options(scipen=999)
summary(logit.reg)

# use predict() with type = "response" to compute predicted probabilities. 
logit.reg.pred <- predict(logit.reg, valid.dataset, type = "response")

data.frame(actual = valid.dataset$is_claim[1:5], predicted = logit.reg.pred[1:5])

logit.reg.pred.classes <- ifelse(logit.reg.pred > 0.5, 1, 0)
confusionMatrix(as.factor(logit.reg.pred.classes), as.factor(valid.dataset$is_claim))

#ROC
library(pROC)
r <- roc(valid.dataset$is_claim, logit.reg.pred)
plot.roc(r)

# compute auc
auc(r)

#####################################################################
######################## DECISION TREE ##############################

#training 
# classification tree
default.ct <- rpart(is_claim ~ ., data = balanced_data,method = "class")

# plot tree
prp(default.ct, type = 1, extra = 2, under = TRUE, split.font = 1, varlen = 10)
# count number of leaves
length(default.ct$frame$var[default.ct$frame$var == "<leaf>"])

# classification tree split using entropy
default.info.ct <- rpart(is_claim ~ ., data = balanced_data, parms = list(split = 'information'), method = "class")
prp(default.info.ct, type = 1, extra = 2, under = TRUE, split.font = 1, varlen = -10)
length(default.info.ct$frame$var[default.info.ct$frame$var == "<leaf>"])

deeper.ct <- rpart(is_claim ~ ., data = balanced_data, method = "class", cp = -1, minsplit = 1)
length(deeper.ct$frame$var[deeper.ct$frame$var == "<leaf>"])
prp(deeper.ct, type = 1, extra = 1, under = TRUE, split.font = 1, varlen = -10, 
    box.col=ifelse(deeper.ct$frame$var == "<leaf>", 'gray', 'white'))  

# classify records in the training data.
# set argument type = "class" in predict() to generate predicted class membership.
default.ct.point.pred.train <- predict(default.ct,balanced_data,type = "class")
# generate confusion matrix for training data
confusionMatrix(default.ct.point.pred.train, as.factor(balanced_data$is_claim))

deeper.ct.point.pred.train <- predict(deeper.ct,balanced_data,type = "class")
confusionMatrix(deeper.ct.point.pred.train, as.factor(balanced_data$is_claim))

cv.ct <- rpart(is_claim ~ ., data = balanced_data, method = "class", minsplit = 1, xval = 5)  # xval is number K of folds in a K-fold cross-validation.
printcp(cv.ct)  # Print out the cp table of cross-validation errors. The R-squared for a regression tree is 1 minus rel error. xerror (or relative cross-validation error where "x" stands for "cross") is a scaled version of overall average of the 5 out-of-sample errors across the 5 folds.

cv.ct <- rpart(is_claim ~ ., data = balanced_data, method = "class", cp = 0.00001, minsplit = 1, xval = 5)  # xval is number K of folds in a K-fold cross-validation.
printcp(cv.ct)  # Print out the cp table of cross-validation errors. The R-squared for a regression tree is 1 minus rel error. xerror (or relative cross-validation error where "x" stands for "cross") is a scaled version of overall average of the 5 out-of-sample errors across the 5 folds.
pruned.ct <- prune(cv.ct, cp = 0.010000) #this is the smallest cp value
printcp(pruned.ct)

prp(pruned.ct, type = 1, extra = 1, under = TRUE, split.font = 1, varlen = -10, 
    box.col=ifelse(pruned.ct$frame$var == "<leaf>", 'gray', 'white')) 

#ROC

library(pROC)
dt_probs <- predict(default.ct, balanced_data, type = "prob")[, 2]

dt_roc_curve <- roc(balanced_data$is_claim, dt_probs)  # Replace 'data$target' with your actual target variable

# Print the AUC
auc_value <- auc(dt_roc_curve)
print(auc_value)

plot(dt_roc_curve, main = "ROC Curve for decision tree")


#validation ROC 
# classify records in the validation data.
# set argument type = "class" in predict() to generate predicted class membership.
default.ct.point.pred.train <- predict(default.ct,valid.dataset,type = "class")
# generate confusion matrix for training data
confusionMatrix(default.ct.point.pred.train, as.factor(valid.dataset$is_claim))

library(pROC)
dt_probs <- predict(default.ct, valid.dataset, type = "prob")[, 2]

dt_roc_curve <- roc(valid.dataset$is_claim, dt_probs)  # Replace 'data$target' with your actual target variable

# Print the AUC
auc_value <- auc(dt_roc_curve)
print(auc_value)

plot(dt_roc_curve, main = "ROC Curve for decision tree")

#####################################################################
####################### NEURAL NETWORK ##############################

#install.packages('neuralnet',dependencies = T)
library(neuralnet)
#install.packages("pROC")
library(pROC)

# Create a formula using all columns except 'is_claim' as predictors
predictor_formula <- as.formula(paste("is_claim ~", paste(names(balanced_data)[!names(balanced_data) %in% "is_claim"], collapse = " + ")))

########### L2 regularization ###########

# Using the nnet package for neural network with L2 regularization
library(nnet)

# Builplot(roc_values, col = "blue", main = "ROC Curve")d the neural network model using all columns except 'is_claim' as predictors
neural_network_model_reg <- nnet(
  predictor_formula, 
  data = balanced_data, 
  size = 10, 
  linout = FALSE, 
  decay = 0.001  # Adjust decay parameter for L2 regularization
)

plot(neural_network_model_reg, rep="best")

neural_network_prediction_2 <- predict(neural_network_model_reg, valid.dataset, type = "raw")
neural_network_prediction_classes_2 <- ifelse(neural_network_prediction_2 > 0.5, 1, 0)
confusionMatrix(as.factor(neural_network_prediction_classes_2), as.factor(valid.dataset$is_claim))

# Assuming neural_network_prediction contains predicted probabilities
roc_values <- roc(valid.dataset$is_claim, neural_network_prediction_2)

# Plotting the ROC curve
plot(roc_values, col = "black", main = "ROC Curve")

auc(roc_values)

######### prunning ######

neural_network_model_reg <- nnet(
  predictor_formula, 
  data = balanced_data, 
  size = 10, 
  linout = FALSE, 
  decay = 0.001  # Adjust decay parameter for L2 regularization
)

neural_network_prediction_2 <- predict(neural_network_model_reg, valid.dataset, type = "raw")
neural_network_prediction_classes_2 <- ifelse(neural_network_prediction_2 > 0.5, 1, 0)
confusionMatrix(as.factor(neural_network_prediction_classes_2), as.factor(valid.dataset$is_claim))

# Assuming neural_network_prediction contains predicted probabilities
roc_values <- roc(valid.dataset$is_claim, neural_network_prediction_2)

# Plotting the ROC curve
plot(roc_values, col = "black", main = "ROC Curve")

auc(roc_values)


######### Ensembling ##############

#library(neuralnet)

# Function to train multiple neural networks
#train_multiple_nets <- function(num_networks, formula, data) {
 # neural_network_models <- list()
  #for (i in 1:num_networks) {
   # neural_network_models[[i]] <- neuralnet(
    #  formula, 
     # data = data, 
      #linear.output = FALSE, 
      #hidden = 5, 
      #learningrate = 0.1
    #)
  #}
  #return(neural_network_models)
#}

# Training multiple neural networks
#num_networks_to_train <- 5  # Define the number of neural networks to train
#ensemble_models <- train_multiple_nets(num_networks_to_train, predictor_formula, balanced_data)



