//
//  BaseDaoProperty.m
//  BESTKEEP
//
//  Created by dcj on 15/10/8.
//  Copyright © 2015年 YISHANG. All rights reserved.
//

#import "BaseDaoProperty.h"

NSString* const DB_Type_Text = @"text";
NSString* const DB_Type_Int = @"integer";
NSString* const DB_Type_Double = @"double";
NSString* const DB_Type_Blob = @"blob";



@implementation BaseDaoProperty

-(instancetype)initWithPorety:(objc_property_t *)property{
    if (self = [super init]) {
        const char *propertyName = property_getName(*property);
        _columnName = @(propertyName);
        
        const char* attrs = property_getAttributes(*property);
        NSString* propertyAttributes = @(attrs);
        NSString* propertyType = nil;
        
        self.columnStatus = DBColumaStatuNormal;
        
        NSScanner* scanner = [NSScanner scannerWithString:propertyAttributes];
        [scanner scanUpToString:@"T" intoString: nil];
        [scanner scanString:@"T" intoString:nil];
        
        if([scanner scanString:@"@\"" intoString: &propertyType])
        {
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"<"]
                                    intoString:&propertyType];
            _propertyType = propertyType;
            _columnType = [[NSClassFromString(propertyType) class] isSubclassOfClass:NSClassFromString(@"BaseObject")] ? DB_Type_Blob : DB_Type_Text;

            
            while ([scanner scanString:@"<" intoString:NULL])
            {
                NSString* protocolName = nil;

                [scanner scanUpToString:@">" intoString: &protocolName];
                if ([protocolName isEqualToString:@"DataBaseIsNotNull"]) {
                    _isNotNull = YES;
                }else if ([protocolName isEqualToString:@"DatabaseIsPrimary"]){
                    _isPrimary  = YES;
                }else if ([protocolName isEqualToString:@"DataBaseIsIgnore"]){
                    _isIgnore = YES;
                }else if ([protocolName isEqualToString:@"DataBaseIsUnique"]){
                    _isUnique = YES;
                }else if ([protocolName isEqualToString:@"DataBaseIsAddition"]){
                    _columnStatus = DBColumaStatuAddition;
                }else if ([protocolName isEqualToString:@"DataBaseIsRemove"]){
                    _columnStatus = DBColumaStatuRemove;
                }
                
                [scanner scanString:@">" intoString:NULL];
            }
            
        }
        else if ([scanner scanString:@"{" intoString: &propertyType])
        {
            [scanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet]
                                intoString:&propertyType];
            _propertyType = propertyType;
            return nil;
        }
        else
        {
            NSDictionary* primitivesNames = @{@"f":@"float",
                                              @"i":@"int",
                                              @"d":@"double",
                                              @"l":@"long",
                                              @"c":@"BOOL",
                                              @"s":@"short",
                                              @"q":@"long",
                                              @"I":@"NSInteger",
                                              @"Q":@"NSUInteger",
                                              @"B":@"BOOL",
                                              @"@?":@"Block"};
            
            NSDictionary* mapTypes = @{@"float" : DB_Type_Double,
                                       @"double" : DB_Type_Double,
                                       @"decimal" : DB_Type_Double,
                                       @"int" : DB_Type_Int,
                                       @"char" : DB_Type_Int,
                                       @"short" : DB_Type_Int,
                                       @"long" : DB_Type_Int,
                                       @"NSInteger" : DB_Type_Int,
                                       @"NSUInteger" : DB_Type_Int,
                                       @"BOOL" : DB_Type_Int,};
            
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@","]
                                    intoString:&propertyType];
            
            _propertyType = primitivesNames[propertyType];
            propertyType = mapTypes[_propertyType];
            _columnType = [propertyType length]>0?propertyType:DB_Type_Blob;
            if([_propertyType isEqualToString:@"Block"])
            {
                return nil;
            }
        }
    }
    return self;
}



@end
