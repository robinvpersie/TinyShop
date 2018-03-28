//
//  ECU.m
//  Portal
//
//  Created by 이정구 on 2018/3/27.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "ECU.h"
#import <AFNetworking/AFNetworking.h>

@interface ECU () <NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray<NSDictionary *> *dataArray;
@property (nonatomic, copy) NSString *currentTagName;
@property (nonatomic, strong)NSMutableDictionary *mutableDic;

@end

@implementation ECU

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


-(void)requestAreaWithQuery:(NSString *)query offset:(NSInteger)offset{
    
    NSStringEncoding euc_kr = -2147481280;
    NSString *regKey = @"4e161da3b4b3c7ff81520154121695";
    NSString *stringUrl = [NSString stringWithFormat:@"http://biz.epost.go.kr/KpostPortal/openapi?regkey="];
    stringUrl = [stringUrl stringByAppendingString:regKey];
    stringUrl = [stringUrl stringByAppendingString:@"&target=postNew&query="];
    stringUrl = [stringUrl stringByAppendingString:query];
    NSString *append = [NSString stringWithFormat:@"&countPerPage=10&currentPage=%ld",(long)offset];
    stringUrl = [stringUrl stringByAppendingString:append];
    
    NSString *webStringURL = [stringUrl stringByAddingPercentEscapesUsingEncoding: euc_kr];
    

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer ];
    [manager GET:webStringURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSXMLParser *parser = (NSXMLParser *)responseObject;
        parser.delegate = self;
        [parser parse];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];

}

#pragma xmlDelegate

-(void)parserDidStartDocument:(NSXMLParser *)parser {
    self.dataArray = [NSMutableArray array];
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"%@",parseError);
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
  
    self.currentTagName = elementName;
    if ([self.currentTagName isEqualToString:@"itemlist"]) {
        self.mutableDic = [NSMutableDictionary dictionary];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"itemlist"]) {
        NSDictionary *dic = [self.mutableDic copy];
        [self.dataArray addObject:dic];
    }
    self.currentTagName = nil;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([self.currentTagName isEqualToString:@"postcd"]) {
        [self.mutableDic setObject:string forKey:@"postcd"];
    }else if ([self.currentTagName isEqualToString:@"address"]) {
        [self.mutableDic setObject:string forKey:@"address"];
    }
 
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    self.success(self.dataArray);
}



@end
