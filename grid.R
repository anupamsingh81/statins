

rm(list =ls())

library(SyncRNG)
set.seed(123456,'user','user')


aa = read_csv('mortal2.csv')


df= data_frame(control_life_days=0,treated_life_days=0,extra=0,age=30,sex="male",risk=1)


library(tidyverse)


days= function(x){
  a= ifelse(x<df4$p_death_daily_untreated,TRUE,FALSE)
  min(which(a==TRUE))
}

days1= function(x){
  a= ifelse(x<df4$p_death_daily_treated,TRUE,FALSE)
  min(which(a==TRUE))
}


 
 lifespan = function(start_age_years,gender,baseline_CVD_hazard_ratio,max_age_years=150,hazard_reduction=0.3,n_patients=1000){
 
   library(SyncRNG)
   set.seed(123456,'user','user')
   
   mortality= aa %>% 
   filter(sex==gender) %>% 
   select(-X1) 
 
 max_age_days=max_age_years*365;
 
 day = c(1:max_age_days) # making a variable of all days
 
 year=day/365 # converting days to years
 hazard_ratio_treated = 1 -hazard_reduction*(year>=start_age_years) # hazard ratio of treated only starts from start age year
 
 row_number_in_mortality_table=floor(day/365 ) # row number denotes year
 
 
 row_number_in_mortality_table=  ifelse(row_number_in_mortality_table>139,139,row_number_in_mortality_table) 
 
 # maximum age in mortality table is 139, thus age from 139 to 150(max_age) expresses as 139
 
 
 
 df2 = data.frame(age=row_number_in_mortality_table,day,year_365=year) # making a data frame
 
 df3=left_join(df2,mortality)
 
 df5=df3%>% mutate(daily_ihd_mortality_UK_av=1-(1-ihd_mortality)**(1/365)) %>%  # converting yearly to daily mortality
   
   mutate(daily_ihd_mortality= baseline_CVD_hazard_ratio*daily_ihd_mortality_UK_av) %>% # daily IHD mortality will be a multiple of hazard
   mutate(daily_non_ihd_mortality=1-(1-non_ihd_mortality)**(1/365))%>%  # converting yearly non-ihd mortality to daily
   
   mutate(p_death_daily_untreated= daily_non_ihd_mortality + daily_ihd_mortality) %>% # probability of total mortality will be sum of IHD n non IHD mortality in untreated
   
   
   mutate(p_death_daily_treated = daily_non_ihd_mortality +daily_ihd_mortality*hazard_ratio_treated) %>% # probability of mortality in treated will be sum of non_ihd and ihd mortality reduced by hazard reduction
   mutate(p_death_daily_treated=ifelse(day<=start_age_years*365,0,p_death_daily_treated) ) %>% # probability of death in treated will be zero since start date
   
   mutate(p_death_daily_untreated=ifelse(day<=start_age_years*365,0,p_death_daily_untreated) ) # probability of death in untreated will be zero since start date
 
 assign("df4",df5,envir = .GlobalEnv)
 
 options(scipen=999) # removing scientific notation
 
 
 m =matrix(runif(n=max_age_days*n_patients), ncol=n_patients)
 
 m1=as.data.frame(m)
 
 control_life_days=m1 %>% map_dbl(~days(.))
 
 treated_life_days=m1 %>% map_dbl(~days1(.))
 
 

 x= data_frame(control_life_days,treated_life_days,age=start_age_years,sex=gender,risk=baseline_CVD_hazard_ratio) %>% mutate(extra=treated_life_days-control_life_days)
 rm(m)
 rm(m1)
 x
#x1= bind_rows(df,x)
#assign("df", x1, envir = .GlobalEnv) # assigning to global variable
 }
 
 age=c(35:85)
 risk = c(0.5,1,2)
 gender=c("male","female")
 
 kk=expand.grid(age,gender,risk) %>% rename(start_age_years=Var1,gender=Var2,baseline_CVD_hazard_ratio=Var3) %>% 
   mutate(gender=as.character(gender)) # important as otherwise will mistake character n factor
 
 str(kk)

jj= kk %>% pmap_df(lifespan)

