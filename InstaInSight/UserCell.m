//
//  UserCell.m
//  InstaInSight
//
//  Created by Verma Mukesh on 19/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.imgProfile setClipsToBounds:YES];
    [[self.imgProfile layer] setCornerRadius:20];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
