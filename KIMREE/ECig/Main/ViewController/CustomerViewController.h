//
//  CustomerViewController.h
//  ECExpert
//
//  Created by JIRUI on 15/5/7.
//  Copyright (c) 2015年 JIRUI. All rights reserved.
//

#import "BaseViewController.h"

@interface CustomerViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *vipCardView;
@property (weak, nonatomic) IBOutlet UIView *showProductsView;
@property (weak, nonatomic) IBOutlet UIView *nearbyStoreView;
@property (weak, nonatomic) IBOutlet UIView *feedbackView;
@property (weak, nonatomic) IBOutlet UIView *recordView;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipNumberLabel;

@end
