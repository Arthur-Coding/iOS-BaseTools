#README
##V1.0

###注：1.Tools中，不需要再调用头文件即可直接调用；
###   2.基础开发包中，除“版本升级”外，其他都需要根据具体使用调用头文件。

###1.引导页，根据是否加载网络图片和本地图片选择不同引导页视图。
###2.应用启动页，若只是简单的布局，可以使用LaunchScreen.storyboard，也可以使用LaunchVC；若比较复杂，对启动时间有其他要求，使用LaunchVC。
###3.
####网络请求统一用AFNetworking
####图片加载统一用SDWebImage
####图片浏览（类似于微信朋友群图片查看）统一用PhotoBrowser或SDPhotoBrowser,
####图片相册处理（相册选择，单双选、多选、视频、单选正方形裁剪等）统一用PhotoAlbum（简单的相册图片选择使用调用系统相册即可）
####上下拉刷新统一用MJRefresh
####手动约束布局统一用Masonry
####防止键盘遮挡输入框统一用IQKeyboardManager
####加载动画统一用MBProgressHUD，并结合MBProgressHUD-BWMExtension
####图表视图统一用iOS-Echarts
