<p align="center">
<img src="https://cdn.idealclover.cn//MomentMachine/ic_launcher.png" alt="Moment Machine" width="100">
</p>
<h1 align="center">Moment Machine /  时光鸡</h1>

> ✨愿未来能让人有所期待。

## 这是什么

[ihewro](https://www.ihewro.com) 的 [handsome](https://www.ihewro.com/archives/489/) 主题提供了一个很好的 idea：即可以在Typecho 博客中建立一个独立页面，通过评论的形式展示自己的心情动态，提供一个类似个人推特的形式，我们一般叫它时光机。

![](https://cdn.idealclover.cn/Blog/19.05.10%20%E6%97%B6%E5%85%89%E6%9C%BA%20v1.0/1.png)

后来即使是不再使用这个主题了，但时光机这个功能还是令自己难忘，并移植到了自己的[主题](https://github.com/idealclover/clover)之中（暂仍处于开发阶段）。

handsome 作者的时光机在 [这里](https://www.ihewro.com/cross.html)，傻翠的因为太过羞耻就先不放了，有兴趣的可以自行搜寻。

于是傻翠用 flutter 做了一个~~理论上跨平台~~的APP，可以实现查看时光机，发送时光机的功能，就不用再打开电脑再发送了。

![](https://cdn.idealclover.cn/Blog/19.05.10%20%E6%97%B6%E5%85%89%E6%9C%BA%20v1.0/2.png)

这款 APP 背后与 Typecho 后端通信的接口可以切换 Typecho 原生的 XMLRPC 或 第三方的 Restful 插件。这意味着并不需要过多配置，你便可以轻松接入。

总之，如果你也拥有 Typecho 博客，也想自建时光机；或者如果你也使用 handsome 主题，那就来试试吧！


<!--more-->


## 如何使用

Android：在 [release](https://github.com/idealclover/MomentMachine/releases) 或 [蒲公英内侧平台](https://www.pgyer.com/momentmachine) 或 ~~[酷安]()~~ 中下载打包好的 apk 包并安装

苹果：傻翠没钱买开发者账号，可以选择**捐钱给傻翠**或联系我帮助上架。

如果使用默认的 XML 接口，需要在``` Typecho 后台 - 设置 - 评论``` 中 将 ```开启反垃圾保护``` 关闭。对于仍然需要反垃圾保护的情况，我们推荐使用 [CommentFilter-typecho](https://github.com/jrotty/CommentFilter-typecho) 插件，并在插件设置中将 ```屏蔽机器人评论``` 关闭。

如果使用第三方 Restful 插件，可以在 [这里](https://github.com/moefront/typecho-plugin-Restful) 进行下载与安装，并且需要 **自定义 URI 前缀为 ```restful```**。


进入 APP 中后会提示设置，在设置完```网站```，```cid```，```用户名```和```密码```后即可测试使用。

## Minimum Viable Product

- [x] 评论获取改为xmlrpc
- [ ] 标题改成中文
- [x] 头像邮箱信息
- [x] 检查更新集成bugly
- [x] 评论markdown
- [x] 第一次使用提示设置
- [x] 自动保存 
- [x] 捐赠页

## Next TODOs

- [ ] 支持图片
- [ ] 支持音频/视频
- [ ] 更换主题
- [ ] 美化

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
