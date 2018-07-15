library(ISLR)
cor(Smarket[,-9])

#�����߼��ع�
glm.fits=glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume,
             data=Smarket,family=binomial)
summary(glm.fits)
#ģ�͵�ϵ��
coef(glm.fits)
#����Ԥ��Ϊ1�ĸ���
attach(Smarket)
contrasts(Direction)#upΪ1
glm.probs=predict(glm.fits,type="response")
glm.probs[1:10]
#���������ǽ�
glm.pred=rep("Down",1250)
glm.pred[glm.probs>0.5]="Up"
#���ػ�������
table(glm.pred,Direction)

#����ѵ�����Ͳ��Լ�
train=(Year<2005)
Smarket.2005=Smarket[!train,]
Direction.2005=Direction[!train]

glm.fits=glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume,
             data=Smarket,family=binomial,subset=train)
glm.probs=predict(glm.fits,Smarket.2005,type="response")
#���������ǽ�
glm.pred=rep("Down",252)
glm.pred[glm.probs>0.5]="Up"
#���ػ�������
table(glm.pred,Direction.2005)

#�Ƴ�����
glm.fits=glm(Direction~Lag1+Lag2,data=Smarket,family=binomial,subset=train)
glm.probs=predict(glm.fits,Smarket.2005,type="response")
#���������ǽ�
glm.pred=rep("Down",252)
glm.pred[glm.probs>0.5]="Up"
#���ػ�������
table(glm.pred,Direction.2005)

#########�����б����
library(MASS)
lda.fit=lda(Direction~Lag1+Lag2,data=Smarket,subset=train)
lda.fit
plot(lda.fit)
#Ԥ��
lda.pred=predict(lda.fit,Smarket.2005)
#predict��������ֵ����һ��ֵΪ������,�ڶ���ֵ���ظ���
lda.class=lda.pred$class
table(lda.class,Direction.2005)

########����б����
qda.fit=qda(Direction~Lag1+Lag2,data=Smarket,subset=train)
qda.fit
qda.class=predict(qda.fit,Smarket.2005)$class
table(qda.class,Direction.2005)

#########knn
library(class)
train.X=cbind(Lag1,Lag2)[train,]
test.X=cbind(Lag1,Lag2)[!train,]
train.Direction=Direction[train]
set.seed(1)
knn.pred=knn(train.X,test.X,train.Direction,k=1)
table(knn.pred,Direction.2005)




























