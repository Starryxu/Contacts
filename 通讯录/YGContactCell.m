//
//  YGContactCell.m
//  通讯录
//
//  Created by 许亚光 on 16/6/4.
//  Copyright © 2016年 许亚光. All rights reserved.
//

#import "YGContactCell.h"
#import "YGContact.h"

@interface YGContactCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLBl;

@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;


@end
@implementation YGContactCell

-(void)setContact:(YGContact *)contact
{
    _contact = contact;
    
    _nameLBl.text = contact.name;
    _phoneLbl.text = contact.phoneNumber;
    
}

@end
