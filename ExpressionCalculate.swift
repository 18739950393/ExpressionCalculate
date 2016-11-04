//
//  ExpressionCalculate.swift
//  ExpressionCalcDemo
//
//  Created by 王浩 on 16/11/3.
//  Copyright © 2016年 uniproud. All rights reserved.
//

import Foundation


public class ExpressionCalculate {
    
    
    
    ///extermal requests main API
    ///expression : Participate in the calculation of strings, can contain variables
    ///paramValues : Variable argument list, key is a variable name, value is a variable value, if there is no variable, the direct pass dictionary, will not be affected
    ///return : Return the result of the calculation
    ///外部调用主接口
    ///expression : 参与计算字符串，可以包含变量
    ///paramValues :  变量参数列表，key 是变量名，value是变量值，如果没有变量，直接传空字典，不会有影响
    ///return : 返回计算结果
    public class func calculateExpression(expression:String,paramValues:[String:String])->String {
        
        var expressionStr = expression  //需要参加计算字符串
        for (key,value) in paramValues {
            while expressionStr.containsString(key) {
                expressionStr = expressionStr.stringByReplacingOccurrencesOfString(key, withString: value)
            }
        }
        //返回计算结果
        return ExpressionCalculate().expressionCalculate(expressionStr)
    }
    
    ///extermal requests main API
    ///expression : Participate in the calculation of strings
    ///return : Return the result of the calculation
    ///外部调用主接口
    ///expression : 参与计算字符串
    ///return : 返回计算结果
    public class func calculateExpression(expression:String)->String {
        
        //返回计算结果
        return ExpressionCalculate().expressionCalculate(expression)
    }
    
    
    //含有括号的复杂表达式运算
    func expressionCalculate(expression:String) -> String {
        
        var lIndex = 0  //左括号位置
        var rIndex = 0  //右括号位置
        var expressionStr = expression
        var bracketNum = 0  //括号数，左+1 右-1
        
        //查找左括号从左开始向右
        leftFor:for i in 0..<expressionStr.characters.count {
            let currentChar = expressionStr.substringWithRange(expressionStr.startIndex.advancedBy(i)...expressionStr.startIndex.advancedBy(i))
            //找到左括号位置
            if currentChar == "(" {
                bracketNum+=1
                lIndex = i
                break leftFor
            }
        }
        
        //查找右括号从左括号隔两个开始
        rightFor:for i in lIndex..<expressionStr.characters.count  {
            let currentChar = expressionStr.substringWithRange(expressionStr.startIndex.advancedBy(i)...expressionStr.startIndex.advancedBy(i))
            //左括号+1，右括号-1
            if currentChar == "(" {
                if i != lIndex {
                    bracketNum+=1
                }
            } else if currentChar == ")" {
                bracketNum-=1
            }
            //如果左右括号相互抵消，认为找到了右括号
            if bracketNum == 0 {
                rIndex = i
                break rightFor
            }
        }
        
        
        //针对三木运算
        var temaryCondition = ""  //条件
        var temaryV1 = ""  //值1
        var temaryV2 = "" //值2
        var temaryConBracket = 0  //条件括号数
        var temaryV2Bracket = 0  //值2括号数
        
        
        //遍历表达式，为了查找是否存在三目运算符
        temaryFor:for i in 0..<expression.characters.count {
            let currentChar = expression.substringWithRange(expression.startIndex.advancedBy(i)...expression.startIndex.advancedBy(i))
            //找到问号
            if currentChar == "?" {
                temaryCondition = expression.substringWithRange(expression.startIndex..<expression.startIndex.advancedBy(i))
                var temaryValue = ""
                //防止字符串越界
                if (i+1) < expression.characters.count {
                    temaryValue = expression.substringWithRange(expression.startIndex.advancedBy(i+1)..<expression.endIndex)
                }
                //左括号数+1，右括号-1
                for item in temaryCondition.characters {
                    if item == "(" {
                        temaryConBracket += 1
                    } else if item == ")" {
                        temaryConBracket -= 1
                    }
                }
                
                //找到两个值  已及冒号
                for j in 0..<temaryValue.characters.count {
                    let currentCharJ = temaryValue.substringWithRange(temaryValue.startIndex.advancedBy(j)...temaryValue.startIndex.advancedBy(j))
                    if currentCharJ == ":" {
                        temaryV1 = temaryValue.substringWithRange(temaryValue.startIndex..<temaryValue.startIndex.advancedBy(j))
                        //防止字符串越界
                        if (j+1) < temaryValue.characters.count {
                            temaryV2 = temaryValue.substringWithRange(temaryValue.startIndex.advancedBy(j+1)..<temaryValue.endIndex)
                        }

                        //左括号数+1，右括号-1
                        for item in temaryV2.characters {
                            if item == "(" {
                                temaryV2Bracket += 1
                            } else if item == ")" {
                                temaryV2Bracket -= 1
                            }
                        }
                        
                        break temaryFor  //退出查找三目运算符
                    }
                }
            }
        }
        
        //如果三目运算符在最外边，展开三目运算
        if temaryConBracket == 0 && temaryV2Bracket == 0 {
            //如果有三目运算符,条件，值1值2都不为空
            if !temaryCondition.isEmpty && !temaryV1.isEmpty && !temaryV2.isEmpty {
                return temaryCalculate(temaryCondition, v1: temaryV1, v2: temaryV2)
            }
        }
        
        //如果右括号位置不为0 并且左右括号之间有值
        if rIndex != 0 && (rIndex-lIndex)>2 {
            let subString = expressionStr.substringWithRange(expressionStr.startIndex.advancedBy(lIndex+1)..<expressionStr.startIndex.advancedBy(rIndex))
            //递归自己,的到计算结果
            let subResult = self.expressionCalculate(subString)
            //替换时保证数组不能越界
            if rIndex+1 < expressionStr.characters.count {
                expressionStr = expressionStr.stringByReplacingCharactersInRange(expressionStr.startIndex.advancedBy(lIndex)...expressionStr.startIndex.advancedBy(rIndex), withString: subResult)
            }
            
            //如果自身还有括号，递归自己
            if expressionStr.containsString("(") {
                expressionStr = self.expressionCalculate(expressionStr)
            }
        }
        
        return self.straightExpressionCalculate(expressionStr)
    }
    
