//
//  CustomerViewController.m
//  ECExpert
//
//  Created by JIRUI on 15/5/7.
//  Copyright (c) 2015年 JIRUI. All rights reserved.
//

#import "CustomerViewController.h"
#import "NearbyViewController.h"
#import "JRWebViewController.h"
#import "MemberSettingViewController.h"
#import "ShowQRCodeViewController.h"
#import "TradeRecordViewController.h"

@interface CustomerViewController () <UITextViewDelegate>

@property (strong,nonatomic) UITextView *information;
@property (strong,nonatomic) ASIFormDataRequest *request;
@property (strong, nonatomic) UIViewController *feedbackVC;

@end

@implementation CustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.translucentTabBar = YES;
    self.translucentNavigationBar = YES;
    
    
    self.title = @"会员中心";
    
    // 初始化界面数据
    [self initPageInfo];
    
    // 点击手势
    [self initTapGR];
    
    // 右上方 设置按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(settingAction)];
}

- (void)initPageInfo{
    NSString *userName = [[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"customer_nickname"];
    if (userName.length == 0) {
        userName = [[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"customer_name"];
    }
    self.userNameLabel.text = userName;
    self.vipNumberLabel.text = [[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"customer_vip"];
    
    if ([[[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"customer_headimage"] isEqualToString:@""]) {
        [self.userImageView setImage:[UIImage imageNamed:@"accountHeader"]];
    }else{
        [self.userImageView setImageWithURL:[NSURL URLWithString:[[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"customer_headimage"]]];
        self.userImageView.layer.masksToBounds = YES;
        self.userImageView.layer.cornerRadius = 41.5;
        self.userImageView.layer.borderWidth = 3;
        self.userImageView.layer.borderColor = RGB(202, 201, 200).CGColor;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)settingAction{
    [self.navigationController pushViewController:[[MemberSettingViewController alloc] init] animated:YES];
}

- (void)initTapGR{
    
    // 会员卡
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(vipCardTapAction)];
    [self.vipCardView addGestureRecognizer:singleTap];
    
    // 产品展示
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProductsTapAction)];
    [self.showProductsView addGestureRecognizer:singleTap];
    
    // 周边体验店
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nearbyStoreTapAction)];
    [self.nearbyStoreView addGestureRecognizer:singleTap];
    
    // 我的记录
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recordTapAction)];
    [self.recordView addGestureRecognizer:singleTap];
    
    // 用户反馈
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(feedbackTapAction)];
    [self.feedbackView addGestureRecognizer:singleTap];
    
}

