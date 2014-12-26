//
//  PhoneCarrierHelper.m
//  免费流量王
//
//  Created by keyrun on 14-10-23.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "PhoneCarrierHelper.h"
#import "NSString+emptyStr.h"
@implementation PhoneCarrierHelper

+(PhoneCarrierHelper *)sharePhoneCarrierHelper{

    static PhoneCarrierHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[PhoneCarrierHelper alloc] init];
    });
    return helper ;
}

-(NSString *)checkPhoneCarrier:(NSString *)phoneNum{
    NSString *findPhonenumber = @"";
    NSString *findPhoneNumberMobile = @"";
    NSString *findPhoneNumberIsACall = @"";
    NSString *findPhoneNumberIsMobile = @"";
    
    NSInteger phonenumberlength = [phoneNum length];
    NSLog(@"%d",[phoneNum length]);
    if (phonenumberlength == 3 ||
        phonenumberlength == 4 ||
        phonenumberlength == 5 ||
        phonenumberlength == 7 ||
        phonenumberlength == 10||
        phonenumberlength == 11||
        phonenumberlength == 12||
        phonenumberlength == 13||
        phonenumberlength == 14||
        phonenumberlength == 16||
        phonenumberlength == 17)
    {
        NSString *tempstring = phoneNum;
        if ((phonenumberlength == 14) && ([tempstring characterAtIndex:0] == '+') &&([tempstring characterAtIndex:1] == '8')&&([tempstring characterAtIndex:2] == '6')&&([tempstring characterAtIndex:3] == '1'))
        {
            NSMutableString *tempstring02 = [NSMutableString stringWithString:tempstring];
            NSRange range;
            range.location = 0;
            range.length = 3;
            [tempstring02 deleteCharactersInRange:range];
            NSString *tempstring03 = [tempstring02 stringByPaddingToLength:7 withString:nil startingAtIndex:0];
            NSString *findPhonenumberFull = [tempstring02 stringByPaddingToLength:11 withString:nil startingAtIndex:0];
            
            findPhoneNumberMobile = [tempstring02 stringByPaddingToLength:3 withString:nil startingAtIndex:0];
            findPhonenumber = tempstring03;
        }else if ((phonenumberlength == 13) && ([tempstring characterAtIndex:0] == '8') &&([tempstring characterAtIndex:1] == '6')&&([tempstring characterAtIndex:2] == '1')) {
            NSMutableString *tempstring02 = [NSMutableString stringWithString:tempstring];
            NSRange range;
            range.location = 0;
            range.length = 2;
            [tempstring02 deleteCharactersInRange:range];
            NSString *tempstring03 = [tempstring02 stringByPaddingToLength:7 withString:nil startingAtIndex:0];
            NSString *findPhonenumberFull = [tempstring02 stringByPaddingToLength:11 withString:nil startingAtIndex:0];
            findPhoneNumberMobile = [tempstring02 stringByPaddingToLength:3 withString:nil startingAtIndex:0];
            
            findPhonenumber = tempstring03;
        }else if (((phonenumberlength == 12) && ([tempstring characterAtIndex:0] == '0'))||((phonenumberlength == 4) && ([tempstring characterAtIndex:0] == '0'))) {
            NSMutableString *tempstring02 = [NSMutableString stringWithString:tempstring];
            
            NSMutableString *tempstring03 = [[NSMutableString alloc] initWithCapacity:1];
            [tempstring03 appendString:[tempstring02 stringByPaddingToLength:4 withString:nil startingAtIndex:0]];
            
            NSRange range;
            range.location = 0;
            range.length = 1;
            [tempstring03 deleteCharactersInRange:range];
            findPhoneNumberIsACall = tempstring03;
        }else if (((phonenumberlength == 11) && ([tempstring characterAtIndex:0] == '1'))||((phonenumberlength == 7) && ([tempstring characterAtIndex:0] == '1'))) {
            
            NSMutableString *tempstring02 = [NSMutableString stringWithString:tempstring];
            findPhonenumber = [tempstring02 stringByPaddingToLength:7 withString:nil startingAtIndex:0];
            findPhoneNumberMobile = [tempstring02 stringByPaddingToLength:3 withString:nil startingAtIndex:0];
        }else if (((phonenumberlength == 16) && ([tempstring characterAtIndex:0] == '1')) && ([tempstring characterAtIndex:1] == ' ') && ([tempstring characterAtIndex:2] == '(') && ([tempstring characterAtIndex:6] == ')') && ([tempstring characterAtIndex:7] == ' ') && ([tempstring characterAtIndex:11] == '-')) {
            NSMutableString *tempstring02 = [NSMutableString stringWithString:tempstring];
            NSRange range;
            range.location = 11;
            range.length = 1;
            [tempstring02 deleteCharactersInRange:range];
            range.location = 6;
            range.length = 2;
            [tempstring02 deleteCharactersInRange:range];
            range.location = 1;
            range.length = 2;
            [tempstring02 deleteCharactersInRange:range];
            NSString *tempstring03 = [tempstring02 stringByPaddingToLength:7 withString:nil startingAtIndex:0];
            NSString *findPhonenumberFull = [tempstring02 stringByPaddingToLength:11 withString:nil startingAtIndex:0];
            findPhoneNumberMobile = [tempstring02 stringByPaddingToLength:3 withString:nil startingAtIndex:0];
            
            findPhonenumber = tempstring03;
        }else if (((phonenumberlength == 17) && ([tempstring characterAtIndex:0] == '+')) && ([tempstring characterAtIndex:1] == '8') && ([tempstring characterAtIndex:2] == '6') && ([tempstring characterAtIndex:3] == ' ') && ([tempstring characterAtIndex:7] == '-') && ([tempstring characterAtIndex:12] == '-')) {
            
            NSLog(@"1717171717171771");
            NSMutableString *tempstring02 = [NSMutableString stringWithString:tempstring];
            NSRange range;
            range.location = 12;
            range.length = 1;
            [tempstring02 deleteCharactersInRange:range];
            range.location = 7;
            range.length = 1;
            [tempstring02 deleteCharactersInRange:range];
            range.location = 0;
            range.length = 4;
            [tempstring02 deleteCharactersInRange:range];
            NSString *tempstring03 = [tempstring02 stringByPaddingToLength:7 withString:nil startingAtIndex:0];
            NSString *findPhonenumberFull = [tempstring02 stringByPaddingToLength:11 withString:nil startingAtIndex:0];
            findPhoneNumberMobile = [tempstring02 stringByPaddingToLength:3 withString:nil startingAtIndex:0];
            
            findPhonenumber = tempstring03;
        }else if (((phonenumberlength == 11) && ([tempstring characterAtIndex:0] == '0')) || ((phonenumberlength == 3) && ([tempstring characterAtIndex:0] == '0'))) {
            NSMutableString *tempstring02 = [NSMutableString stringWithString:tempstring];
            
            NSString *tempstring03 = [tempstring02 stringByPaddingToLength:3 withString:nil startingAtIndex:0];
            
            NSRange range;
            range.location = 0;
            range.length = 1;
            findPhoneNumberIsACall = tempstring03;
        }else if ((phonenumberlength == 5) &&([tempstring characterAtIndex:0] == '1')) {
            
            findPhoneNumberIsMobile = tempstring;
        }else {
            [self PhoneNumberError];
        }
    }else {
        [self PhoneNumberError];
    }
    if ([findPhonenumber length] ==7 && [findPhoneNumberMobile length] ==3)
    {
        [self SelectInfoByPhone:findPhonenumber WithMobile:findPhoneNumberMobile];
    }else if ([findPhoneNumberIsACall length] == 3||[findPhoneNumberIsACall length] == 4)
    {
        [self SelectInfoByCall:findPhoneNumberIsACall];
        
    }else if ([findPhoneNumberIsMobile length] == 5)
    {
        NSInteger findPhoneNumberIsMobileInt = [findPhoneNumberIsMobile intValue];
        [self SelectInfoByPhoneNumberIsMobile:findPhoneNumberIsMobileInt];
    }
    NSString *string ;
    if (![NSString isEmptyString:phoneCity]) {
        string = [NSString stringWithFormat:@"%@·%@",phoneCity,phoneSIM];
    }
    return string ;
    
}
-(void)SelectInfoByPhone:(NSString *)phonenumber WithMobile:(NSString *)phonemobile
{
    NSString *SelectWhatMobile = @"SELECT mobile FROM numbermobile where uid=";
    NSString *SelectWhatMobileFull = [SelectWhatMobile stringByAppendingFormat:phonemobile];
    sqlite3 *database;
    if (sqlite3_open([[self FindDatabase] UTF8String], &database)
        != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, [SelectWhatMobileFull UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int mobilenumber = sqlite3_column_int(stmt, 0);
            if (mobilenumber) {
                NSString *mobileNumberString = [NSString stringWithFormat:@"%d",mobilenumber];
                NSString *SelectWhatMobileName = @"SELECT mobile FROM mobilenumber WHERE uid=";
                NSString *SelectWhatMobileNameFull = [SelectWhatMobileName stringByAppendingFormat:mobileNumberString];
                sqlite3_stmt *stmt2;
                if (sqlite3_prepare_v2(database, [SelectWhatMobileNameFull UTF8String], -1, &stmt2, nil) == SQLITE_OK) {
                    while (sqlite3_step(stmt2) == SQLITE_ROW) {
                        char *mobilename = (char *)sqlite3_column_text(stmt2, 0);
                        NSString *mobilenamestring = [[NSString alloc] initWithUTF8String:mobilename];
                        if (mobilenamestring!= NULL) {
                            phoneSIM = [mobilenamestring substringFromIndex:2];
                            NSLog(@"mobile %@ %@ ",mobilenamestring,phoneSIM);
                        }
                    }
                }sqlite3_finalize(stmt2);
                
            }
        }
        sqlite3_finalize(stmt);
    }
    sqlite3_stmt *stmt3;
    NSString *SelectCityNumberByPhoneNumber = @"SELECT city FROM phonenumberwithcity WHERE uid=";
    NSString *SelectCityNumberByPhoneNumberFull = [SelectCityNumberByPhoneNumber stringByAppendingFormat:phonenumber];
    if (sqlite3_prepare_v2(database, [SelectCityNumberByPhoneNumberFull UTF8String], -1, &stmt3, nil) == SQLITE_OK) {
        if (sqlite3_step(stmt3) == SQLITE_ROW) {
            int citynumber = sqlite3_column_int(stmt3, 0);
            NSString *citynumberNSString = [NSString stringWithFormat:@"%d",citynumber];
            if (citynumberNSString != nil) {
                NSString *SelectCityNameAndCtiyZoneByCityBumber = @"SELECT city,zone FROM citywithnumber WHERE uid=";
                NSString *SelectCityNameAndCtiyZoneByCityBumberFull = [SelectCityNameAndCtiyZoneByCityBumber stringByAppendingFormat:citynumberNSString];
                sqlite3_stmt *stmt4;
                if (sqlite3_prepare_v2(database, [SelectCityNameAndCtiyZoneByCityBumberFull UTF8String], -1, &stmt4, nil) == SQLITE_OK) {
                    if (sqlite3_step(stmt4) == SQLITE_ROW) {
                        char *cityname = (char *)sqlite3_column_text(stmt4, 0);
                        int cityzonecode = sqlite3_column_int(stmt4, 1);
                        NSString *cityNameNSString = [[NSString alloc] initWithUTF8String:cityname];
                        NSString *cityzonecodeNnumber = [@"0" stringByAppendingFormat:@"%d",cityzonecode];
                        if (cityNameNSString != nil && cityzonecodeNnumber != nil) {
                            //                            mylabellocation.text = cityNameNSString;
                            //                            mylabelzonecode.text = cityzonecodeNnumber;
                            phoneCity = cityNameNSString;
                            NSLog(@"city %@  zone %@ ",cityNameNSString,cityzonecodeNnumber);
                        }
                    }else {
                        [self PhoneNumberError];
                    }
                    sqlite3_finalize(stmt4);
                }
            }
        }else {
            [self PhoneNumberError];
        }
        sqlite3_finalize(stmt3);
    }
    
    sqlite3_close(database);
    
    
    
}
-(NSString *)FindDatabase{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"location_Numbercity_citynumber" ofType:@"db"];
    return path;
}