jm = kk %>% pmap_df(lifespan)

rm(jk1)

ll = read.csv('summary.csv',stringsAsFactors = FALSE)

ll=ll %>% select(V4,V3,V2,V6,V5,V7)
vecnam = names(jk)
vecnam=vecnam[1:6]
names(ll)=vecnam

summary(ll)

lk1=ll %>% mutate(lifespangain=round(lifespangain*30,2),lifespangain_months=round(lifespangain/30,2)) %>% 
  mutate(lifespan_gain_in_beneficiary=round(lifespan_gain_in_beneficiary*30,2),lifespan_gain_in_beneficiary_months=round(lifespangain/30,2)) %>% 
  mutate(lifespan_gain_in_beneficiary_yrs=round(lifespan_gain_in_beneficiary/365,2)) %>% 
  mutate(risk=case_when(risk=="0.5"~"Low_risk",
                        risk=="1"~"Average_risk",
                        TRUE ~ "High_risk")) %>% 
  mutate(risk=factor(risk,levels = c("Low_risk","Average_risk","High_risk"))) %>% 
  mutate(risk_category=str_c(risk,sex,sep="_")) %>% 
  mutate(risk_category=fct_inorder(risk_category)) %>% 
  mutate(decade=fct_inorder(as.character(age%/%10 +1))) 

  
  

jk1=jm %>% group_by(age=as.factor(age),risk=as.factor(risk),sex=as.factor(sex)) %>% 
  summarise(lifespangain=mean(extra),percentage_benefit = (sum(extra>0)/1000)*100,
             lifespan_gain_in_beneficiary = sum(extra)/sum(extra>0)) %>%
  mutate(lifespan_gain_in_beneficiary_yrs=round(lifespan_gain_in_beneficiary/365,2)) %>% 

  ungroup() %>% # necessary because otherwise grouping vriable cant modify
  mutate(age=as.numeric(as.character(age))) %>% 
  mutate(risk=case_when(risk=="0.5"~"Low_risk",
                        risk=="1"~"Average_risk",
                        TRUE ~ "High_risk")) %>% 
  mutate(risk=factor(risk,levels = c("Low_risk","Average_risk","High_risk"))) %>% 
  mutate(risk_category=str_c(risk,sex,sep="_")) %>% 
  mutate(risk_category=fct_inorder(risk_category)) %>% 
  mutate(decade=fct_inorder(as.character(age%/%10 +1))) 
  
summary(jk)

# lifespan gain male vs female at same risk

lk1 %>%filter(risk=="Low_risk") %>%  ggplot(aes(x=age,y=lifespangain,group=as.factor(sex),color=as.factor(sex)))+geom_line()+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


# lifespangainmale at various level of risk
lk1 %>%filter(sex=="male") %>%  ggplot(aes(x=age,y=lifespangain,group=as.factor(risk),color=as.factor(risk)))+geom_line()+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


#  percentage benefit  age male
lk1 %>%filter(sex=="male") %>%  ggplot(aes(x=age,y=percentage_benefit,group=as.factor(risk),color=as.factor(risk)))+geom_line()+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

#  percentage benefit vs age female
lk1 %>%filter(sex=="female") %>%  ggplot(aes(x=age,y=percentage_benefit,group=as.factor(risk),color=as.factor(risk)))+geom_line()+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# lifespan gain in beneficiary age

lk1 %>%filter(sex=="male") %>%  ggplot(aes(x=age,y=lifespan_gain_in_beneficiary_yrs,group=as.factor(risk),color=as.factor(risk)))+geom_line()+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# map

lk1 %>% arrange(age) %>% View()

lk1  %>% split(.$risk) %>% map(~ggplot(data=.,aes(x=age,y=lifespan_gain_in_beneficiary_yrs,group=sex,color=sex))+geom_line()+
                                                             theme(axis.text.x = element_text(angle = 90, hjust = 1)))


lk1  %>% split(.$risk) %>% map(~ggplot(data=.,aes(x=age,y=percentage_benefit,group=sex,color=sex))+
                                stat_smooth(method = "loess", formula = y ~ x, size = 1,se=FALSE)   +  theme(axis.text.x = element_text(angle = 90, hjust = 1))) 


