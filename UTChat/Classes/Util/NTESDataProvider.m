//
//  NTESUserDataProvider.m
//  NIM
//
//  Created by amao on 8/13/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NTESDataProvider.h"

@implementation NTESDataProvider

- (NIMKitInfo *)infoByUser:(NSString *)userId{
    NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:userId];
    if (user) {
        //如果本地有数据则直接返回
        NIMKitInfo *info = [[NIMKitInfo alloc] init];
        info.infoId      = userId;
        info.showName    = user.userInfo.nickName.length ? user.userInfo.nickName : userId;
        //info.showName    = user.userInfo.nickName;
        if ([user.userInfo.nickName isEqualToString:[Userinfo getUserName]])
        {
            info.avatarImage = [UIImage imageNamed:@"ic_my_computer"];
        }
        else
        {
            info.avatarImage = [UIImage imageNamed:@"DefaultAvatar"];
        }
        
        info.avatarUrlString = user.userInfo.thumbAvatarUrl;
        return info;
    }else{
        //如果本地没有数据则去自己的应用服务器请求数据
        [[NIMSDK sharedSDK].userManager fetchUserInfos:@[userId] completion:^(NSArray *users, NSError *error) {
            if (!error) {
                [[NIMKit sharedKit] notfiyUserInfoChanged:userId];
            }
        }];
        //先返回一个默认数据,以供网络请求没回来的时候界面可以有东西展示
        NIMKitInfo *info = [[NIMKitInfo alloc] init];
        info.showName    = userId; //本地没有昵称，拿userId代替
        info.avatarImage = [UIImage imageNamed:@"DefaultAvatar"]; //默认占位头像
        return info;
    }
}

- (NIMKitInfo *)infoByTeam:(NSString *)teamId{
    NIMTeam *team    = [[NIMSDK sharedSDK].teamManager teamById:teamId];
    NIMKitInfo *info = [[NIMKitInfo alloc] init];
    info.showName    = team.teamName;
    info.infoId      = teamId;
    if (team.type == 0)
    {
        info.avatarImage = [UIImage imageNamed:@"discuss_normal"];
    }
    else
    {
        if (![team.serverCustomInfo isEqualToString:@""])
        {
            NSDictionary *dic = [team.serverCustomInfo JSONValue];
            BOOL sys = [[dic objectForKey:@"sys"] boolValue];
            if (sys)
            {
                info.avatarImage = [UIImage imageNamed:@"sys_group_normal"];
            }
            else
            {
                info.avatarImage = [UIImage imageNamed:@"youke_group_normal"];
            }
        }
        else
        {
            info.avatarImage = [UIImage imageNamed:@"youke_group_normal"];
        }
    }
    return info;
}



@end
