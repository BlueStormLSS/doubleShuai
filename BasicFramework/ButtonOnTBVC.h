//
//  ButtonOnTBVC.h
//  BasicFramework
//
//  Created by 我叫哀木涕 on 2017/2/21.
//  Copyright © 2017年 我叫哀木涕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonOnTBVC : UITableViewCell

@property (nonatomic,weak) UITableViewController *superVC;
- (void)tableViewCellButtonBeClicked:(UIViewController *)sender atIndex:(NSIndexPath *)index;
@end
