# R Data Visualization with ggplot


# Reading Datasets with read_csv

# This course assumes that you already have the Tidyverse and ggmap libraries installed
# on your system.  If you do not, uncomment and execute the lines below.

#install.packages("tidyverse")
#install.packages("ggmap")

# Load the Tidyverse
library(tidyverse)

# Read the college dataset
college <- read_csv('http://672258.youcanlearnit.net/college.csv')
?read.csv #Reads a file in table format and creates a data frame from it, with cases corresponding to lines and variables to fields in the file.
?read_csv # read_csv() and read_tsv() are special cases of the general read_delim(). 
#They're useful for reading the most common types of flat file data, comma separated values and tab separated values, respectively. read_csv2() uses ; for the field separator and , for the decimal point. 
#This is common in some European countries.
?url #Functions to create, open and close connections, i.e., "generalized files", such as possibly compressed files, URLs, pipes, etc.

# Take a look at the data
summary(college)

# Convert state, region, highest_degree, control, and gender to factors
college <- college %>%
  mutate(state=as.factor(state), region=as.factor(region),
         highest_degree=as.factor(highest_degree),
         control=as.factor(control), gender=as.factor(gender))

# Take a look at the data
summary(college)

# What's going on with loan_default_rate?
unique(college$loan_default_rate)

# Let's just force that to numeric and the "NULL" will convert to N/A
college <- college %>%
  mutate(loan_default_rate=as.numeric(loan_default_rate))

# Take a look at the data
summary(college)


# Calling ggplot() along just creates a blank plot
ggplot()

# I need to tell ggplot what data to use
ggplot(data=college)

# And then give it some instructions using the grammar of graphics.
# Let's build a simple scatterplot with tuition on the x-axis and average SAT score on the y axis
ggplot(data=college) +
  geom_point(mapping=aes(x=tuition, y=sat_avg))

# Let's try representing a different dimension.  
# What if we want to differentiate public vs. private schools?
# We can do this using the shape attribute
ggplot(data=college) +
  geom_point(mapping=aes(x=tuition, y=sat_avg, shape=control))

# That's hard to see the difference.  What if we try color instead?
ggplot(data=college) +
  geom_point(mapping=aes(x=tuition, y=sat_avg, color=control))

# I can also alter point size.  Let's do that to represent the number of students
ggplot(data=college) +
  geom_point(mapping=aes(x=tuition, y=sat_avg, color=control, size=undergrads))

# And, lastly, let's add some transparency so we can see through those points a bit
# Experiment with the alpha value a bit.
ggplot(data=college) +
  geom_point(mapping=aes(x=tuition, y=sat_avg, color=control, size=undergrads), alpha=1)

ggplot(data=college) +
  geom_point(mapping=aes(x=tuition, y=sat_avg, color=control, size=undergrads), alpha=1/100)

ggplot(data=college) +
  geom_point(mapping=aes(x=tuition, y=sat_avg, color=control, size=undergrads), alpha=1/10)

ggplot(data=college) +
  geom_point(mapping=aes(x=tuition, y=sat_avg, color=control, size=undergrads), alpha=1/2)

# What if we wanted to convert this to a line graph?
ggplot(data=college) +
  geom_line(mapping=aes(x=tuition, y=sat_avg, color=control))

# Wow, that's really noisy.  Let's add the points back in
ggplot(data=college) +
  geom_line(mapping=aes(x=tuition, y=sat_avg, color=control)) +
  geom_point(mapping=aes(x=tuition, y=sat_avg, color=control))

# I can also write this a different way
ggplot(data=college, mapping=aes(x=tuition, y=sat_avg, color=control)) +
  geom_line() +
  geom_point()

# I can use the geom_smooth geometry to fit a line instead of connecting every point
ggplot(data=college, mapping=aes(x=tuition, y=sat_avg, color=control)) +
  geom_smooth() +
  geom_point()

# Maybe add some transparency to just the points to make the line stand out more
ggplot(data=college, mapping=aes(x=tuition, y=sat_avg, color=control)) +
  geom_smooth() +
  geom_point(alpha=1/2)

# Try more transparency
ggplot(data=college, mapping=aes(x=tuition, y=sat_avg, color=control)) +
  geom_smooth() +
  geom_point(alpha=1/5)

# And remove the confidence interval from the smoother
ggplot(data=college, mapping=aes(x=tuition, y=sat_avg, color=control)) +
  geom_smooth(se=FALSE) +
  geom_point(alpha=1/5)


# How many schools are in each region?
# This calls for a bar graph!
ggplot(data=college) +
  geom_bar(mapping=aes(x=region))

# Break it out by public vs. private
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, color=control))

# Well, that's unsatisfying!  Try fill instead of color
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control))

# How about average tuition by region?
# First, I'll use some dplyr to create the right tibble
college %>%
  group_by(region) %>%
  summarize(average_tuition=mean(tuition))

# And I can pipe that straight into ggplot
college %>%
  group_by(region) %>%
  summarize(average_tuition=mean(tuition)) %>%
  ggplot() +
  geom_bar(mapping=aes(x=region, y=average_tuition))

