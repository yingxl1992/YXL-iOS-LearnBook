1. 字体自适应

```objective-c

UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
label.adjustsFontSizeToFitWidth = YES;//必须与minimumScaleFactor共同存在
label.minimumScaleFactor = 0.2;// iOS6.0 +, 数值在0-1.0

```
