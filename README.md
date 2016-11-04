# ExpressionCalculate
similar eval() of JS , Calculate the expression value through the string,类似js的eval(),计算字符串表达式的值

# 文件描述:
  支持从字符串的表达式中计算表达式的值，例如 "((5+8)-8)""*""5" 的值。目前支持 +(加)、-(减)、*(乘)、/(除)、%(求余)、?:(三目运算)  并且含有括号嵌套的复合运算，其中三目运算符的条件判断支持>、>=、<、<=、!=、==、!、true、false的判断，支持&&、||合并条件

# 使用指南:
  下载项目后，项目中有一个封装好的ExpressionCalculate.swift文件，把此文件直接拖入项目主目录中。
 
# API指南：
(1)、含有变量的表达式
     
     ///expression : 参与计算字符串，可以包含变量
     ///paramValues :  变量参数列表，key 是变量名，value是变量值，如果没有变量，直接传空字典，不会有影响
     ///return : 返回计算结果
     public class func calculateExpression(expression:String,paramValues:[String:String])->String
    
(2)、普通表达式

     ///expression : 参与计算字符串
     ///return : 返回计算结果
     public class func calculateExpression(expression:String)->String
     
    
