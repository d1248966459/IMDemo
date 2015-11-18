//
//  NTESSearchTeamViewController.m
//  NIM
//
//  Created by Xuhui on 15/3/19.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESSearchTeamViewController.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
#import "NTESJionTeamViewController.h"
//#import "IMService.h"

@interface NTESSearchTeamViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation NTESSearchTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"搜索加入群组";
    self.textField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField endEditing:YES];
//    [IMService checkGroupnumisJoin:nil groupnum:textField.text callback:^(id obj1, id obj2) {
//        NSDictionary *back_dic = obj1;
//        if (obj1)
//        {
//            BOOL success = [[back_dic objectForKey:@"success"] boolValue];
//            if (success)
//            {
//                [self joinGroup:textField.text];
//            }
//            else
//            {
//                NSString *msg = [back_dic objectForKey:@"msg"];
//                [ShowMessage showMessage:msg];
//            }
//        }
//    }];
//    
    return YES;
}
-(void)joinGroup:(NSString*)groupnum
{
    [SVProgressHUD show];
    [[NIMSDK sharedSDK].teamManager fetchTeamInfo:groupnum completion:^(NSError *error, NIMTeam *team) {
        [SVProgressHUD dismiss];
        if(!error) {
            NTESJionTeamViewController *vc = [[NTESJionTeamViewController alloc] initWithNibName:nil bundle:nil];
            vc.joinTeam = team;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self.view makeToast:error.localizedDescription];
            DDLogDebug(@"Fetch team info failed: %@", error.localizedDescription);
        }
    }];

}

@end
