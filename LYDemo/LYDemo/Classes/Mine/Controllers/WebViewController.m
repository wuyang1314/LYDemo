//
//  WebViewController.m
//  LYDemo
//
//  Created by liyang on 2018/1/4.
//  Copyright © 2018年 kosien. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

#define URLString @"http://m.langfangtong.cn/activity/report"

@interface WebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网页";
    
    [self.view addSubview:self.webView];
    [self loadRequest];
}




#pragma mark - Private Methods

- (void)loadRequest
{
    //先取出容器中的cookie
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [cookieDic setObject:cookie.value forKey:cookie.name];
    }
    
    //cookie去重，重组
    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];
    for (NSString *key in cookieDic) {
        [cookieValue appendString:[NSString stringWithFormat:@"%@=%@;", key, cookieDic[key]]];
    }
    [cookieValue appendString:@"aid=7324"];
    NSLog(@"cookieValue = %@", cookieValue);
    
    //添加cookie，加载网页
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    [request addValue:cookieValue forHTTPHeaderField:@"Cookie"];
    [self.webView loadRequest:request];
}




#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *absoluteString = navigationAction.request.URL.absoluteString;
    NSLog(@"发送请求之前决定是否跳转：Action-clickSchem = %@", absoluteString);
    
    if ([absoluteString isEqualToString:@"lftapp://login"]) {
        [Tools showAlertViewOfSystemWithTitle:@"提示" andMessage:@"未登录"];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSLog(@"收到响应后，决定是否跳转：clickSchem = %@", navigationResponse.response.URL.absoluteString);

    decisionHandler(WKNavigationResponsePolicyAllow);
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"页面开始加载");
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"内容开始返回");
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"页面加载完成");
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"页面加载失败");
}




#pragma mark - Getters and Setters

- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVBAR_HEIGHT)];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _webView.backgroundColor = WHITECOLOR;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

@end