- (void)vipCardTapAction{
    NSString *customerId = [[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"customer_id"];
    NSString *customerVip = [[[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory] objectForKey:@"customer_vip"];
    
    ShowQRCodeViewController *showQRCode = [[ShowQRCodeViewController alloc] init];
    showQRCode.qrcodeInfo = [NSString stringWithFormat:@"{\"customer_id\":%@, \"customer_vip\":%@}", customerId, customerVip];
    showQRCode.title = @"出示会员卡";
    [self.navigationController pushViewController:showQRCode animated:YES];
}

- (void)showProductsTapAction{
    JRWebViewController *webVC=[[JRWebViewController alloc] init];
    webVC.URL=[NSURL URLWithString:@"http://www.kimree.com.cn"];
    webVC.mode=WebBrowserModeModal;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)nearbyStoreTapAction{
//    [self.navigationController pushViewController:[[NearbyViewController alloc] init] animated:YES];
    [self.tabBarController setSelectedIndex:1];
}

- (void)recordTapAction{
    TradeRecordViewController *tradeRecordVC = [[TradeRecordViewController alloc] init];
    tradeRecordVC.tradeRecordType = TradeRecordTypeCustomer;
    [self.navigationController pushViewController:tradeRecordVC animated:YES];
}

- (void)feedbackTapAction{
    [self feedback];
}

//feedback view
-(void)feedback{
    UIViewController *feedbackVC=[[UIViewController  alloc] init];
    self.feedbackVC = feedbackVC;
    feedbackVC.view.backgroundColor=COLOR_WHITE_NEW;
    feedbackVC.title=NSLocalizedString(@"Feedback", nil);
    
    UILabel *firsthint =[[UILabel alloc] init];
    [self labelInit:firsthint name:@"Please fill in your questions and suggestions" size:CGRectMake(10, 75, 310, 40) numerOfLines:2 fontSize:14];
    firsthint.textColor=COLOR_DARK_GRAY;
    firsthint.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:15];
    [feedbackVC.view addSubview:firsthint];
    
    _information = [[UITextView alloc] initWithFrame:CGRectMake(10, 115, 300, 130)];
    _information.layer.cornerRadius = 6;
    _information.layer.masksToBounds = YES;
    _information.backgroundColor =COLOR_BACKGROUND;
    _information.autocorrectionType = UITextAutocorrectionTypeNo;
    _information.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _information.returnKeyType = UIReturnKeyDone;
    _information.font = [UIFont systemFontOfSize:14];
    _information.delegate = self;
    [feedbackVC.view addSubview:_information];
    
    
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self buttonInit:submit action:@selector(sendFeedback) size:CGRectMake(10.0, 260, 300.0, 40.0) name:NSLocalizedString(@"Submit", @"")];
    submit.backgroundColor=COLOR_LIGHT_BLUE_THEME;
    submit.layer.masksToBounds=YES;
    submit.layer.cornerRadius=4;
    
    [feedbackVC.view addSubview:submit];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [feedbackVC.view addGestureRecognizer:tapGr];
    
    
    [self.navigationController pushViewController:feedbackVC animated:YES];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
    
    if ([@"\n" isEqualToString:text] == YES) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self.feedbackVC.view endEditing:YES];
}

//初始化方法
-(void)labelInit:(UILabel*)label name:(NSString*)string size:(CGRect)frame numerOfLines:(int)num fontSize:(int)size{
    label.text=NSLocalizedString(string, @"");
    label.textColor=COLOR_WHITE_NEW;
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=NSTextAlignmentLeft;
    label.frame = frame;
    label.numberOfLines=num;
    //  label.font = [UIFont fontWithName:@"Helvetica" size:size];
    label.font =[UIFont boldSystemFontOfSize:size];
}

-(void) buttonInit:(UIButton*)button action:(SEL)action size:(CGRect)frame name:(NSString*)name{
    
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor=[UIColor clearColor];
    button.frame = frame;
    [button setTitleColor:COLOR_WHITE_NEW forState:UIControlStateNormal];
    [button setTitle:name forState:UIControlStateNormal];
}


#pragma mark  ----------send email
-(void)sendFeedback
{
    if ([_information.text isEqualToString:@""]) {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"No content submit", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles: nil];
        alertView.tag=100;
        [alertView show];
    }else
    {
        [self LinkNetWork:API_FEEDBACK_URL];
    }
}



#pragma -mark
#pragma -mark 网络请求

- (void)LinkNetWork:(NSString *)strUrl
{
    _request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    
    [_request setDelegate:self];
    [_request setShouldAttemptPersistentConnection:NO];
    [_request setTimeOutSeconds:10];
    [_request setPostValue:_information.text forKey:@"question_content"];
    // [MMProgressHUD showWithTitle:nil status:NSLocalizedString(@"submit...", "")];
    [_request startAsynchronous];
}

- (void)requestFailed:(ASIFormDataRequest *)request
{
    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Failed to connect link to server!", "") dismissAfter:1.0f];
}

- (void)requestFinished:(ASIFormDataRequest *)request
{
    NSData *jsonData = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSMutableDictionary *rootDic = [[CJSONDeserializer deserializer] deserialize:jsonData error:&error];
    int status=[[rootDic objectForKey:@"code"] intValue];
    if (status==1) {
        //[MMProgressHUD dismissWithSuccess:[rootDic objectForKey:@"msg"]];
        [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Successful submission!", "") dismissAfter:1.0f];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else
    {
        // [MMProgressHUD dismissWithError:[rootDic objectForKey:@"data"]];
        [JDStatusBarNotification showWithStatus:[rootDic objectForKey:@"data"] dismissAfter:1.0f];
        
        [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Failed to connect link to server!", "") dismissAfter:1.0f];
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
