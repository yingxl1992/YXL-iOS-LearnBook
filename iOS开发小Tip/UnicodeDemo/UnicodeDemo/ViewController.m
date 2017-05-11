//
//  ViewController.m
//  UnicodeDemo
//
//  Created by yingxl1992 on 17/1/4.
//  Copyright © 2017年 yingxl1992. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    NSString *string = @"\\u6781\\u901f\\u8fbe=http://img30.360buyimg.com/mobilecms/g15/M08/01/02/rBEhWVLL0FUIAAAAAAAF_b40ki0AAHqzgJT20cAAAYV175.jpg;";
//    
//    NSLog(@"%@", [NSString stringWithCString:[string cStringUsingEncoding:NSUTF8StringEncoding]
//                                    encoding:NSNonLossyASCIIStringEncoding]);
//    return;
    
    NSError *error = nil;
    
    NSString *unicodeString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iconList"
                                                                                                 ofType:@"txt"]
                                                        encoding:NSUTF8StringEncoding
                                                           error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
    }
    else {
    
        NSMutableArray *tmpArray = [NSMutableArray array];
        NSArray *lines = [unicodeString componentsSeparatedByString:@";\\"];
        for (NSString *string in lines) {
            NSLog(@"%@", [NSString
                          stringWithCString:[string cStringUsingEncoding:NSUTF8StringEncoding]
                          encoding:NSNonLossyASCIIStringEncoding]);
            [tmpArray addObject:[self transformUnicodeStringToChinese:string]];
        }
        
        NSLog(@"%@", tmpArray);
    }
}

- (NSString *)transformUnicodeStringToChinese:(NSString *)unicodeString {
    
    if (unicodeString.length == 0) {
        return @"";
    }
    
    NSRange preRange = [unicodeString rangeOfString:@"\\u"];
    NSRange suRange = [unicodeString rangeOfString:@"=http"];
    
    NSString *preString = [unicodeString substringWithRange:NSMakeRange(0, preRange.location)];
    NSString *suString = [unicodeString substringFromIndex:suRange.location];
    NSString *midString = [unicodeString substringWithRange:NSMakeRange(preRange.location, unicodeString.length - preString.length - suString.length)];
    
    NSMutableString *originString = [NSMutableString string];
    NSArray *midArray = [self seperateMidString:midString];
    for (NSString *string in midArray) {
        [originString appendString:string];
    }
    
    suRange = [suString rangeOfString:@"http"];
    suString = [suString substringFromIndex:suRange.location];
    
    [originString appendString:[NSString stringWithFormat:@"：%@", suString]];
    
    return originString.copy;
}

- (NSArray<NSString *> *)seperateMidString:(NSString *)midString {
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    NSRange symbolRange = [midString rangeOfString:@"\\u"];
    
    while (1) {
        
        if (midString.length <= 6) {
            [tmpArray addObject:[NSString stringWithString:[NSString
                                                            stringWithCString:[midString cStringUsingEncoding:NSUTF8StringEncoding]
                                                            encoding:NSNonLossyASCIIStringEncoding]]];
            break;
        }
        
        NSString *tmpStr = [midString substringWithRange:NSMakeRange(symbolRange.location, 6)];
        [tmpArray addObject:[NSString stringWithString:[NSString
                                                        stringWithCString:[tmpStr cStringUsingEncoding:NSUTF8StringEncoding]
                                                        encoding:NSNonLossyASCIIStringEncoding]]];
        
        midString = [midString substringFromIndex:symbolRange.location + 6];
        symbolRange = [midString rangeOfString:@"\\u"];
    }
    
    return tmpArray.copy;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
