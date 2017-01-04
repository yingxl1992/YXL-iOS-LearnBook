###iOS开发小Tip

#### 1. Unicode编码转中文输出


```objective-c

NSString *string = @"\\u6781\\u901f\\u8fbe=http://img30.360buyimg.com/mobilecms/g15/M08/01/02/rBEhWVLL0FUIAAAAAAAF_b40ki0AAHqzgJT20cAAAYV175.jpg;";
    
NSLog(@"%@", [NSString stringWithCString:[string cStringUsingEncoding:NSUTF8StringEncoding]
                                    encoding:NSNonLossyASCIIStringEncoding]);
                                    
\\输出：极速达=http://img30.360buyimg.com/mobilecms/g15/M08/01/02/rBEhWVLL0FUIAAAAAAAF_b40ki0AAHqzgJT20cAAAYV175.jpg;

```