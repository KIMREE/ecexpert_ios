//
//  TradeOutputViewController.m
//  ECExpert
//
//  Created by JIRUI on 15/5/18.
//  Copyright (c) 2015年 JIRUI. All rights reserved.
//

#import "TradeOutputViewController.h"
#import "MainProductViewController.h"
#import "GiftProductViewController.h"
#import "AFNetworking.h"

@interface TradeOutputViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *customerArray;
@property (strong, nonatomic) NSMutableArray *dealerArray;
@property (strong, nonatomic) NSMutableArray *productArray;
@property (strong, nonatomic) NSMutableArray *giftArray;

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager; // 当界面为赠品记录时，可能会修改赠品派送数量，此时需要初始化

@end

@implementation TradeOutputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.UITableViewDataSource, UITableViewDelegate
    self.view.backgroundColor = [UIColor clearColor];
    self.title = @"交易记录详情";
    
    [self initTableView];
    
    if(self.tradeRecordType == TradeRecordTypeGift){
        self.manager = [AFHTTPRequestOperationManager manager];
        [self.manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
        [self.manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
        [self.manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(changeGiftRecord)];
    }
}

- (void)changeGiftRecord{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"派发赠品" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        NSLog(@"%lu", buttonIndex);
    }];
    
}

- (void)initTableView{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MMMM-dd hh:mm";
    
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
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(_x, _y, _w, 60)];
    CGRect headerFrame = headerView.frame;
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(headerFrame.origin.x, 10, headerFrame.size.width, 40);
    //    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"订单完成时间:%@",[dateFormatter stringFromDate:[NSDate date]]];
    [headerView addSubview:label];
    [self.view addSubview:headerView];
    
    
    _y += 60;
    _h -= 60;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(_x, _y, _w, _h) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = RGBA(0, 0, 0, 0.3);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //    cell.textLabel.textColor = RGB(153, 138, 141);
    //    cell.detailTextLabel.textColor = RGB(153, 138, 141);
    
    if (indexPath.section == 0) {
        if (self.customerArray.count > 0) {
            cell.textLabel.text = [self.customerArray firstObject];
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"没有用户信息";
        }
        
    }else if (indexPath.section == 1){
        if (self.productArray.count > 0) {
            ProductModel *product = [self.productArray objectAtIndex:indexPath.row];
            cell.textLabel.text = product.productNameZH.length > 0 ? product.productNameZH: product.productNameEN;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"数量:%zi",product.totalCount];
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"没有商品数据";
        }
        
    }else if (indexPath.section == 2){
        if (self.giftArray.count > 0) {
            ProductModel *product = [self.giftArray objectAtIndex:indexPath.row];
            cell.textLabel.text = product.productNameZH;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"总数量:%zi    已派发:%zi",product.totalCount, product.dispatchCount];
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"没有赠品数据";
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return self.productArray.count > 0? self.productArray.count : 1;
    }else{
        return self.giftArray.count > 0? self.giftArray.count : 1;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        if (self.tradeRecordType == TradeRecordTypeCustomer && self.dealerArray.count > 0) {
            NSLog(@"卖家信息");
        }
        if (self.tradeRecordType == TradeRecordTypeDealer && self.customerArray.count > 0) {
            NSLog(@"买家信息");
        }
    }else if (section == 1 && self.productArray.count > 0){
        
        MainProductViewController *mainProductVC = [[MainProductViewController alloc] init];
        mainProductVC.supTableView = self.tableView;
        mainProductVC.isEdit = NO;
        mainProductVC.productArray = self.productArray;
        mainProductVC.mainProduct = self.productArray[row];
        
        [self.navigationController pushViewController:mainProductVC animated:YES];
        
    }else if (section == 2 && self.giftArray.count > 0){
        
        GiftProductViewController *giftVC = [[GiftProductViewController alloc] init];
        giftVC.supTableView = self.tableView;
        giftVC.giftArray = self.giftArray;
        giftVC.giftProduct = self.giftArray[row];
        giftVC.pageEditType = GiftPageEditTypeNone;// 仅仅查看交易记录
        if (self.tradeRecordType == TradeRecordTypeGift) {
            giftVC.pageEditType = GiftPageEditTypeDispatch; // 赠品看路查询中，可以进行派发赠品操作
        }
        
        [self.navigationController pushViewController:giftVC animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
//    sectionHeaderView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    sectionHeaderView.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = [UIColor whiteColor];
    title.frame = CGRectMake(10, (40 - 21) / 2.0, 100, 21);
    
    [sectionHeaderView addSubview:title];
    
    if (section == 0) {
        switch (self.tradeRecordType) {
            case TradeRecordTypeCustomer:
                title.text = @"卖家";
                break;
            case TradeRecordTypeDealer:
                title.text = @"买家";
                break;
            case TradeRecordTypeGift:
                title.text = @"买家";
                break;
            default:
                break;
        }
    }else if (section == 1){
        title.text = @"商品列表";
    }else{
        title.text = @"赠品列表";
    }

    return sectionHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *sectionFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    sectionFooterView.backgroundColor = [UIColor clearColor];
    
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(0, 0, KM_SCREEN_WIDTH, 1);
//    label.backgroundColor = [UIColor whiteColor];
//    [sectionFooterView addSubview:label];
    
    return sectionFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 20;
//}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
