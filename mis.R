
library(tidyverse)

mm=read_csv('mortal2.csv') %>% 
  filter(sex==gender) %>% 
  select(-X1) %>% 
  write_csv("mortal.csv")

kk=read_csv('mortal.csv')


lifespan1 = function(start_age_years,gender,baseline_CVD_hazard_ratio,max_age_years=150,hazard_reduction=0.3,n_patients=1000){
 
  
  mortality= read_csv('mortal.csv') %>% 
    filter(sex==gender) 
    
  
  max_age_days=max_age_years*365;
  
  day = c(1:max_age_days) # making a variable of all days
  
  year=day/365 # converting days to years
  hazard_ratio_treated = 1 -hazard_reduction*(year>=start_age_years) # hazard ratio of treated only starts from start age year
  
  row_number_in_mortality_table=floor(day/365 ) # row number denotes year
  
  
  row_number_in_mortality_table=  ifelse(row_number_in_mortality_table>139,139,row_number_in_mortality_table) 
  
  # maximum age in mortality table is 139, thus age from 139 to 150(max_age) expresses as 139
  
  
  
  df2 = data.frame(age=row_number_in_mortality_table,day,year_365=year) # making a data frame
  
  df3=left_join(df2,mortality)
  
  daily_ihd_mortality_UK_av=1-(1-df3$ihd_mortality)**(1/365) # converting yearly to daily mortality
    
    daily_ihd_mortality= baseline_CVD_hazard_ratio*daily_ihd_mortality_UK_av # daily IHD mortality will be a multiple of hazard
    daily_non_ihd_mortality=1-(1-df3$non_ihd_mortality)**(1/365)# converting yearly non-ihd mortality to daily
    
    p_death_daily_untreated= daily_non_ihd_mortality + daily_ihd_mortality# probability of total mortality will be sum of IHD n non IHD mortality in untreated
    
    
    p_death_daily_treated = daily_non_ihd_mortality +daily_ihd_mortality*hazard_ratio_treated # probability of mortality in treated will be sum of non_ihd and ihd mortality reduced by hazard reduction
    p_death_daily_treated=ifelse(day<=start_age_years*365,0,p_death_daily_treated) # probability of death in treated will be zero since start date
    
    p_death_daily_untreated=ifelse(day<=start_age_years*365,0,p_death_daily_untreated) # probability of death in untreated will be zero since start date
  
  days= function(x){
    a= ifelse(x<p_death_daily_untreated,TRUE,FALSE)
    min(which(a==TRUE))
  }
  
  days1= function(x){
    a= ifelse(x<p_death_daily_treated,TRUE,FALSE)
    min(which(a==TRUE))
  }

  options(scipen=999) # removing scientific notation
  
  set.seed(1)
  
  m =matrix(runif(n=max_age_days*n_patients), ncol=n_patients)
  
  m1=as.data.frame(m)
  
  control_life_days=m1 %>% map_dbl(~days(.))
  
  treated_life_days=m1 %>% map_dbl(~days1(.))
  
  rm(m)
  rm(m1)
  
  extra=treated_life_days-control_life_days
  
  x1 = paste('The mean lifespan gain in beneficiaries is',mean(extra),' days.The percentage of those benefitting is ',(sum(extra>0)/n_patients)*100,
  ' . The life span gain in these beneficiaries is',round((sum(extra)/sum(extra>0))/365,2), ' years.',sep =" ")
  

x1
}

lifespan1(start_age_years = 80,baseline_CVD_hazard_ratio = 2,gender="male")

lifespan1(start_age_years = 80,baseline_CVD_hazard_ratio = 0.5,gender="female")

lifespan1(start_age_years = 80,baseline_CVD_hazard_ratio = 0.5,gender="female")

ky=lifespan(start_age_years = 80,baseline_CVD_hazard_ratio = 0.5,gender="female")

mean(ky$extra)



