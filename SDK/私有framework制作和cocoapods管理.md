###私有framework制作和cocoapods管理

1、创建一个私有的spec索引库；假设是https://github.com/YXL/YXLSpec

2、将私有的spec索引库添加到CocoaPods目录下（~/.cocoapods/repos/）

`pod repo add YXLSpec https://coding.net/u/rxg9527/p/SpecRepo`

3、创建framework工程和对应的podspec文件

`pod lib create YXLDemo`

修改podspec文件

4、提交podspec文件

`pod repo push YXLSpec YXLDemo `

私有库会进行验证，一般需要加上两个选项才能成功

`--sources='https://coding.net/u/rxg9527/p/SpecRepo' --allow-warnings --use-libraries`

参考链接：<https://www.jianshu.com/p/36126b62909e>

