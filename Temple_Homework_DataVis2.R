#Katie (Kathryn) Temple
#Homework: Data visualization 2 coding notes
#17FEB2025
#ENTM6820, SPRING 2025

install.packages("ggpubr")
install.packages("ggrepel")

library(tidyverse)
library(ggpubr)
library(ggrepel)

#example paper: https://journals.asm.org/doi/10.1128/spectrum.00377-23
#associated GitHub: https://github.com/Noel-Lab-Auburn/SpermosphereMicrobiome2022/tree/main

#General figure advice: consistent fonts, color pallets, each figure or sub figure
#This includes consistently using the same color across figures for each variable
#(for example in own work control would always be the same color across all figures as would trap)
#tells one point/demonstrates one aspect
#use the colorblind friendly color pallet, default font is Arial
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")


#Stitching multiple plots together 
sample.data.bac<-read.csv("BacterialAlpha.csv", na.strings= "na")
sample.data.bac$Time_Point<-as.factor(sample.data.bac$Time_Point)
sample.data.bac$Crop<-as.factor(sample.data.bac$Crop)
sample.data.bac$Crop<-factor(sample.data.bac$Crop, ,levels = c("Soil", "Cotton", "Soybean"))
str(sample.data.bac)

#Figure B rep. Bacterial Evenness. Time on x, Evenness on y  #NOTE TO SELF TO REFER BACK
bac.even<-ggplot(sample.data.bac, aes(x=Time_Point, y=even, color=Crop))+ #define aesthetics
  geom_boxplot(position=position_dodge(0.85))+ #Adding boxplots with dodged positions to avoid overlap
  geom_point(position=position_jitterdodge(0.5))+ #jitter added to show individual data points. 
  #dodge portion avoids overlap
  ylab("Pielou's evenness")+ #label for y-axis
  xlab("Hours post sowing")+ #label for x-axis
  scale_color_manual(values=cbbPalette, name="", labels=c("Soil no seeds", 
                     "Cotton spermosphere", "Soybean spermosphere"))+ #manually add color labels
                    #for crop variables
  theme_classic() #uses a classic theme for the plot
bac.even #check the plot


#FIGURE 2B,Water Inbibition correlate with bacterial evenness#
sample.data.bac.nosoil<-subset(sample.data.bac, Crop !="Soil")

water.imbibed<-ggplot (sample.data.bac.nosoil, aes(Time_Point, 1000*Water_Imbibed, color=Crop))+
  #above defines aes. y-axis as Water_Imbimbed (converted to mg), and color by crop
  geom_jitter(width=0.5, alpha=0.5)+ #Adds jittered points to show indiviudal points with some transparancey (alpha)
  stat_summary(fun=mean, geom="line", aes (group=Crop))+ #Adds lines representing the mean 
  #value for each Crop group
  stat_summary(fun.data=mean_se, geom="errorbar", width=0.5)+ #Adds error bars representing the standard error of the mean
  xlab("Hours post sowing")+
  ylab("Water Imbibed (mg)")+
  scale_color_manual(values=c(cbbPalette[[2]], cbbPalette[[3]]), name="", labels=c("", ""))+
  #manually sets the colors for the Crop variable
  theme_classic()+#uses classic theme for the plot
  theme(strip.background=element_blank(), legend.position="none")+ 
  #customizes theme: remove strip background and position legend to the right
  facet_wrap(~Crop, scales="free") #creates seperate panels for each Crop, allowing free scales
water.imbibed #check plot


#Figure 2C caption from instructions in quotes
#"Figure C This code creates a ggplot object water.imbibed.cor using the na.omit(sample.data.bac) dataset. 
#It plots even on the y-axis and Water_Imbibed (converted to mg) on the x-axis, with different colors for each Crop category. 
#The plot includes points with different shapes based on Time.Point, a linear model smooth line without confidence interval shading, 
#and manually set colors and shapes for the Crop and Time.Point variables, respectively. The x-axis is labeled “Water Imbibed (mg),” 
#and the y-axis is labeled “Pielou’s evenness.” The plot uses a classic theme with the color legend removed and the legend positioned to the right. 
#Separate panels are created for each Crop, allowing free scales."

#Generating Figure 2C#
water.imbibed.cor<-ggplot(sample.data.bac.nosoil, aes(y=even, x=1000*Water_Imbibed, color=Crop))+
  #Define aesthetics (aes): y-axis as even, x-axis as Water_Imbibned AND converted to mg, color by Crop
  geom_point(aes(shape=Time_Point))+ #adds points with different shapes based on Time.Point
  geom_smooth(se=FALSE, method=lm)+ #adds a linear model without confidence interval shading!
  xlab("Water Imbibed (mg)")+
  ylab("Pielou's evenness")+
  scale_color_manual(values= c(cbbPalette [[2]], cbbPalette[[3]]), name="", labels=c("Cotton", "Soybean"))+  #Manually sets color for crop variable
  scale_shape_manual(values= c(15, 16, 17, 18), name="", labels=c("0 hrs", "6 hrs", "12 hrs", "18 hrs"))+ #manually sets color for Time.Point variable
  theme_classic()+ #Uses a classic theme for the plot
  theme(strip.background=element_blank(), legend.position="none")+
  facet_wrap(~Crop, scales="free") #creates separate panels for each crop, allowing for free scales
  
water.imbibed.cor #check
## `geom_smooth()` using formula = 'y ~ x'

