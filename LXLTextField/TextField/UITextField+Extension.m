//
//  UITextField+Extension.m
//  LXLTextField
//
//  Created by XNB4 on 2018/1/31.
//  Copyright © 2018年 XNB4. All rights reserved.
//

#import "UITextField+Extension.h"
#import <objc/runtime.h>

static const char *kBlockActionKey = "kBlockActionKey";
#define kMaxLength 50
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//设置十六进制颜色
#define HEXCOLORj(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]


@implementation UITextField (Extension)
/**
 *  输入框限制输入处理保留两位小数点方法
 */
- (void)moneyTFDidTextChanged:(NSInteger)numEnob{
    
    if([self.text hasPrefix:@"0"] && self.text.length == 2){//如果用户第一输入了0，那么就不能让用户继续输入0~9的数字了
        NSString *subString = [self.text substringFromIndex:1];
        if (([subString integerValue] >0 && [subString integerValue] <= 9) || [subString isEqualToString:@"0"]) {
            self.text = [self.text substringToIndex:1];
        }
    }else if (self.text.length > numEnob && ![self.text containsString:@"."]){  //如果输入不为'.',则限制输入位数
        self.text = [self.text substringToIndex:numEnob];
    }
    
    if ([self.text containsString:@"."]) {//如果输入的文本中含有小数点,则进入该方法
        NSRange range = [self.text rangeOfString:@"."];
        
        if (range.location == 0) {//如果小数点位置是第一位，则默认为0.
            self.text = @"0.";
        }else{//说明小数点的位置不是第一位
            if (self.text.length > 2) {
                NSString *subString = [self.text substringFromIndex:range.location + 1];//取出小数点后面的字符串
                subString = [subString stringByReplacingOccurrencesOfString:@"." withString:@""]; //将用户多输入的'.'去除
                if (subString.length > 2) {//小数点后面保留2位
                    subString = [subString substringToIndex:2];
                }
                if ([self.text hasPrefix:@"0."]) {
                    self.text = [NSString stringWithFormat:@"0.%@",subString];
                }else{
                    NSString *subString1 = [self.text substringToIndex:range.location];
                    self.text = [NSString stringWithFormat:@"%@.%@",subString1,subString];//拼接新的字符串
                }
            }
        }
    }
}


- (void)numberTFDidTextChanged:(NSInteger)numEnob{
    
    if (self.text.length > numEnob && ![self.text containsString:@"."]){  //如果输入不为'.',则限制输入位数
        self.text = [self.text substringToIndex:numEnob];
    }
    
    if ([self.text containsString:@"."]) {//如果输入的文本中含有小数点,则进入该方法
        NSRange range = [self.text rangeOfString:@"."];
        
        if (range.location == 0) {//如果小数点位置是第一位，则默认为0.
            self.text = @"0.";
        }else{//说明小数点的位置不是第一位
            if (self.text.length > 2) {
                NSString *subString = [self.text substringFromIndex:range.location + 1];//取出小数点后面的字符串
                subString = [subString stringByReplacingOccurrencesOfString:@"." withString:@""]; //将用户多输入的'.'去除
                if (subString.length > 2) {//小数点后面保留2位
                    subString = [subString substringToIndex:2];
                }
                if ([self.text hasPrefix:@"0."]) {
                    self.text = [NSString stringWithFormat:@"0.%@",subString];
                }else{
                    NSString *subString1 = [self.text substringToIndex:range.location];
                    self.text = [NSString stringWithFormat:@"%@.%@",subString1,subString];//拼接新的字符串
                }
            }
        }
    }
}


-(void)addToolSender{
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 5, 50, 25);
    [btn addTarget:self action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    btn.tintColor = HEXCOLORj(0x1696ce);
    [btn setTitleColor:HEXCOLORj(0x0090ff) forState:UIControlStateNormal];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    
    self.inputAccessoryView = topView;
}

- (void)addToolSenderWithBlock:(void(^)())block{
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 5, 50, 25);
    [btn addTarget:self action:@selector(resignFirstResponderAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    //HEXCOLORj(0x0090ff)
    [btn setTitleColor:HEXCOLORj(0x696ce) forState:UIControlStateNormal];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    
    if (block && !objc_getAssociatedObject(self, &kBlockActionKey)) {
        objc_setAssociatedObject(self, &kBlockActionKey, block, OBJC_ASSOCIATION_COPY);
    }
    self.inputAccessoryView = topView;
}
-(void)resignFirstResponderAction{
    
    void(^block)() = objc_getAssociatedObject(self, &kBlockActionKey);
    
    if (block) {
        block();
    }
}


- (NSString *)disable_emoji:(NSString *)text{
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

/**
 *  判断字符串中是否存在emoji 限制第三方键盘（常用的是搜狗键盘）的表情
 * @param string 字符串
 * @return YES(含有表情)
 */
- (BOOL)hasEmoji:(NSString*)string
{
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

/**
 *  判断字符串中是否存在emoji 限制系统键盘自带的表情
 * @param string 字符串
 * @return YES(含有表情)
 */
- (BOOL)stringContainsEmoji:(NSString *)string {
    
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

/**
 判断是不是九宫格
 @param string  输入的字符
 @return YES(是九宫格拼音键盘)
 */
-(BOOL)isNineKeyBoard:(NSString *)string
{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i=0;i<len;i++)
    {
        if(!([other rangeOfString:string].location != NSNotFound))
            return NO;
    }
    return YES;
}


@end