    //此方法只计算无括号的复合运算
    func straightExpressionCalculate(expression:String) -> String {
        //以下只考虑 + - * / % 运算
        var result = "0"  //结果
        //如果包含 + -
        if expression.containsString("+") || expression.containsString("-") {
            var addMinSymbol = "+"
            var addMinStartMark = 0
            for i in 0..<expression.characters.count {
                
                var currentChar = expression.substringWithRange(expression.startIndex.advancedBy(i)...expression.startIndex.advancedBy(i))
                
                if currentChar == "+" || currentChar == "-" {
                    let subString = expression.substringWithRange(expression.startIndex.advancedBy(addMinStartMark)..<expression.startIndex.advancedBy(i))
                    switch addMinSymbol {
                    case "+":
                        //如果subString为空，有三种情况，1，首字符，2，前面有+，3，前面有-，只有第三种情况对值有影响
                        if subString.isEmpty {
                            let frondStr = expression.substringWithRange(expression.startIndex..<expression.startIndex.advancedBy(i))
                            //当前方为 - 号时，负正得负，将当前符号变-
                            if frondStr.hasSuffix("-") {
                                currentChar = "-"
                            }
                        }
                        let subValue = self.mulAndDivAndRemCalculate(subString)
                        result = self.binaryCalculate(result, v2: subValue, calculate: {$0+$1})
                    case "-":
                        //如果subString为空，有三种情况，1，首字符，2，前面有+，3，前面有-，只有第三种情况对值有影响
                        if subString.isEmpty {
                            let frondStr = expression.substringWithRange(expression.startIndex..<expression.startIndex.advancedBy(i))
                            //当前方为 - 号时，负负得正，将当前符号变+
                            if frondStr.hasSuffix("-") {
                                currentChar = "+"
                            }
                        }
                        let subValue = self.mulAndDivAndRemCalculate(subString)
                        result = self.binaryCalculate(result, v2: subValue, calculate: {$0-$1})
                    default:
                        break
                    }
                    addMinSymbol = currentChar
                    addMinStartMark = i+1
                }
            }
            
            //最后一位
            if addMinStartMark < expression.characters.count {
                let subString = expression.substringWithRange(expression.startIndex.advancedBy(addMinStartMark)..<expression.endIndex)
                switch addMinSymbol {
                case "+":
                    let subValue = self.mulAndDivAndRemCalculate(subString)
                    result = self.binaryCalculate(result, v2: subValue, calculate: {$0+$1})
                case "-":
                    
                    let subValue = self.mulAndDivAndRemCalculate(subString)
                    result = self.binaryCalculate(result, v2: subValue, calculate: {$0-$1})
                default:
                    break
                }
            }
        } else {
            result = self.mulAndDivAndRemCalculate(expression)
        }
        
        return result
    }
    
