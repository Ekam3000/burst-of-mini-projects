
#reading data from excel files

install.packages('readxl',repos="http://cran.rstudio.com/")
install.packages("writexl")
library('readxl')
library('writexl')

#dISPLAY ALL THE SHEET NAMES
#there are 4 sheets within excel sheet 
excel_sheets("D:\\users 1\\documents\\R_data_science\\tableau\\P1-AmazingMartEU2.xlsx")

#read data from the sheets using read_excel
df <- read_excel("D:\\users 1\\documents\\R_data_science\\tableau\\P1-AmazingMartEU2.xlsx", sheet ='ListOfOrders')
head(df)
View(df)


df1 <- read_excel("D:\\users 1\\documents\\R_data_science\\tableau\\P1-AmazingMartEU2.xlsx", sheet ='OrderBreakdown')
head(df1)
View(df1)


df2 <- read_excel("D:\\users 1\\documents\\R_data_science\\tableau\\P1-AmazingMartEU2.xlsx", sheet ='SalesTargets')
head(df2)
View(df2)


# joining/combination of two tables of my dataset

library(dplyr)
#inner join

d.inner <- dplyr::inner_join(df,df1,by="Order ID")
View(d.inner)
dim(d.inner)

#left join
d.left <- dplyr::left_join(df,df1,by="Order ID")
View(d.left)
dim(d.left)

#right join
d.right <- dplyr::right_join(df,df1,by="Order ID")
View(d.right)
dim(d.right)

#full outer join -> union of two
d.full <- dplyr::full_join(df,df1,by="Order ID")
View(d.full)
dim(d.full)

#calculated field in R

d.inner$profit_margin <- d.inner[,14]/d.inner[,13]
View(d.inner)


#Data cleaning
for(i in 2:ncol(d.inner)) {
  d.inner[,i][is.na(d.inner[ ,i])]<- mean(d.inner[ ,i],na.rm=TRUE)
}


#splitting
data_set1= select(d.inner,"Order ID","Country","Ship Date","Ship Mode","Sales","Profit","Sub-Category")
View(data_set1)

data_set2= select(d.inner,"Order ID","Order Date","Region","Product Name","Discount","Sales","Category")
View(data_set2)

data_set3= select(d.inner,"Order ID","Customer Name","City","Segment","State","Quantity","profit_margin")
View(data_set3)



#data merging

data_frame=merge(data_set1,data_set2,by=c("Order ID"))
View(data_frame)
data_frame2=merge(data_set3,data_frame,by=c("Order ID"))
View(data_frame2)



#1
#how a certain Shore had performed across different States across the US
tapply(d.inner$Sales,d.inner$State,sum)


#2
summarise(
  select(
    group_by(d.inner,State),State,Profit,Sales),Profit=sum(Profit),Sales=sum(Sales)
  )


#3
subdata<- group_by(df2,Category)
summarise(subdata,sum(Target))


#4
tapply(data_set2$Sales,data_set2$Category,sum)

#5
quantity_sum=sum(data_set3$Quantity)
quantity_sum
summarise(
  select(
    group_by(data_set3,Segment),Segment,Quantity),
  Quantity=(sum(Quantity)/quantity_sum)*100)

#6
summarise(
  select(
    group_by(data_set1,"Ship Mode"),Profit,"Ship Mode",Sales),
  Profit=sum(Profit),Sales=sum(Sales))





#i
head(Orange,15)
#ii
str(Orange)
#iii
range(Orange$age)
#iv
quantile(Orange$age,0.5)
quantile(Orange$age,0.75)
#v
std(Orange$age)
var(Orange$age)