//
//  LeftViewController.h
//  酒店客房管理系统
//
//  Created by Shadow on 2017/12/13.
//  Copyright © 2017年 shadow2017. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftViewControllerDelegate<NSObject>

- (void)clickedRowAtIndex:(NSIndexPath *)indexPath;

@end

@interface LeftViewController : UIViewController

@property (nonatomic, assign) id <LeftViewControllerDelegate> delegate;

@end
