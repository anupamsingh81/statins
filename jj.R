library(tidyverse)

mortality =read_csv('mortal2.csv')

mortality=mortality %>% filter(sex=="male") %>% select(-X1)


# Number of patients

n_patients=1000
# Choose whether to calculate for 'male' or 'female'
gender = 'male'

# Default value of 1 below will give calculations for a person with average risk. 2 isdouble risk, 0.5 is half risk, etc.


baseline_CVD_hazard_ratio=1


# Starting age, and effect size, of intervention. For example, a hazard reduction of0.3 means a hazard ratio of 0.7.
# Below the start age, patients never have the intervention. From the start ageonwards, each patient is "run" with one set of chance, twice - once withoutintervention (control) and once with (treated)

hazard_reduction=0.3
start_age_years= 85

max_age_years=150;
max_age_days=max_age_years*365;


day = c(1:max_age_days)

year=day/365
hazard_ratio_treated = 1 -hazard_reduction*(year>=start_age_years);

summary(hazard_ratio_treated)

row_number_in_mortality_table=floor(day/365 )


summary(row_number_in_mortality_table)


 row_number_in_mortality_table=  ifelse(row_number_in_mortality_table>139,139,row_number_in_mortality_table)
 
 
 summary(row_number_in_mortality_table)
 
summary(row_number_in_mortality_table)


df2 = data.frame(age=row_number_in_mortality_table,day,year_365=year)

df3=left_join(df2,mortality)

df4= df3 %>% 
  mutate(daily_ihd_mortality_UK_av=1-(1-ihd_mortality)**(1/365)) %>% 

mutate(daily_ihd_mortality= baseline_CVD_hazard_ratio*daily_ihd_mortality_UK_av) %>% 
  mutate(daily_non_ihd_mortality=1-(1-non_ihd_mortality)**(1/365))%>% 
  
mutate(p_death_daily_untreated= daily_non_ihd_mortality + daily_ihd_mortality) %>% 


mutate(p_death_daily_treated = daily_non_ihd_mortality +daily_ihd_mortality*hazard_ratio_treated)

options(scipen=999)

#summary(df4$p_death_daily_untreated)

#summary(df4$p_death_daily_treated)

#aa=df4$p_death_daily_untreated

#summary(df4$daily_ihd_mortality_UK_av)

#summary(df4$p_death_daily_treated)


#summary(mortality$ihd_mortality)

#options(scipen=999)

#summary(df4$daily_ihd_mortality)

#summary(df4$daily_ihd_mortality_UK_av)

df4=
df4 %>% 
  mutate(p_death_daily_treated=ifelse(day<=start_age_years*365,0,p_death_daily_treated) ) %>% 
  
  mutate(p_death_daily_untreated=ifelse(day<=start_age_years*365,0,p_death_daily_untreated) )

#summary(df4$p_death_daily_treated)
                
#set.seed(5)
#df4$dice=runif(max_age_days)  






#df4$fatal_dates_untreated = ifelse(df4$dice<df4$p_death_daily_untreated,TRUE,FALSE)

#df4$fatal_dates_treated = ifelse(df4$dice<df4$p_death_daily_treated,TRUE,FALSE)


#summary(df4$p_death_daily_untreated)

#summary(df4$p_death_daily_treated)

#summary(df4$fatal_dates_untreated)


#min(which(df4$fatal_dates_treated==TRUE))

#length(df4$day)

set.seed(1)
#runif(n=54750)

m =matrix(runif(n=max_age_days*n_patients), ncol=n_patients)

m1=as.data.frame(m)

days= function(x){
  a= ifelse(x<df4$p_death_daily_untreated,TRUE,FALSE)
  min(which(a==TRUE))
}

days1= function(x){
  a= ifelse(x<df4$p_death_daily_treated,TRUE,FALSE)
  min(which(a==TRUE))
}

control=m1 %>% map_dbl(~days(.))

treated=m1 %>% map_dbl(~days1(.))

extra= treated-control

percentage_benefit = (sum(extra>0)/n_patients)*100

percentage_benefit

Mean_benefit = mean(extra>0)

x= data_frame(control,treated,extra,age=start_age_years)
rm(m)
rm(m1)

df=bind_rows(df,x)

df6=df


fit=aov(extra~as.factor(age),data=df)

df %>% mutate(age=factor(age)) %>% group_by(age) %>% 
  summarise(mean=mean(extra),percentage_benefit = (sum(extra>0)/n_patients)*100,control=mean(control),treatment=mean(treated))

ggplot(df,aes(x=extra))+geom_histogram() +facet_wrap(~as.factor(age))


ggplot(df,aes(x=extra,y=factor(age)))+geom_boxplot() 

library(ggjoy)

ggplot(df,aes(x=extra,y=factor(age)))+geom_joy()

ggplot(df, aes(x = extra, y = factor(age), height = ..density..)) + 
  geom_joy(stat = "binline", bins = 20, scale = 0.95, draw_baseline = FALSE)

ggplot