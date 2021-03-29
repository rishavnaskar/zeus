# zeus

In current pandemic situation it is very important to be carefull while we go ouside and continue our day to day work. After the lockdown was lifted the number of cases shot up, just because people were not careful enough. It is very important to wear mask and sanitize our hands time to time in order to be safe. Zeus helps us in doing so. The alarm feature of the app reminds us to wear the mask and use sanitizer every 30 mins when we are more than 100m away from our home. We can check on the mask and the sanitizer prompt so that the app will understand that we are currently equiped with the above items.

The help section can be used by the user to chat with users in the vicinity of 20 km radius and the send coordinates option can be used to share the current location in case of need. It also has a privacy setting option which the user can use to select if he/she is okay with sharing the information. 

We have also added prediction feature which can predict the number of deaths,cases and recovery per day. They are represented through graphs Screenshots given below. It uses various machine learning models like XGBOOST, AutoReg for time series prediction. We have used https://api.covid19india.org/data.json for getting the data. this prediction could help people of India to know the predictions for next 10 days and could be really helpful for research purposes and to take take good care of themselves

We used Firebase for authentication and Cloud Firesotre as our database.

### For Video Description
Vimeo Link: https://vimeo.com/490350961

### Link For App
https://drive.google.com/file/d/1SwIoz0moLKN5wIVmDOYA8gTxrf-V6om5/view?usp=sharing

## Screenshots for App Features

![NewApp1](https://user-images.githubusercontent.com/61358568/102008041-b0a33d00-3d53-11eb-84e9-669317100798.jpeg)

![NewApp7](https://user-images.githubusercontent.com/61358568/102008132-58b90600-3d54-11eb-83c5-29dc323cbfe5.jpeg)

![NewApp6](https://user-images.githubusercontent.com/61358568/102008134-59ea3300-3d54-11eb-937b-3b2d0172b021.jpeg)

![NewApp8](https://user-images.githubusercontent.com/61358568/102008333-9b2f1280-3d55-11eb-9ee7-9c35cba11f7d.jpeg)



## Screenshots for prediction center

![NewApp4](https://user-images.githubusercontent.com/61358568/102008107-1b547880-3d54-11eb-8a6e-8ab62199ab7c.jpeg)

![NewApp5](https://user-images.githubusercontent.com/61358568/102008109-1c85a580-3d54-11eb-8e13-a26692cbf42f.jpeg)

![NewApp3](https://user-images.githubusercontent.com/61358568/102008111-1d1e3c00-3d54-11eb-8758-db16537ea42f.jpeg)

Note: (Here the blue line indicate the trruth values of deaths, prediction and cases per day and yellow represent the predicted graphs)

***We Have made our own Flask Api for prediction and flutter for making the app***

***Various Machine Learning models like AutoReg and XGBOOST have been used for making Time Series Prediction***


