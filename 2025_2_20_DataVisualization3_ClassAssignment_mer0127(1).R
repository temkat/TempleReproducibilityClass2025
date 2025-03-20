##########################################################################################################################

#Author: Madeline Redd-Hamrick (Maddie) (mer0127)

#git config --global user.name 'Mads-Hamrick'
#git config --global user.email 'madeline.e.redd@gmail.com'

#2025 February 17

rm(list = ls(all=TRUE)) #Clears Environment to see if code can stand alone

#Class:ENTM 6820
#Assignment Name: Data Visualization 3 Class Assignment

##########################################################################################################################
#Import data from project
#Packages Needed for Code


install.packages("ggplot")
install.packages("tidyverse")
install.packages("ggrepel")
install.packages("ggpubr")
install.packages("lme4")
install.packages("emmeans")
install.packages("multcomp")


library(tidyverse) #version 2.0.0
library(ggpubr) #version 0.6.0
library(ggrepel)  #version 0.9.6
library(lme4) #version 1.1-35.5
library(emmeans)  #version 1.10.4
library(multcomp) #version 1.4-28
library(ggplot2) #version 3.5.1


#New Color Palette 

cbbPalette <- c( "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7","#000000")

##########################################################################################################################

Mycotoxin<- read.csv("MycotoxinData.csv", na.strings = "na")
head(Mycotoxin)

str(Mycotoxin)

##########################################################################################################################

##Question One

one<-  ggplot(Mycotoxin, aes(x=Treatment, y=DON,fill=Cultivar))+
  geom_boxplot(outlier.color= NA)+
  geom_point(pch=21, alpha = 0.6, color="black", position=position_jitterdodge(dodge.width=0.9))+

  xlab("")+
  ylab("DON (ppm)")+
  theme_classic()+
  
  scale_fill_manual(values=cbbPalette)+
  facet_wrap(~Cultivar)

one

##Question Two
#Change the factor order level so that the treatment “NTC” is first, followed by “Fg”, “Fg + 37”, “Fg + 40”, and “Fg + 70. 

Mycotoxin$Treatment <- factor(Mycotoxin$Treatment, levels = c("NTC", "Fg", "Fg + 37", "Fg + 40", "Fg + 70"))

order_change<- ggplot(Mycotoxin, aes(x=Treatment, y=DON,fill=Cultivar))+
  geom_boxplot(outlier.color= NA)+
  geom_point(pch=21, alpha = 0.6, color="black", position=position_jitterdodge(dodge.width=0.9))+
  
  xlab("")+
  ylab("DON (ppm)")+
  theme_classic()+
  
  scale_fill_manual(values=cbbPalette)+
  facet_wrap(~Cultivar)

order_change



##Question Three
#Change the y-variable to plot X15ADON and MassperSeed_mg. The y-axis label should now be “15ADON” and “Seed Mass (mg)”. 


threeA<- ggplot(Mycotoxin, aes(x=Treatment, y=MassperSeed_mg,fill=Cultivar))+
  geom_boxplot(outlier.color= NA)+
  geom_point(pch=21, alpha = 0.6, color="black", position=position_jitterdodge(dodge.width=0.9))+
  
  xlab("")+
  ylab("Seed Mass (mg)")+
  theme_classic()+
  
  scale_fill_manual(values=cbbPalette)+
  facet_wrap(~Cultivar)

threeA



threeB <- ggplot(Mycotoxin, aes(x=Treatment, y=X15ADON, fill=Cultivar))+
  geom_boxplot(outlier.color= NA)+
  geom_point(pch=21, alpha = 0.6, color="black", position=position_jitterdodge(dodge.width=0.9))+
  
  xlab("")+
  ylab("15ADON")+
  theme_classic()+
  
  scale_fill_manual(values=cbbPalette)+
  facet_wrap(~Cultivar)

threeB

##Question Four
#Use ggarrange function to combine all three figures into one with three columns and one row.
#Set the labels for the subplots as A, B and C.Use ggarrange function to combine all three figures 
#into one with three columns and one row. Set the labels for the subplots as A, B and C.

QuestionFour <- ggarrange(
  
  one,                      #Arrange multiple ggplot objects into a single figure
  threeA,  
  threeB,  
  
  labels = c("A", "B", "C"),               #Automatically adding labels to plots 
  nrow = 3, ncol = 1,            #Arrange the plots in 1 column, 3 rows
  
  common.legend = T  )

QuestionFour    #Calling plot to Plot pane


##Quesiton Five
#Use geom_pwc() to add t.test pairwise comparisons to the three plots made above. 
#Save each plot as a new R object, and combine them again with ggarange as you did in question 4. 

#DON with pairwise comparisons
plot1 <- ggplot(Mycotoxin, aes(x=Treatment, y=DON, fill=Cultivar)) +
  
  geom_boxplot(outlier.color=NA) +
  geom_point(pch=21, alpha=0.6, color="black", position=position_jitterdodge(dodge.width=0.9)) +
  geom_pwc(method = "t_test", label = "p.signif")+
  
  xlab("") +
  ylab("DON (ppm)") +
 
  theme_classic() +
  scale_fill_manual(values= cbbPalette) +
  facet_wrap(~Cultivar) 
  

plot1


#X15ADON with pairwise comparisons
plot2 <- ggplot(Mycotoxin, aes(x=Treatment, y=X15ADON, fill=Cultivar)) +
  geom_boxplot(outlier.color=NA) +
  geom_point(pch=21, alpha=0.6, color="black", position=position_jitterdodge(dodge.width=0.9)) +
  geom_pwc(method = "t_test", label = "p.signif", hide.ns = TRUE)+
  
  xlab("") +
  ylab("15ADON") +
  
  theme_classic() +
  scale_fill_manual(values=cbbPalette) +
  facet_wrap(~Cultivar) 
  

plot2


#MassperSeed_mg with pairwise comparisons
plot3 <- ggplot(Mycotoxin, aes(x=Treatment, y=MassperSeed_mg, fill=Cultivar)) +
  geom_boxplot(outlier.color=NA) +
  geom_point(pch=21, alpha=0.6, color="black", position=position_jitterdodge(dodge.width=0.9)) +
  geom_pwc(aes(group = Treatment) method = "t_test", label = "p.signif")+
  
  xlab("") +
  ylab("Seed Mass (mg)") +
  
  theme_classic() +
  scale_fill_manual(values=cbbPalette) +
  facet_wrap(~Cultivar) 
  

plot3


combined_plots <- ggarrange(plot1, plot2, plot3, 
                           ncol = 3, nrow = 1, 
                           labels = c("A", "B", "C"))

combined_plots













##########################################################################################################################
####OR###

ggplot(Mycotoxin, aes(x=Treatment)) +
  geom_boxplot(aes(y=X15ADON, fill=Cultivar), outlier.color=NA) +
  geom_point(aes(y=X15ADON, fill=Cultivar), pch=21, alpha=0.6, color="black", 
            position=position_jitterdodge(dodge.width=0.9)) +
  geom_line(aes(y=MassperSeed_mg/10, group=Cultivar, color=Cultivar), size=1) +  # Adjust the scale for secondary axis
  scale_y_continuous(
    name = "15ADON",
    sec.axis = sec_axis(~.*10, name = "Seed Mass (mg)")  # Adjust the scale for secondary axis
  ) +
  xlab("") +
  theme_classic() +
  scale_fill_manual(values=cbbPalette) +
  scale_color_manual(values=cbbPalette)





