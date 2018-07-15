#ls() a list of all of the objects
#rm() delete any object
rm(list=ls())

#contour() produce a contour plot�ȸ���
x=seq(1,10)
y=x
f=outer(x,y,function(x,y)cos(y)/(1+x^2))
contour(x,y,f)
fa=(f-t(f))/2
contour(x,y,fa,nlevels=15)
#image()��������ͼ
image(x,y,fa)
#persp()������άͼ
persp(x,y,fa)

#��ȡ����
#��һ�ַ���
auto$mpg
#�ڶ��ַ���
attach(auto)
mpg

#pair����һϵ��ɢ��ͼ
pairs(iris[1:4], main = "Anderson's Iris Data -- 3 species",
      pch = 21, bg = c("red", "green3", "blue")[unclass(iris$Species)])

#identity()ʶ��ĳһ����
