//
//  DTDecimalLabel.h
//  det-ios
//
//  Created by Justin Huang on 11/20/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kWIDTH_DECIMAL 25.0f

@interface DTDecimalLabel : UILabel

+ (id)labelAsNumber:(NSString *)number;

@end