    //只包含 * / % 的计算
    func mulAndDivAndRemCalculate(expression:String) -> String {
        
        //没有 * / % 的符号
        if !expression.containsString("*") && !expression.containsString("/") && !expression.containsString("%") {
            return expression
        }
        
        var result = "1"
        var symbol = "*"
        
        var numStartPoint = 0
        for i in 0..<expression.characters.count {
            
            let currentChar = expression.substringWithRange(expression.startIndex.advancedBy(i)...expression.startIndex.advancedBy(i))
            
            if currentChar == "*" || currentChar == "/" || currentChar == "%" {
                let number = expression.substringWithRange(expression.startIndex.advancedBy(numStartPoint)..<expression.startIndex.advancedBy(i))
                switch symbol {
                case "*":
                    result = self.binaryCalculate(result, v2: number, calculate: {$0*$1})
                case "/":
                    result = self.binaryCalculate(result, v2: number, calculate: {$0/$1})
                case "%":
                    result = self.binaryCalculate(result, v2: number, calculate: {$0%$1})
                default:
                    break
                }
                symbol = currentChar
                numStartPoint = i+1
            }
        }
        
        //最后一位
        if numStartPoint < expression.characters.count {
            let number = expression.substringWithRange(expression.startIndex.advancedBy(numStartPoint)..<expression.endIndex)
            switch symbol {
            case "*":
                result = self.binaryCalculate(result, v2: number, calculate: {$0*$1})
            case "/":
                result = self.binaryCalculate(result, v2: number, calculate: {$0/$1})
            case "%":
                result = self.binaryCalculate(result, v2: number, calculate: {$0%$1})
            default:
                break
            }
            
        }
        return result
    }
    
    
    //双目运算
    func binaryCalculate(v1:String,v2:String,calculate:(v1:Float,v2:Float)->Float) -> String {
        let v1f = (v1 as NSString).floatValue
        let v2f = (v2 as NSString).floatValue
        return String(format: "%.2f", calculate(v1: v1f, v2: v2f))
    }
    
    //三目运算
    func temaryCalculate(condition:String,v1:String,v2:String) -> String {
        
        var conditionValue = true  //条件值，默认true
        
        //包含与 、或 表达式
        conditionIf:if condition.containsString("&") || condition.containsString("|") {
            
            var symbol = "&&"  //默认逻辑与
            var numStartPoint = 0  //标记条件开始位置
            //遍历条件
            for i in 0..<condition.characters.count {
                //当前字符
                let currentChar = condition.substringWithRange(condition.startIndex.advancedBy(i)...condition.startIndex.advancedBy(i))
                
                //逻辑与、逻辑或
                if currentChar == "&" || currentChar == "|" {
                    //取出条件段落
                    let frontExp = condition.substringWithRange(condition.startIndex.advancedBy(numStartPoint)..<condition.startIndex.advancedBy(i))
                    switch symbol {
                    //逻辑与
                    case "&&":
                        //必须保证条件段落不为空
                        if !frontExp.isEmpty {
                            conditionValue = conditionValue && self.conditionCalculate(frontExp)
                        }
                        
                    //逻辑或
                    case "||":
                        //必须保证条件段落不为空
                        if !frontExp.isEmpty {
                            if self.conditionCalculate(frontExp) {
                                conditionValue = true
                                break conditionIf
                            }
                        }
                    //非运算
                    case "!":
                        conditionValue = !self.conditionCalculate(frontExp)
                    default:
                        break
                    }
                    
                    if currentChar == "&" {
                        symbol = "&&"
                    } else {
                        symbol = "||"
                    }
                    numStartPoint = i+1
                    
                }
            }
            
            //最后一位
            if numStartPoint < condition.characters.count {
                let frontExp = condition.substringWithRange(condition.startIndex.advancedBy(numStartPoint)..<condition.endIndex)
                switch symbol {
                //逻辑与
                case "&&":
                    //必须保证条件段落不为空
                    if !frontExp.isEmpty {
                        conditionValue = conditionValue && self.conditionCalculate(frontExp)
                        
                    }
                    
                //逻辑或
                case "||":
                    //必须保证条件段落不为空
                    if !frontExp.isEmpty {
                        if self.conditionCalculate(frontExp) {
                            conditionValue = true
                            break conditionIf
                        }
                    }
                //非运算
                case "!":
                    conditionValue = !self.conditionCalculate(frontExp)
                default:
                    break
                }
            }
            
            //单纯的表达式
        } else {
            conditionValue = self.conditionCalculate(condition)
        }
        
        //判断条件
        if conditionValue {
            return self.expressionCalculate(v1)
        } else {
            return self.expressionCalculate(v2)
        }
        
    }
    
