
rm(list=ls()) # clear all

# Number of patients

n_patients=1000
# Choose whether to calculate for 'male' or 'female'
gender = 'female'

# Default value of 1 below will give calculations for a person with average risk. 2 isdouble risk, 0.5 is half risk, etc.


baseline_CVD_hazard_ratio=0.5


# Starting age, and effect size, of intervention. For example, a hazard reduction of0.3 means a hazard ratio of 0.7.
# Below the start age, patients never have the intervention. From the start ageonwards, each patient is "run" with one set of chance, twice - once withoutintervention (control) and once with (treated)

hazard_reduction=0.3
start_age_years= 80

max_age_years=150
max_age_days=max_age_years*365


write.table(mortal,"mort.txt")

mortal= read.csv('https://raw.githubusercontent.com/anupamsingh81/statins/master/mortal2.csv') 
mort= subset(mortal,sex==gender)


day = c(1:max_age_days) # making a variable of all days

year=day/365 # converting days to years
hazard_ratio_treated = 1 -hazard_reduction*(year>=start_age_years) # hazard ratio of treated only starts from start age year

row_number_in_mortality_table=floor(day/365 ) # row number denotes year


row_number_in_mortality_table=  ifelse(row_number_in_mortality_table>139,139,row_number_in_mortality_table) 

ihd_mortality= c(rep(mort$ihd_mortality,each=365),rep(mort$ihd_mortality[140],10*365)) # repeating ihd mortality year corresponding to days


non_ihd_mortality= c(rep(mort$non_ihd_mortality,each=365),rep(mort$non_ihd_mortality[140],10*365))


# maximum age in mortality table is 139, thus age from 139 to 150(max_age) expresses as 139




daily_ihd_mortality_UK_av=1-(1-ihd_mortality)**(1/365) # converting yearly to daily mortality

daily_ihd_mortality= baseline_CVD_hazard_ratio*daily_ihd_mortality_UK_av # daily IHD mortality will be a multiple of hazard
daily_non_ihd_mortality=1-(1-non_ihd_mortality)**(1/365)# converting yearly non-ihd mortality to daily

p_death_daily_untreated= daily_non_ihd_mortality + daily_ihd_mortality# probability of total mortality will be sum of IHD n non IHD mortality in untreated


p_death_daily_treated = daily_non_ihd_mortality +daily_ihd_mortality*hazard_ratio_treated # probability of mortality in treated will be sum of non_ihd and ihd mortality reduced by hazard reduction
p_death_daily_treated=ifelse(day<=start_age_years*365,0,p_death_daily_treated) # probability of death in treated will be zero since start date

p_death_daily_untreated=ifelse(day<=start_age_years*365,0,p_death_daily_untreated) # probability of death in untreated will be zero since start date

days= function(x){
  a= ifelse(x<p_death_daily_untreated,TRUE,FALSE)
  min(which(a==TRUE)) # first day on which true(death) is detected 
}

days1= function(x){
  a= ifelse(x<p_death_daily_treated,TRUE,FALSE)
  min(which(a==TRUE))  
}

options(scipen=999) # removing scientific notation

set.seed(1)

m =matrix(runif(n=max_age_days*n_patients), ncol=n_patients) # generating a random matrix of values between 0 and 1 which follow a uniform distribution


control_life_days=apply(m,2,days) # applying function to each row of matrix of 1000 columns9patients) and 54750 days(rows)
treated_life_days=apply(m,2,days1) 
rm(m)


extra=treated_life_days-control_life_days

x1 = paste('The mean lifespan gain in beneficiaries is',mean(extra),' days.The percentage of those benefitting is ',(sum(extra>0)/n_patients)*100,
           ' percent. The life span gain in these beneficiaries is',round((sum(extra)/sum(extra>0))/365,2), ' years.',sep =" ")


x1