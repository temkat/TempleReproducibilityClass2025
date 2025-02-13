library(ggplot2)

myco<-read.csv("MycotoxinData.csv", na.string="na")
myco$BioRep<-as.factor #since this is category

str(myco)

#Question 2
ggplot(myco, aes(x=Treatment, y=DON, color=Cultivar))+
  geom_boxplot()+
  xlab("")+
  ylab("DON (ppm)")
  
#Question 3
#convert this data into a bar chart with standard-error error bars using the 
#stat_summary() command.
ggplot(myco, aes(x=Treatment, y=DON, color=Cultivar))+
  stat_summary(fun=mean, geom="bar", position="dodge")+
  stat_summary(fun.data = mean_se, geom = "errorbar", position="dodge")+
  xlab("")+
  ylab("DON (ppm)")

#Question 4
#Add points to the foreground of the boxplot and bar chart you made in question 3 
#that show the distribution of points over the boxplots. 
#Set the shape = 21 and the outline color black (hint: use jitter_dodge)

#bar chart
ggplot(myco, aes(x=Treatment, y=DON,fill=Cultivar))+
  stat_summary(fun=mean, geom="bar", position="dodge")+
  stat_summary(fun.data = mean_se, geom = "errorbar", position="dodge")+
  xlab("")+
  ylab("DON (ppm)")+
  geom_point(pch=21, color="black", position=position_jitterdodge(dodge.width=0.9))

#boxplot
ggplot(myco, aes(x=Treatment, y=DON, fill=Cultivar))+
  geom_boxplot(outlier.color= NA)+
  geom_point(pch=21, color="black", position=position_jitterdodge())+
  xlab("")+
  ylab("DON (ppm)")

#Question 5 
#Change the fill color of the points and boxplots to match some colors in the 
#following colorblind pallet. 

cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2",
                "#D55E00", "#CC79A7")
colorchoice<-c( "#009E73","#CC79A7")
#boxplot
ggplot(myco, aes(x=Treatment, y=DON, fill=Cultivar))+
  geom_boxplot(outlier.color= NA)+
  geom_point(pch=21, position=position_jitterdodge())+
  scale_fill_manual(values=colorchoice)+
  xlab("")+
  ylab("DON (ppm)")

#Question 6 Add a facet to the plots based on cultivar.

#Box
ggplot(myco, aes(x=Treatment, y=DON, fill=Cultivar))+
  geom_boxplot(outlier.color= NA)+
  geom_point(pch=21, position=position_jitterdodge())+
  scale_fill_manual(values=colorchoice)+
  xlab("")+
  ylab("DON (ppm)")+
  facet_wrap(~Cultivar)

ggplot(myco, aes(x=Treatment, y=DON,fill=Cultivar))+
  stat_summary(fun=mean, geom="bar", position="dodge")+
  stat_summary(fun.data = mean_se, geom = "errorbar", position="dodge")+
  xlab("")+
  ylab("DON (ppm)")+
  geom_point(pch=21, color="black", position=position_jitterdodge(dodge.width=0.9))+
  facet_wrap(~Cultivar)

#Add transparency to the points so you can still see the boxplot or bar 
#in the background.  
ggplot(myco, aes(x=Treatment, y=DON, fill=Cultivar))+
  geom_boxplot(outlier.color= NA)+
  geom_point(pch=21, alpha=0.4, position=position_jitterdodge())+  #transparancy is 0-1 (.5=5)
  scale_fill_manual(values=colorchoice)+
  xlab("")+
  ylab("DON (ppm)")+
  facet_wrap(~Cultivar)
#Explore one other way to represent the same data https://ggplot2.tidyverse.org/reference/ . 
#Plot them and show the code here. 
#Which one would you choose to represent your data and why? 

#Dot plot
ggplot(myco, aes(x=Treatment, y=DON, fill=Cultivar))+
  geom_dotplot(binaxis="y", binwidth = 10, method = "histodot",
               position=position_jitterdodge())+
  scale_fill_manual(values=colorchoice)+
  xlab("Treatment Type")+
  ylab("DON (ppm)")+
  facet_wrap(~Cultivar)

#For the data we would choose a boxplot as it is a cleaner set of data that appears
#to be more conventional for this type of analysis. The boxplot with the points shows where the 
#outliers are as well as the majority fall if the points are placed in the layer.