    //条件判断运算
    func conditionCalculate(expression:String) -> Bool {
        
        
        //如果直接是字符串true 或 false
        if expression == "true" {
            return true
        } else if expression == "false" {
            return false
        }
        
        var conditionValue = true  //默认为true
        //遍历表达式
        for i in 0..<expression.characters.count {
            //当前符号
            let currentChar = expression.substringWithRange(expression.startIndex.advancedBy(i)...expression.startIndex.advancedBy(i))
            //前半部
            let frontExp = expression.substringWithRange(expression.startIndex..<expression.startIndex.advancedBy(i))
            //后半部
            var behindExp = ""
            //防止字符串越界
            if i+1 < expression.characters.count {
                behindExp = expression.substringWithRange(expression.startIndex.advancedBy(i+1)..<expression.endIndex)
            }
            
            switch currentChar {
            //> 和 >=
            case ">":
                //如果是 >=
                if behindExp.hasPrefix("=") {
                    behindExp.removeAtIndex(behindExp.startIndex)
                    let frontExpFloat = (self.expressionCalculate(frontExp) as NSString).floatValue
                    let behindExpFloat = (expressionCalculate(behindExp) as NSString).floatValue
                    conditionValue = frontExpFloat >= behindExpFloat
                } else {
                    let frontExpFloat = (self.expressionCalculate(frontExp) as NSString).floatValue
                    let behindExpFloat = (expressionCalculate(behindExp) as NSString).floatValue
                    conditionValue = frontExpFloat > behindExpFloat
                }
            //< 和 <=
            case "<":
                //如果是 <=
                if behindExp.hasPrefix("=") {
                    behindExp.removeAtIndex(behindExp.startIndex)
                    let frontExpFloat = (self.expressionCalculate(frontExp) as NSString).floatValue
                    let behindExpFloat = (expressionCalculate(behindExp) as NSString).floatValue
                    conditionValue = frontExpFloat <= behindExpFloat
                } else {
                    let frontExpFloat = (self.expressionCalculate(frontExp) as NSString).floatValue
                    let behindExpFloat = (expressionCalculate(behindExp) as NSString).floatValue
                    conditionValue = frontExpFloat < behindExpFloat
                }
            //==
            case "=":
                //如果是 ==
                if behindExp.hasPrefix("=") {
                    behindExp.removeAtIndex(behindExp.startIndex)
                    let frontExpFloat = (self.expressionCalculate(frontExp) as NSString).floatValue
                    let behindExpFloat = (expressionCalculate(behindExp) as NSString).floatValue
                    conditionValue = frontExpFloat == behindExpFloat
                }
            //!= 和
            case "!":
                //如果是 !=
                if behindExp.hasPrefix("=") {
                    behindExp.removeAtIndex(behindExp.startIndex)
                    let frontExpFloat = (self.expressionCalculate(frontExp) as NSString).floatValue
                    let behindExpFloat = (expressionCalculate(behindExp) as NSString).floatValue
                    conditionValue = frontExpFloat != behindExpFloat
                }
            default:
                break
            }
        }
        
        return conditionValue
    }
    
}