####Final Figure####
#Description directly from homework instructions
#"This code uses the ggarrange function from the ggpubr package to arrange three ggplot objects (water.imbibed, bac.even, and water.imbibed.cor) 
#into a single figure. The plots are arranged in 3 rows and 1 column, with automatic labeling (A, B, C, etc.). The combined figure does not include a legend."

#Figure 2; significance levels added with Adobe or PowerPoint#
#arrange multiple ggplots into a single figure
figure2<-ggarrange(
  water.imbibed, #first plkot: water.imbibed
  bac.even, #second plot: bac.even
  water.imbibed.cor, #third plot: water.imbibed.cor
  labels="auto", #automaticcal labels plOts A,B,C etc
  nrow=3, #arragnes the plots in three rows
  ncol=1, #arranges plots into single column
  legend=FALSE #Do not include a lengend in the combined figure
)
## `geom_smooth()` using formula = 'y ~ x'
figure2


####Integrating Basic Stats into Plots####
#Zach says he does this first to help figure out patterns in the data and then does 
#all the real stats (not based on figures)
#Additional note: foactorial ANOVA type designs, the "stat_compare_means" function in 
#the "ggpubr" package is "excellent"

#Demonstration using Figure 2b from previous exercise
bac.even+
  stat_compare_means(method="anova")#apply an anova to the groups

#can compare all treatments against each other by giving a comparison list!
#Note to self: I think that adding the + sign after the figure name with what you want to do is the step
#process
###example with p-values as significance levels
bac.even+
  geom_pwc(aes(group= Crop), method="t_test", label="p.adj.format")

#example with * as signiicance levels
bac.even+
  geom_pwc(aes(group=Crop), method="t_test", label="p.adj.signif")

#Example with combined p-value and * to indicate significance
bac.even+
  geom_pwc(aes(group=Crop), method="t_test", label="{p.adj.format}{p.adj.signif}")
#groups based on significance kind of

###Displaying Correlation Data###
#pearson correlation stat
water.imbibed.cor+
  stat_cor()
#adds the R and p to the actual figures
## `geom_smooth()` using formula = 'y ~ x'

#adds in regression line
water.imbibed.cor+
  stat_cor(label.y=0.7)+
  stat_regline_equation()
## `geom_smooth()` using formula = 'y ~ x'


####Specific Point labeling####
#Copied from homework "Often times you may want to emphasize a certain point, or 
#group of points that is otherwise hard to do because there are no grouping structure to those points in your metadata. 
#We can manually add labels and color different points as needed. This is especially useful 
#for visualizations where you are trying to emphasize significance, such as in a volcano plot for differential gene 
#expression or differential abundance plots."
#We will use data from Figure 4 of the referenced paper. The plotted data is the result 
#of a differential abundance test for microbiome data.

#read in new csv
diff.abund<-read.csv("diff_abund.csv")
str(diff.abund)

#volcano plots for Soybean vs. Soil
diff.abund$log10_pvalue <- -log10(diff.abund$p_CropSoybean)
diff.abund.label <- diff.abund[diff.abund$log10_pvalue > 30,]

#Now make the plot for the info above
ggplot() + 
  geom_point(data = diff.abund, aes(x = lfc_CropSoybean, y = log10_pvalue, color = diff_CropSoybean)) + 
  theme_classic() + 
  geom_text_repel(data = diff.abund.label, aes(x = lfc_CropSoybean, y = log10_pvalue, color = diff_CropSoybean, label = Label))
#this isn't coming up with some of the labels that are in the example, but maybe that is in the next step

#Plot with colorblind friendly scheme and clearly labeled x and y axes
volcano <- ggplot() + 
  geom_point(data = diff.abund, aes(x = lfc_CropSoybean, y = log10_pvalue, color = diff_CropSoybean)) + 
  geom_text_repel(data = diff.abund.label, aes(x = lfc_CropSoybean, y = log10_pvalue, color = diff_CropSoybean, label = Label)) + 
  scale_color_manual(values = cbbPalette, name = "Significant") +
  theme_classic() + 
  xlab("Log fold change Soil vs. Soybean") +
  ylab("-log10 p-value")
volcano

#can use same concept to emphasize certain points
volcano <- ggplot() + 
  geom_point(data = diff.abund, aes(x = lfc_CropSoybean, y = log10_pvalue)) + 
  geom_point(data = diff.abund.label, aes(x = lfc_CropSoybean, y = log10_pvalue), color = "red", shape = 17, size = 4) + #shape is triangle
  geom_text_repel(data = diff.abund.label, aes(x = lfc_CropSoybean, y = log10_pvalue, label = Label), color = "red") + 
  theme_classic() + 
  xlab("Log fold change Soil vs. Soybean") +
  ylab("-log10 p-value")
volcano

#REMEBER TO KEEP PLOTS SIMPLE AND TO THE POINT!!! The more you add to the plot, especially more than what is needed,
#the harder it is to understand

#Important additional note from Zach "Another good tip is that all the fancy stats that we just added and annotations
#with text are great, but honestly, 90% of the time, I use these tools to explore data; then, if I want to label points 
#or put p-values on boxplots, I do that manually outside of R. ggplot is a great tool, but I often find these types of 
#features tend to look strange when exported."

####There is extra information that you, Katie Temple, need to go back and read since a lot of it directly applies to your own work!####
