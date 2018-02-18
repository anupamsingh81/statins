rownames(jk$risk_category)

best_in_class <- mpg %>%
  group_by(class) %>%
  filter(row_number(desc(hwy)) == 1)

jk1=jk %>% group_by(decade) %>% 
  summarise(lifespan_gain_in_beneficiary_yrs=mean(lifespan_gain_in_beneficiary_yrs))

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_text(aes(label = model), data = best_in_class)

library(ggrepel)
class_avg <- jk %>%
  group_by(risk_category) %>%
  summarise(
    age = median(age),
    lifespan_gain_in_beneficiary_yrs = median(lifespan_gain_in_beneficiary_yrs)
  )

  ###############333

data2 <- structure(list(type = structure(c(5L, 1L, 2L, 4L, 3L, 5L, 1L, 
                                           2L, 4L, 3L, 5L, 1L, 2L, 4L, 3L, 5L, 1L, 2L, 4L, 3L), .Label = c("EDS", 
                                                                                                           "KIU", "LAK", "MVH", "NA*"), class = "factor"), value = c(0.9, 
                                                                                                                                                                     0.01, 0.01, 0.09, 0, 0.8, 0.05, 0, 0.15, 0, 0.41, 0.04, 0.03, 
                                                                                                                                                                     0.52, 0, 0.23, 0.11, 0.02, 0.64, 0.01), time = c(3L, 3L, 3L, 
                                                                                                                                                                                                                      3L, 3L, 6L, 6L, 6L, 6L, 6L, 15L, 15L, 15L, 15L, 15L, 27L, 27L, 
                                                                                                                                                                                                                      27L, 27L, 27L), year = c(2008L, 2008L, 2008L, 2008L, 2008L, 2007L, 
                                                                                                                                                                                                                                               2007L, 2007L, 2007L, 2007L, 2007L, 2007L, 2007L, 2007L, 2007L, 
                                                                                                                                                                                                                                               2006L, 2006L, 2006L, 2006L, 2006L)), .Names = c("type", "value", 
                                                                                                                                                                                                                                                                                               "time", "year"), row.names = c(1L, 3L, 4L, 5L, 6L, 7L, 9L, 10L, 
                                                                                                                                                                                                                                                                                                                              11L, 12L, 13L, 15L, 16L, 17L, 18L, 19L, 21L, 22L, 23L, 24L), class = "data.frame")                                                                                                                                                                                                                                                                                                                       11L, 12L, 13L, 15L, 16L, 17L, 18L, 19L, 21L, 22L, 23L, 24L), class = "data.frame")
ggplot(data2, aes(x=time, y=value, group=type, col=type))+
  geom_line()+
  geom_point()+
  theme_bw()+
  annotate("text", x=6, y=0.9, label="this is a wrong color")+
  annotate("text", x=15, y=0.6, label="this is a second annotation with a wrong color")

# Better way

data2.labels <- data.frame(
  time = c(7, 15), 
  value = c(.9, .6), 
  label = c("correct color", "another correct color!"), 
  type = c("NA*", "MVH")
)

ggplot(data2, aes(x=time, y=value, group=type, col=type))+
  geom_line()+
  geom_point()+
  theme_bw() +
  geom_text(data = data2.labels, aes(x = time, y = value, label = label))