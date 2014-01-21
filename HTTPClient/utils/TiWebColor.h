//
//  TiWebColor.h
//  HTTPClient
//
//  Created by Pedro Enrique on 1/20/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TiWebColor : NSObject

+(UIColor*)checkmarkColor;

/**
 Returns web color by name.
 @param colorName The color name.
 @return The color object.
 */
+(UIColor*)webColorNamed:(NSString*)colorName;

/**
 Returns the color for RGB function.
 @param functionString The RGB function string.
 @return The color object.
 */
+(UIColor*)colorForRGBFunction:(NSString*)functionString;

/**
 Returns the color for hex string.
 @param hexCode The hex string.
 @return The color object.
 */
+(UIColor*)colorForHex:(NSString*)hexCode;

+(void)flushCache;
+(BOOL)isDarkColor:(UIColor*)color;

//constants for iOS background texture colors.

extern NSString * const IOS_COLOR_SCROLLVIEW_TEXTURED_BACKGROUND;
extern NSString * const IOS_COLOR_VIEW_FLIPSIDE_BACKGROUND;
extern NSString * const IOS_COLOR_GROUP_TABLEVIEW_BACKGROUND;

@end

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
