//
//  DTFonts.m
//  det-ios
//
//  Created by Justin Huang on 11/17/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import "DTFonts.h"

@implementation DTFonts

+ (UIFont*)proximaNovaRegularSize:(CGFloat)size {
    return [UIFont fontWithName:@"ProximaNova-Regular" size:size];
}
+ (UIFont*)proximaNovaBoldSize:(CGFloat)size {
    return [UIFont fontWithName:@"ProximaNova-Bold" size:size];
}
+ (UIFont*)proximaNovaSemiboldSize:(CGFloat)size {
    return [UIFont fontWithName:@"ProximaNova-Semibold" size:size];
}
+ (UIFont*)proximaNovaSemiboldItalicSize:(CGFloat)size {
    return [UIFont fontWithName:@"ProximaNova-SemiboldIt" size:size];
}

@end