lk1  %>% split(.$risk) %>% map(~ggplot(data=.,aes(x=age,y=percentage_benefit,group=sex,color=sex))+
                                geom_line()  +  theme(axis.text.x = element_text(angle = 90, hjust = 1))) 

lk1 %>% ggplot(aes(x=age,y=percentage_benefit,group=sex,color=sex))+
             stat_smooth(method = "loess", formula = y ~ x, size = 1,se=FALSE)   +  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  facet_wrap(~risk,ncol=1)


lk1 %>% ggplot(aes(x=age,y=lifespan_gain_in_beneficiary_yrs,group=sex,color=sex))+
  stat_smooth(method = "loess", formula = y ~ x, size = 1,se=FALSE)   +  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  facet_wrap(~risk,ncol=1)


lk1 %>% ggplot(aes(x=age,y=lifespan_gain_in_beneficiary_yrs,group=sex,color=sex))+
  geom_line()   +  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  facet_wrap(~risk,ncol=1)

lk1 %>% ggplot(aes(x=age,y=percentage_benefit,group=sex,color=sex))+
  geom_line()   +  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  facet_wrap(~risk,ncol=1)


  
  levels(as.factor(jk$risk_category))

fct_inorder(jk$risk_category)

# Risk category_lifespan
lk1 %>% mutate(risk_category=fct_inorder(risk_category)) %>% 
ggplot(aes(x=age,y=lifespan_gain_in_beneficiary_yrs,group=risk_category,color=risk_category))+
  stat_smooth(method = "loess", formula = y ~ x, size = 1,se=FALSE)   +  
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) 


# Risk category_lifespan_boxplot
lk1 %>% mutate(risk_category=fct_inorder(risk_category)) %>% 
  ggplot(aes(x=risk_category,y=lifespan_gain_in_beneficiary_yrs,fill=risk_category))+
 geom_boxplot()+coord_flip()

library(ggjoy)

lk1 %>% mutate(risk_category=fct_inorder(risk_category)) %>% 
  ggplot(aes(y=risk_category,x=lifespan_gain_in_beneficiary_yrs,fill=risk_category))+
  geom_joy()

jk %>% mutate(decade=cut(age, breaks = seq(35,85,by=10), right = TRUE))

jk$age=as.numeric(jk$age)
cut_number(jk$age,10)
cut_width(jk$age,10)
cut_interval(jk$age,10)

# Risk category_lifespangain_average
lk1 %>% mutate(risk_category=fct_inorder(risk_category)) %>% 
  ggplot(aes(x=age,y=lifespangain,group=risk_category,color=risk_category))+
  stat_smooth(method = "loess", formula = y ~ x, size = 1,se=FALSE)   +  
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) 

# Good line plot annotate
lk1 %>% 
  ggplot(aes(x=age,y=lifespan_gain_in_beneficiary_yrs,group=risk_category,color=fct_reorder2(risk_category,age,lifespan_gain_in_beneficiary_yrs)))+
  stat_smooth(method = "loess", formula = y ~ x, size = 1,se=FALSE)   +  
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(color="Risk status")+
  annotate("text",x=70,y=9,label="good")

jk.labels <- data.frame(
  age =c(40, 60), 
  lifespangain=c(300, 390), 
  label = c("Average risk male", "High risk male"), 
  risk_category= c("Average_risk_male", "High_risk_male")
)

library(ggrepel)
jk.labels2=jk %>% group_by(risk_category) %>% summarise(age=mean(age),lifespangain=max(lifespangain))

lk1 %>% 
  ggplot(aes(x=age,y=lifespangain,group=risk_category,color=fct_reorder2(risk_category,age,lifespangain)))+
  stat_smooth(method = "loess", formula = y ~ x, size = 1,se=FALSE)   +  
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(color="Risk status")+
  #geom_label_repel(data=jk.labels,aes(x=age,y=lifespangain,label=label))
  geom_label_repel(data=jk.labels2,aes(x=age,y=lifespangain,label=risk_category))
  