# But I need to use a column graph instead of a bar graph to specify my own y
college %>%
  group_by(region) %>%
  summarize(average_tuition=mean(tuition)) %>%
  ggplot() +
  geom_col(mapping=aes(x=region, y=average_tuition))


# Let's look at student body size
ggplot(data=college) +
  geom_bar(mapping=aes(x=undergrads))

# Histograms can help us by binning results
ggplot(data=college) +
  geom_histogram(mapping=aes(x=undergrads))

ggplot(data=college) +
  geom_histogram(mapping=aes(x=undergrads), origin=0)

# What if we want fewer groups? Let's ask for 4 bins
ggplot(data=college) +
  geom_histogram(mapping=aes(x=undergrads), bins=4, origin=0)

# Or 10 bins.
ggplot(data=college) +
  geom_histogram(mapping=aes(x=undergrads), bins=10, origin=0)

# Or we can specify the width of the bins instead
ggplot(data=college) +
  geom_histogram(mapping=aes(x=undergrads), binwidth=1000, origin=0)

ggplot(data=college) +
  geom_histogram(mapping=aes(x=undergrads), binwidth=10000, origin=0)


# Let's try looking at tuition vs. institutional control
ggplot(data=college) +
  geom_point(mapping=aes(x=control, y=tuition))

# One way I could visualize this better is by adding some jitter
ggplot(data=college) +
  geom_jitter(mapping=aes(x=control, y=tuition))

# But an even better way is with a boxplot
ggplot(data=college) +
  geom_boxplot(mapping=aes(x=control, y=tuition))


# Create the bar graph 
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control))

# Change the plot background color
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme(plot.background=element_rect(fill='purple'))

# Change the panel background color
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme(panel.background=element_rect(fill='purple'))

# Let's be minimalist and make both backgrounds disappear
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme(panel.background=element_blank()) +
  theme(plot.background=element_blank())

# Add grey gridlines
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme(panel.background=element_blank()) +
  theme(plot.background=element_blank()) +
  theme(panel.grid.major=element_line(color="grey"))

# Only show the y-axis gridlines
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme(panel.background=element_blank()) +
  theme(plot.background=element_blank()) +
  theme(panel.grid.major.y=element_line(color="grey"))


# Create the bar graph 
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme(panel.background=element_blank()) +
  theme(plot.background=element_blank())

# Rename the axes
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme(panel.background=element_blank()) +
  theme(plot.background=element_blank()) +
  xlab("Region") +
  ylab("Number of Schools")

# Resize the y-axis
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme(panel.background=element_blank()) +
  theme(plot.background=element_blank()) +
  xlab("Region") +
  ylab("Number of Schools") +
  ylim(0,500)

# Be careful - using the ylim function is like zooming
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme(panel.background=element_blank()) +
  theme(plot.background=element_blank()) +
  xlab("Region") +
  ylab("Number of Schools") +
  ylim(50,500) 


# Create the bar graph 
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme(panel.background=element_blank()) +
  theme(plot.background=element_blank())

# Change the name of x-axis
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme(panel.background=element_blank()) +
  theme(plot.background=element_blank()) +
  scale_x_discrete(name="Region")

# Change the name and limits of the y-axis
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme(panel.background=element_blank()) +
  theme(plot.background=element_blank()) +
  scale_x_discrete(name="Region") +
  scale_y_continuous(name="Number of Schools", limits=c(0,500))

# Change the fill colors
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme(panel.background=element_blank()) +
  theme(plot.background=element_blank()) +
  scale_x_discrete(name="Region") +
  scale_y_continuous(name="Number of Schools", limits=c(0,500)) +
  scale_fill_manual(values=c("orange","blue"))


# Create the bar graph 
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme(panel.background=element_blank()) +
  theme(plot.background=element_blank()) +
  scale_x_discrete(name="Region") +
  scale_y_continuous(name="Number of Schools", limits=c(0,500)) +
  scale_fill_manual(values=c("orange","blue"))

# Change the legend title
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme(panel.background=element_blank()) +
  theme(plot.background=element_blank()) +
  scale_x_discrete(name="Region") +
  scale_y_continuous(name="Number of Schools", limits=c(0,500)) +
  scale_fill_manual(values=c("orange","blue"), guide_legend(title="Institution Type"))

# Adjust the legend formatting
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme(panel.background=element_blank()) +
  theme(plot.background=element_blank()) +
  scale_x_discrete(name="Region") +
  scale_y_continuous(name="Number of Schools", limits=c(0,500)) +
  scale_fill_manual(values=c("orange","blue"), guide=guide_legend(title="Institution Type", label.position="bottom", nrow=1, keywidth=2.5))

# Move the legend to the bottom of the plot
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme(panel.background=element_blank()) +
  theme(plot.background=element_blank()) +
  scale_x_discrete(name="Region") +
  scale_y_continuous(name="Number of Schools", limits=c(0,500)) +
  scale_fill_manual(values=c("orange","blue"), guide=guide_legend(title="Institution Type", label.position="bottom", nrow=1, keywidth=2.5)) +
  theme(legend.position="bottom")

