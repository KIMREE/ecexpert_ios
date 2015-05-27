//
//  TradeRecordViewController.m
//  ECExpert
//
//  Created by JIRUI on 15/5/15.
//  Copyright (c) 2015年 JIRUI. All rights reserved.
//

#import "TradeRecordViewController.h"
#import "TradeOutputViewController.h"
#import "AFNetworking.h"

@interface TradeRecordViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation TradeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    switch (self.tradeRecordType) {
        case TradeRecordTypeCustomer:
            self.title = @"我的消费记录";
            break;
        case TradeRecordTypeDealer:
            self.title = @"交易记录";
            break;
        case TradeRecordTypeGift:
            self.title = @"派发赠品记录";
            break;
        default:
            break;
    }
    
    [self initData];
    [self initTableView];
}

- (void) initData{
    self.manager = [AFHTTPRequestOperationManager manager];
    [self.manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [self.manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [self.manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(_x, _y, _w, _h) style:UITableViewStylePlain];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.backgroundColor = RGBA(0, 0, 0, 0.3);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}


#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    
    TradeOutputViewController *tradeOutputVC = [[TradeOutputViewController alloc] init];
    tradeOutputVC.tradeRecordType = self.tradeRecordType;
    [self.navigationController pushViewController:tradeOutputVC animated:YES];
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
