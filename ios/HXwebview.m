//
//  HXwebview.m
//  horimobilern
//
//  Created by wuhy on 2020/11/12.
//

#import "HXwebview.h"
#import "HXBackButtonItem.h"
#import <WebKit/WebKit.h>

//屏幕宽
#define HX_ScreenWidth   [[UIScreen mainScreen] bounds].size.width

//屏幕高
#define HX_ScreenHeight  [[UIScreen mainScreen] bounds].size.height

@interface HXwebview ()<UIWebViewDelegate>
@property(nonatomic,strong) WKWebView *webView;
@end

@implementation HXwebview

#pragma mark 生命周期函数

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =  self.fileName;
    self.navigationController.navigationBar.barTintColor =[UIColor whiteColor];
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [HXBackButtonItem creatBackItemWithTarget:self action:@selector(backpage)];
    self.navigationItem.rightBarButtonItem =[HXBackButtonItem creatRightItemWithTarget:self action:@selector(moreAction)];
    
    [self loadWebViewWithUrl:@"https://www.baidu.com"];
}


- (BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}

-(void)loadWebViewWithUrl:(NSString *)url{
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, HX_ScreenWidth, HX_ScreenHeight-50)];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [self.view addSubview:webView];
    self.webView = webView;
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, webView.frame.size.height, HX_ScreenWidth, 50)];
    view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, HX_ScreenWidth/2, 50)];
    [back setTitle:@"上一页" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backWebView) forControlEvents:UIControlEventTouchUpInside];
    UIButton *next = [[UIButton alloc] initWithFrame:CGRectMake(HX_ScreenWidth/2, 0, HX_ScreenWidth/2, 50)];
    [next setTitle:@"下一页" forState:UIControlStateNormal];
    [next setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [next addTarget:self action:@selector(nextWebView) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:back];
    [view addSubview:next];
    
    [self.view addSubview:view];
    
    //检测网页进度观察者
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:0 context:nil];
    //检测网页title观察者
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HX_FILE_NOTIFICATION" object:nil];
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView){
        NSLog(@"网页加载进度：%f",self.webView.estimatedProgress);
    }else if([keyPath isEqualToString:NSStringFromSelector(@selector(title))] && object == self.webView){
        self.navigationItem.title = self.webView.title;
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark method
-(void)backpage{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)moreAction{
    NSLog(@"88888888====");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HX_FILE_NOTIFICATION" object:nil];
}

-(void)backWebView{
    NSLog(@"上一页");
    if(self.webView.canGoBack){
        [self.webView goBack];
    }
}

-(void)nextWebView{
    NSLog(@"下一页");
    if(self.webView.canGoForward){
        [self.webView goForward];
    }
}

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(title))];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