# Move the legend to the top of the plot
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme(panel.background=element_blank()) +
  theme(plot.background=element_blank()) +
  scale_x_discrete(name="Region") +
  scale_y_continuous(name="Number of Schools", limits=c(0,500)) +
  scale_fill_manual(values=c("orange","blue"), guide=guide_legend(title="Institution Type", label.position="bottom", nrow=1, keywidth=2.5)) +
  theme(legend.position="top")


# Create the scatterplot 
ggplot(data=college) +
  geom_point(mapping=aes(x=tuition, y=sat_avg, color=control, size=undergrads), alpha=1/2) 

# Add a text annotation
ggplot(data=college) +
  geom_point(mapping=aes(x=tuition, y=sat_avg, color=control, size=undergrads), alpha=1/2) +
  annotate("text", label="Elite Privates", x=45000,y=1500)

# Add a line for the mean SAT score
ggplot(data=college) +
  geom_point(mapping=aes(x=tuition, y=sat_avg, color=control, size=undergrads), alpha=1/2) +
  annotate("text", label="Elite Privates", x=45000,y=1500) +
  geom_hline(yintercept=mean(college$sat_avg))

# And label it
ggplot(data=college) +
  geom_point(mapping=aes(x=tuition, y=sat_avg, color=control, size=undergrads), alpha=1/2) +
  annotate("text", label="Elite Privates", x=45000,y=1500) +
  geom_hline(yintercept=mean(college$sat_avg)) +
  annotate("text", label="Mean SAT", x=47500, y=mean(college$sat_avg)-15)

# Add a line for mean tuition
ggplot(data=college) +
  geom_point(mapping=aes(x=tuition, y=sat_avg, color=control, size=undergrads), alpha=1/2) +
  annotate("text", label="Elite Privates", x=45000,y=1500) +
  geom_hline(yintercept=mean(college$sat_avg)) +
  annotate("text", label="Mean SAT", x=47500, y=mean(college$sat_avg)-15) +
  geom_vline(xintercept=mean(college$tuition)) +
  annotate("text", label="Mean Tuition", x=mean(college$tuition)+7500, y=700)

# And let's tidy this up a bit more
ggplot(data=college) +
  geom_point(mapping=aes(x=tuition, y=sat_avg, color=control, size=undergrads), alpha=1/2) +
  annotate("text", label="Elite Privates", x=45000,y=1500) +
  geom_hline(yintercept=mean(college$sat_avg), color="dark grey") +
  annotate("text", label="Mean SAT", x=47500, y=mean(college$sat_avg)-15) +
  geom_vline(xintercept=mean(college$tuition), color="dark grey") +
  annotate("text", label="Mean Tuition", x=mean(college$tuition)+7500, y=700) +
  theme(panel.background = element_blank(), legend.key = element_blank()) +
  scale_color_discrete(name="Institution Type") +
  scale_size_continuous(name="Undergraduates") +
  scale_x_continuous(name="Tuition") +
  scale_y_continuous(name="SAT Scores")


# Create the bar graph 
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme(panel.background=element_blank()) +
  theme(plot.background=element_blank()) +
  scale_x_discrete(name="Region") +
  scale_y_continuous(name="Number of Schools", limits=c(0,500)) +
  scale_fill_manual(values=c("orange","blue"), guide=guide_legend(title="Institution Type", label.position="bottom", nrow=1, keywidth=2.5)) +
  theme(legend.position="bottom")

# Add a title
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme(panel.background=element_blank()) +
  theme(plot.background=element_blank()) +
  scale_x_discrete(name="Region") +
  scale_y_continuous(name="Number of Schools", limits=c(0,500)) +
  scale_fill_manual(values=c("orange","blue"), guide=guide_legend(title="Institution Type", label.position="bottom", nrow=1, keywidth=2.5)) +
  theme(legend.position="bottom") +
  ggtitle("More colleges are in the southern U.S. than any other region.")

# Add a subtitle
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme(panel.background=element_blank()) +
  theme(plot.background=element_blank()) +
  scale_x_discrete(name="Region") +
  scale_y_continuous(name="Number of Schools", limits=c(0,500)) +
  scale_fill_manual(values=c("orange","blue"), guide=guide_legend(title="Institution Type", label.position="bottom", nrow=1, keywidth=2.5)) +
  theme(legend.position="bottom") +
  ggtitle("More colleges are in the southern U.S. than any other region.", subtitle="Source: U.S. Department of Education")


# Create the bar graph 
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control))

# Try some different themes
ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme_bw()

ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme_minimal()

ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme_void()

ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme_dark()

# Check out ggthemes
install.packages("ggthemes")
library(ggthemes)

ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme_solarized()

ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme_excel()

ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme_wsj()

ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme_economist()

ggplot(data=college) +
  geom_bar(mapping=aes(x=region, fill=control)) +
  theme_fivethirtyeight()

