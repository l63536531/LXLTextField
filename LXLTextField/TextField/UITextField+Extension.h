//
//  UITextField+Extension.h
//  LXLTextField
//
//  Created by XNB4 on 2018/1/31.
//  Copyright © 2018年 XNB4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Extension)
/**
 *  限制输入带小数点保留两位小数
 *
 *  @param numEnob 有效位数
 */
- (void)moneyTFDidTextChanged:(NSInteger)numEnob;
/** 限制输入数字位数（不带小数）*/
- (void)numberTFDidTextChanged:(NSInteger)numEnob;

/**
 *  添加工具栏,完成退出键盘
 */
-(void)addToolSender;
-(void)addToolSenderWithBlock:(void(^)())block;

/**
 禁用表情
 */
- (NSString *)disable_emoji:(NSString *)text;

/**
 *  判断字符串中是否存在emoji 限制第三方键盘（常用的是搜狗键盘）的表情
 * @param string 字符串
 * @return YES(含有表情)
 */
- (BOOL)hasEmoji:(NSString *)string;

/**
 *  判断字符串中是否存在emoji 限制系统键盘自带的表情
 * @param string 字符串
 * @return YES(含有表情)
 */
- (BOOL)stringContainsEmoji:(NSString *)string;

/**
 判断是不是九宫格
 @param string  输入的字符
 @return YES(是九宫格拼音键盘)
 */
-(BOOL)isNineKeyBoard:(NSString *)string;


@end