-(void)SelectInfoByCall:(NSString *) callnumber
{
    NSString *SelectCityNameByCityZoneCode = @"SELECT city FROM citywithnumber WHERE zone=";
    NSString *SelectCityNameByCityZoneCodeFull = [SelectCityNameByCityZoneCode stringByAppendingString:callnumber ];
    sqlite3 *database;
    if (sqlite3_open([[self FindDatabase] UTF8String], &database)
        != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, [SelectCityNameByCityZoneCodeFull UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            char *cityname = (char *)sqlite3_column_text(stmt, 0);
            NSString *cityNameNSString = [[NSString alloc] initWithUTF8String:cityname];
            if (cityname != nil) {
                //                mylabellocation.text = cityNameNSString;
                NSLog(@"城市名字 %@",cityNameNSString);
            }
        }else {
            [self PhoneNumberError];
        }
        sqlite3_finalize(stmt);
    }
    sqlite3_close(database);
    
}
-(void)SelectInfoByPhoneNumberIsMobile:(NSInteger)PhoneNumberIsMobile
{
    if(PhoneNumberIsMobile == 10000){
        NSLog( @"中国电信客服");
    }else if(PhoneNumberIsMobile == 10001){
        //        mylabelmobile.text = @"中国电信自助服务热线";
        //    }else if(PhoneNumberIsMobile == 10010){
        //        mylabelmobile.text = @"中国联通客服";
    }else if(PhoneNumberIsMobile == 10011){
        //        mylabelmobile.text = @"中国联通充值";
    }else if(PhoneNumberIsMobile == 10086){
        //        mylabelmobile.text = @"中国移动客服";
    }else{
        NSLog( @"输入号码不正确" );
    }
}


-(void)PhoneNumberError{
    
    NSLog( @"您输入的电话号码无效" );
    
}

@end
