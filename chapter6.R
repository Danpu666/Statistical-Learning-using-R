library(ISLR)
fix(Hitters)
#�ж��Ƿ���ȱʧֵ
sum(is.na(Hitters$Salary))
Hitters=na.omit(Hitters)
sum(is.na(Hitters$Salary))

######best subset selection
library(leaps)
regfit.full=regsubsets(Salary~.,Hitters)
summary(regfit.full)
#1 subsets of each size up to 8
regfit.full=regsubsets(Salary~.,data=Hitters,nvmax=19)
reg.summary=summary(regfit.full)

#summary�����ṩ��R^2,RSS,Cp��
names(reg.summary)
#��ʾrss
reg.summary$rss

#���ֻ�ͼ��ʽ
��һ�֣�
plot(reg.summary$cp,xlab ="Number of Variables",ylab ="Cp",type="l")
which.min(reg.summary$cp )
points(10, reg.summary$cp [10],col =" red ", cex =2, pch =20)
�ڶ��֣�
plot( regfit.full, scale ="Cp")

#�鿴ϵ��
coef(regfit.full ,6)

#########ǰ��ͺ���ѡ��
regfit.fwd = regsubsets(Salary~.,data= Hitters,nvmax =19,method ="forward")
summary(regfit.fwd )
regfit.bwd = regsubsets(Salary~.,data= Hitters,nvmax =19,method ="backward")
summary(regfit.bwd )
#ÿ�ַ�ʽѡ��ͬ
coef(regfit.full,7)
coef(regfit.fwd,7)
coef(regfit.bwd ,7)

############Ӧ��validation set and cross-validation
#����ѵ�����Ͳ��Լ�
set.seed(1)
train=sample(c(TRUE,FALSE),nrow(Hitters),rep=TRUE)
test=(!train)
#����ģ��
regfit.best= regsubsets(Salary~.,data=Hitters[train,],nvmax =19)
#���Լ�
test.mat=model.matrix(Salary~.,data= Hitters[test ,])

val.errors =rep (NA ,19)
for (i in 1:19) {
coefi =coef(regfit.best,id=i)
pred =test.mat[,names(coefi)]%*%coefi
val.errors[i]=mean((Hitters$Salary[test]- pred )^2)
}

val.errors

######cross-validation
k =10
set.seed (1)
folds=sample (1:k,nrow(Hitters),replace=TRUE)
cv.errors =matrix (NA ,k ,19, dimnames = list(NULL , paste (1:19)))

#Ԥ��
predict.regsubsets = function (object , newdata ,id ,...) {
form=as.formula ( object$call [[2]])
mat = model.matrix(form,newdata )
coefi =coef(object,id=id)
xvars =names (coefi)
mat [, xvars ]%*% coefi
}

for (j in 1:k){
best.fit=regsubsets(Salary~.,data=Hitters[folds!=j,],nvmax =19)
for (i in 1:19){
pred= predict(best.fit,Hitters[folds ==j,],id=i)
cv.errors[j,i]= mean((Hitters$Salary[folds==j]- pred)^2)
}
}
mean.cv.errors =apply(cv.errors,2,mean)

#############�����
x= model.matrix(Salary~.,Hitters )[,-1]
y= Hitters$Salary

library(glmnet)
grid=10^ seq (10,-2,length =100)
ridge.mod =glmnet(x,y,alpha =0,lambda = grid)
#ϵ��������20������*100��lamdaֵ
dim(coef(ridge.mod))

#lamda
ridge.mod$lambda[50]
#ϵ��
coef(ridge.mod)[,50]
#������predict������ϵ����lamda=50
predict(ridge.mod,s=11497.57,type ="coefficients")[1:20,]

#�������Լ���ѵ���������Դ��ĺ���Ѱ�����ŵ�lambda
set.seed(1)
train=sample(1:nrow(x),nrow(x)/2)
test=(-train)
y.test=y[test]
#�Դ��ĺ����õ���ѵ�lambda
set.seed (1)
cv.out=cv.glmnet(x[train,],y[train],alpha =0)
plot(cv.out)
bestlam=cv.out$lambda.min
bestlam
#�����µ�ģ��
out=glmnet(x,y,alpha =0)
predict(out,type ="coefficients",s=bestlam)

###########lasso
lasso.mod =glmnet(x[train ,], y[ train ], alpha =1, lambda =grid)
plot(lasso.mod)

set.seed (1)
cv.out=cv.glmnet(x[train ,], y[ train ], alpha =1)
plot(cv.out)
bestlam =cv. out$lambda.min

out = glmnet (x,y, alpha =1, lambda = grid)
lasso.coef= predict (out ,type =" coefficients",s= bestlam ) [1:20 ,]
lasso.coef
#lasso�Ὣϵ��ѹ��Ϊ0

########PCR and PLS �ع�
library (pls)
set.seed (2)
pcr.fit =pcr( Salary~., data= Hitters ,scale =TRUE ,validation ="CV")
#validation��ʾҪ��Cross-validation
summary(pcr.fit)

#��cross-validation��mse
validationplot(pcr.fit,val.type ="MSEP")
#Ԥ��y
pcr.pred= predict(pcr.fit,x[test,],ncomp =7)
#ѡ���С�����ɷֵĸ������½���ģ��
pcf.fit=pcr(y~x,scale=TRUE,ncomp=7)

############pls
set.seed (1)
pls.fit =plsr(Salary~.,data =Hitters, subset=train ,scale =TRUE ,validation ="CV")
summary(pls.fit)

validationplot(pls.fit ,val.type ="MSEP")
pls.pred= predict(pls.fit ,x[test,], ncomp =2)

pls.fit=plsr(Salary~., data =Hitters , scale =TRUE , ncomp =2)
summary(pls.fit)