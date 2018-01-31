//
//  ViewController.m
//  LXLTextField
//
//  Created by XNB4 on 2018/1/31.
//  Copyright © 2018年 XNB4. All rights reserved.
//

#import "ViewController.h"
#import "UITextField+Extension.h"
#define kMaxLength 20
@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)UITextField * textField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(100, 200, 150, 30)];
    textField.backgroundColor = [UIColor redColor];
    textField.delegate = self;
    self.textField = textField;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification" object:textField];
    
    [self.textField addToolSenderWithBlock:^{
        NSLog(@"完成");
    }];
    [self.view addSubview:textField];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing = %@",textField.text);
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn = %@",textField.text);
    [self.view endEditing:YES];
   
    
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"textField = %@  range = %@ string = %@",textField.text,NSStringFromRange(range),string);
     NSLog(@"是否包含表情:%@",  [textField hasEmoji:textField.text]?@"有":@"没有");
    return YES;
}


-(void)textFieldEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > kMaxLength)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:kMaxLength];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, kMaxLength)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.textField];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
