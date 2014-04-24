//
//  UIDevice+SystemVersionNumber.m
//  LMAlertViewDemo
//
//  Created by Lin Cheng Kai on 14/4/24.
//  Copyright (c) 2014年 Bestir Ltd. All rights reserved.
//

#import "UIDevice+SystemVersionNumber.h"
#import <objc/runtime.h>

const char SYS_VER_NUM_KEY;
@implementation UIDevice (SystemVersionNumber)
- (float)systemVersionNumber
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *sysVer = [UIDevice currentDevice].systemVersion;
        NSError *error = nil;
        NSRegularExpression *regexp =[NSRegularExpression regularExpressionWithPattern:@"\\d.\\d" options:0 error:&error];
        NSTextCheckingResult *result = [regexp firstMatchInString:sysVer options:0 range:NSMakeRange(0, [sysVer length])];
        
        NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
        numFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *versionNumber = [numFormatter numberFromString:[sysVer substringWithRange:result.range]];
        
        objc_setAssociatedObject(self, &SYS_VER_NUM_KEY, versionNumber, OBJC_ASSOCIATION_ASSIGN);
    });
    
    NSNumber *sysVerNum = objc_getAssociatedObject(self, &SYS_VER_NUM_KEY);
    return [sysVerNum floatValue];
}
@end
