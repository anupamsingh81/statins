
# Survival and other plots
library(tidyverse)

n_patients=100

m =matrix(runif(n=max_age_days*n_patients), ncol=n_patients)

m1=as.data.frame(m)

dan= function(x){
  a= ifelse(x>df4$p_death_daily_untreated,"DEAD","ALIVE")
  a
}

da= function(x){
  a= ifelse(x>df4$p_death_daily_treated,"DEAD","ALIVE")
  a
}

muntreat = m1 %>% map_df(~dan(.))%>% mutate(class= "placebo")


mtreat = m1 %>% map_df(~da(.))%>% mutate(class= "treatment")



mfinal = bind_rows(mtreat,muntreat)

mfinal=mfinal %>% mutate(day=c(c(1:54750),c(1:54750)))


rm(muntreat)
rm(mtreat)
rm(m)
rm(m1)

mfinal1=mfinal %>% gather(patient,status,V1:V100)

mtr=mfinal1 %>% filter(class=="treatment")

summary(as.factor(mtr$status))

mpl=mfinal1 %>% filter(class=="placebo")

summary(as.factor(mpl$status))

rm(mfinal)
rm(mfinal1)
rm(mpl)
rm(mtr)

mfinal1=mfinal1 %>% mutate(status=ifelse(status=="ALIVE",0,1))

mfinal1$year = mfinal1$day%/%365

rm(mfinal)
mtreat = mfinal1 %>% filter(class=="treatment") %>% filter(day>365*50)
########3

library(survminer)

library(survival)

km <- with(mtreat, Surv(day, status))

km_fit <- survfit(Surv(year, status) ~ class, data=mfinal1)

summary(km_fit,times = c(50:90))

survdiff(Surv(year, status) ~ class, data=mfinal1)


rm(mpl)

rm(mtr)


