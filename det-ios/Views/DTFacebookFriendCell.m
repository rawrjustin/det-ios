//
//  DTFacebookFriendCell.m
//  det-ios
//
//  Created by Justin Huang on 12/13/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import "DTFacebookFriendCell.h"

@implementation DTFacebookFriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(72.0f, 0.0f, 270.0f, 44.0f)];
        self.nameLabel.font = [DTFonts proximaNovaRegularSize:20.0f];
        self.nameLabel.textColor = [DTColors darkGrayColor];
        [self.contentView addSubview:self.nameLabel];
        
        self.profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(16.0f, 2.0f, 40.0f, 40.0f)];
        [self.contentView addSubview:self.profilePicture];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