# Risk category_percentage
lk1 %>% mutate(risk_category=fct_inorder(risk_category)) %>% 
  ggplot(aes(x=age,y=percentage_benefit,group=risk_category,color=risk_category))+
  stat_smooth(method = "loess", formula = y ~ x, size = 1,se=FALSE)   +  
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) 

lk1 %>% 
  ggplot(aes(x=age,y=percentage_benefit,group=risk_category,color=fct_reorder2(risk_category,age,percentage_benefit)))+
  stat_smooth(method = "loess", formula = y ~ x, size = 1,se=FALSE)   +  
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) 


##3risk category splot
lk1 %>% split(.$risk_category) %>% 
  map(~ggplot(data=.,aes(x=lifespan_gain_in_beneficiary_yrs,y=percentage_benefit))+
  stat_smooth(method = "loess", formula = y ~ x, size = 1,se=FALSE)   +  
  theme(axis.text.x = element_text(angle = 90, hjust = 1)))

lk1 %>% ggplot(aes(x=lifespan_gain_in_beneficiary_yrs,y=percentage_benefit))+
  stat_smooth(method = "loess", formula = y ~ x, size = 1,se=FALSE)   +  
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  geom_point(aes(color=decade))+
  facet_wrap(~risk_category,nrow=3)

lk1 %>% ggplot(aes(x=decade,y=lifespangain))+
  stat_smooth(method = "loess", formula = y ~ x, size = 1,se=FALSE)   +  
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  geom_boxplot()+
  facet_wrap(~risk_category,nrow=3)
  

lk1 %>% ggplot(aes(x=decade,y=lifespan_gain_in_beneficiary_yrs))+
  stat_smooth(method = "loess", formula = y ~ x, size = 1,se=FALSE)   +  
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  geom_boxplot()+
  facet_wrap(~risk_category,nrow=3)


# decade percentage
lk1 %>% mutate(decade=fct_inorder(as.character(age%/%10))) %>% 
  ggplot(aes(x=decade,y=percentage_benefit,fill=decade))+
  geom_boxplot()

# decade lifespan
lk1 %>% mutate(decade=fct_inorder(as.character(age%/%10))) %>% 
  ggplot(aes(x=decade,y=lifespan_gain_in_beneficiary_yrs,fill=decade))+
  geom_boxplot()

lk1 %>% mutate(decade=fct_inorder(as.character(age%/%10))) %>% 
  ggplot(aes(x=lifespan_gain_in_beneficiary_yrs,color=decade))+
  geom_freqpoly(binwidth=0.5)






library(ggthemes)


jk %>% ggplot(aes(x=age,y=percentage_benefit,group=sex,color=sex))+
  geom_line()   +  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  facet_wrap(~risk,nrow=3)+ #theme_economist()
  theme_solarized()

library(latticeExtra)

jk %>% filter(sex=="male") %>% 
  cloud(lifespan_gain_in_beneficiary_yrs~age+risk, data=subset(jk,sex=="male"),panel.3d.cloud=panel.3dbars, col.facet='grey', 
        xbase=0.3, ybase=0.3, scales=list(arrows=FALSE, col=1), 
        par.settings = list(axis.line = list(col = "transparent")))

cloud(lifespangain~age+risk, data=subset(jk,sex=="male"),panel.3d.cloud=panel.3dbars, col.facet='grey', 
      xbase=0.3, ybase=0.3, scales=list(arrows=FALSE, col=1), 
      par.settings = list(axis.line = list(col = "transparent")))


cloud(lifespangain~age+sex, data=jk,panel.3d.cloud=panel.3dbars, col.facet='grey', 
      xbase=0.3, ybase=0.3, scales=list(arrows=FALSE, col=1), 
      par.settings = list(axis.line = list(col = "transparent")))









glimpse(jk)

write.csv(jk,"lifespan.csv")


###########plots############33333

jk %>%filter(risk==1) %>% ggplot(aes(percentage_benefit,lifespangain,color=sex,group=sex))+geom_line()



############33


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

max_age_years=150
max_age_days=max_age_years*365


###

summary(lm(jk$lifespan_gain_in_beneficiary_yrs~jk$age+jk$percentage_benefit,data=jk))

