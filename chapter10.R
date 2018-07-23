###########���ɷַ���
pr.out=prcomp(USArrests,scale=TRUE)
#loading
pr.out$rotation
#�÷�principal component score vector
pr.out$x
#ǰ�������ɷ�
biplot(pr.out,scale=0)

#ÿ�����ɷֵı�׼��
pr.out$sdev
#������
pr.var=pr.out$sdev^2
pve=pr.var/sum(pr.var )
pve

#���ۼƹ����ʵ�ͼ
plot(pve,xlab ="Principal Component",ylab="Proportion of
Variance Explained",ylim=c(0,1),type="b")
plot(cumsum(pve),xlab="Principal Component",ylab="
Cumulative Proportion of Variance Explained",ylim=c(0,1),type="b")

##########�������
####k-means
set.seed(2)
x= matrix(rnorm(50*2),ncol =2)
x[1:25,1]= x[1:25,1]+3
x[1:25,2]= x[1:25,2]-4
km.out=kmeans(x,2,nstart=20)
#nstart��ʾ��ʼ���Ĵ���
km.out$cluster

plot(x,col=(km.out$cluster+1),main ="K- Means Clustering
Results with K=2",xlab ="",ylab ="",pch =20,cex =2)

km.out
#tot.withinss��ʾtotal within-cluster sum of squares
#withinss��ʾ������within-cluster sum of squares

#####���ͼ
hc.complete=hclust(dist(x),method ="complete")
#��ͼ
plot(hc.complete,main ="Complete Linkage ",xlab ="",sub ="",cex =.9)
#label
cutree (hc.complete,2)

x= matrix(rnorm(30*3),ncol =3)
dd=as.dist(1- cor(t(x)))
plot(hclust(dd,method ="complete"), main ="Complete Linkage
with Correlation - Based Distance ", xlab ="", sub ="")

#####����
library(ISLR)
nci.labs= NCI60$labs
nci.data= NCI60$data

pr.out=prcomp(nci.data,scale=TRUE)

Cols=function(vec){
cols=rainbow(length(unique(vec)))
return(cols[as.numeric(as.factor(vec))])
}

plot(pr.out$x[,1:2] ,col=Cols(nci.labs),pch=19,xlab ="Z1",ylab =" Z2")

summary(pr.out)
#����
plot(pr.out)

#�������
summary(pr.out)$importance[2,]
#�ۼƹ�����
summary(pr.out)$importance[3,]

########�����ɷַ������о���
hc.out=hclust(dist(pr.out$x[,1:5]) )
plot(hc.out,labels =nci.labs , main =" Hier.Clust.on First
Five Score Vectors")
table(cutree(hc.out,4),nci.labs)





