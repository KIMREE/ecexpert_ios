//
//  SellerSettingViewController.m
//  ECExpert
//
//  Created by JIRUI on 15/5/22.
//  Copyright (c) 2015年 JIRUI. All rights reserved.
//

#import "SellerSettingViewController.h"
#import "LoginViewController.h"
#import "GetDealer.h"

@interface SellerSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SellerSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NSLocalizedString(@"Account", @"");
    
    
    [self initLogOutAction];
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initLogOutAction{
    if ([[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory]==nil) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"LogIn", @"") style:UIBarButtonItemStylePlain target:self action:@selector(logInOrOut)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"LogOut", @"") style:UIBarButtonItemStylePlain target:self action:@selector(logInOrOut)];
        //获取数据
    }
}

-(void) logInOrOut{
    
    if ([[LocalStroge sharedInstance] getObjectAtKey:F_USER_INFORMATION filePath:NSDocumentDirectory]==nil) {
        
        LoginViewController *loginVC=[LoginViewController alloc];
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }else{
        
        
        UIAlertView *logoutV=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Logout", @"") message:NSLocalizedString(@"Are sure logout?", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"Sure", @""), nil];
        logoutV.tag = 101;
        [logoutV show];
    }
    
}

- (void)initTableView{
    CGFloat _x,_y,_w,_h;
    _w = KM_SCREEN_WIDTH,
    _x = 0;
    _y = 0;
    _h = KM_SCREEN_HEIGHT;
    if (self.navigationController) {
        _y = 64;
        _h -= 64;
    }
    if (self.tabBarController) {
        _h -= 49;
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(_x, _y, _w, _h) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = RGBA(0, 0, 0, 0.3);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        cell.textLabel.text=NSLocalizedString(@"Heart rate test", nil);
        cell.imageView.image = [UIImage imageNamed:@"heartRateTest"];
    }else if (section == 1){
        if (row == 0) {
            cell.textLabel.text=NSLocalizedString(@"About", nil);
            cell.imageView.image = [UIImage imageNamed:@"aboutUs"];
        }else if(row == 1){
            cell.textLabel.text=NSLocalizedString(@"Your suggestion", nil);
            cell.imageView.image = [UIImage imageNamed:@"feedBack"];
        }else if(row == 2){
            cell.textLabel.text=NSLocalizedString(@"Clear the cache", nil);
            cell.imageView.image = [UIImage imageNamed:@"clearCache"];
        }
    }else if (section == 2){
        if (row == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.textLabel.text=NSLocalizedString(@"Current version", nil);
            cell.imageView.image = [UIImage imageNamed:@"versionNumber"];
            NSDictionary* dict = [[NSBundle mainBundle] infoDictionary];
            cell.detailTextLabel.text=[dict objectForKey:@"CFBundleShortVersionString"];
        }else if(row == 1){
            cell.textLabel.text=NSLocalizedString(@"Comment", nil);
            cell.imageView.image = [UIImage imageNamed:@"Comment"];
        }else if(row == 2){
            cell.textLabel.text=NSLocalizedString(@"Wheel of Fortune", nil);
            cell.imageView.image = [UIImage imageNamed:@"Luck"];
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
    }else{
        return 2;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSLog(@"section: %lu    row: %lu", section, row);
}


#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        if (buttonIndex == 1) {
            self.navigationItem.rightBarButtonItem.title=NSLocalizedString(@"LogIn", @"");
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:API_LOGIN_SID];
            [[LocalStroge sharedInstance] deleteFileforKey:F_USER_INFORMATION filePath:NSDocumentDirectory];
            //加入通知,注销后主界面要进行刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_LOGOUT object:nil];
            //调用主视图方法注销
            [self.tableView reloadData];
            
            // 获取tabviewcontroller
            MainViewController *mainVC = (MainViewController *)self.tabBarController;
            NSMutableArray *vcArray = [NSMutableArray arrayWithArray:mainVC.viewControllers];
            // 移除当前controller
            NSInteger index = [vcArray indexOfObject:self.navigationController];
            [vcArray removeObject:self.navigationController];
            // 加载需要显示的viewcontroller
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            UINavigationController *loginNav = [mainVC UINavigationControllerWithRootVC:loginVC image:@"Me" title:@"Me"];
            
            // 重新拼装 tabviewcontroller， 并显示新添加进去的 viewcontroller
            [vcArray insertObject:loginNav atIndex:index];
            mainVC.viewControllers = vcArray;
            [mainVC setSelectedViewController:loginNav];
        }
    }
    if (alertView.tag == 102) {
        //清除缓存
        if (buttonIndex==1) {
            [self clearCache];
        }
        
    }
    
}

/**
 *  清理缓存
 */
-(void)clearCache{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       NSLog(@"files :%lu",(unsigned long)[files count]);
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [[[GetDealer shareInstance:nil] localArr] removeAllObjects];
                       
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
    
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
