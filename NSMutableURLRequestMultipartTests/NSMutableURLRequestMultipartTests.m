//
//  NSMutableURLRequestMultipartTests.m
//  NSMutableURLRequestMultipartTests
//
//  Created by 1amageek on 2015/11/24.
//  Copyright © 2015年 Stamp inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSMutableURLRequest+Multipart.h"

@interface NSMutableURLRequestMultipartTests : XCTestCase

@end

@implementation NSMutableURLRequestMultipartTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testValue {
    
    
    __block NSURLResponse *__response;
    __block NSData *__data;
    __block id __error;
    
    XCTestExpectation *connectionNetworkExpectation = [self expectationWithDescription:@"Session is connected."];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithMultipartFormRequestWithURL:[NSURL URLWithString:@"http://localhost:3000/media/upload"] constructingBodyWithBlock:^(MultipartFormData *formData) {
        [formData appendValue:@"test" name:@"test"];
    }];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __data = data;
        __response = response;
        __error = error;
        [connectionNetworkExpectation fulfill];
    }];
    [task resume];
    
    [self waitForExpectationsWithTimeout:2 handler:^(NSError * _Nullable error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)__response;
        XCTAssertEqual(response.statusCode, 200);
        if (error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
    
}

- (void)testURL {
    
    
    __block NSURLResponse *__response;
    __block NSData *__data;
    __block id __error;
    
    XCTestExpectation *connectionNetworkExpectation = [self expectationWithDescription:@"Session is connected."];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Lenna" ofType:@"png"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithMultipartFormRequestWithURL:[NSURL URLWithString:@"http://localhost:3000/media/upload"] constructingBodyWithBlock:^(MultipartFormData *formData) {
        [formData appendFileURL:url name:@"fileName" error:nil];
    }];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __data = data;
        __response = response;
        __error = error;
        [connectionNetworkExpectation fulfill];
    }];
    [task resume];
    
    [self waitForExpectationsWithTimeout:2 handler:^(NSError * _Nullable error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)__response;
        XCTAssertEqual(response.statusCode, 200);
        if (error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
    
}

- (void)testData {
    
    
    __block NSURLResponse *__response;
    __block NSData *__data;
    __block id __error;
    
    XCTestExpectation *connectionNetworkExpectation = [self expectationWithDescription:@"Session is connected."];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    UIImage *image = [UIImage imageNamed:@"Lenna"];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithMultipartFormRequestWithURL:[NSURL URLWithString:@"http://localhost:3000/media/upload"] constructingBodyWithBlock:^(MultipartFormData *formData) {
        [formData appnedFileData:data name:@"fileName" mimeType:@"image/jpeg" error:nil];
    }];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __data = data;
        __response = response;
        __error = error;
        [connectionNetworkExpectation fulfill];
    }];
    [task resume];
    
    [self waitForExpectationsWithTimeout:2 handler:^(NSError * _Nullable error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)__response;
        XCTAssertEqual(response.statusCode, 200);
        if (error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
    
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
