//
//  NSMutableURLRequest+Multipart.h
//  STPBackgroundTransfer
//
//  Created by 1amageek on 2015/11/20.
//  Copyright © 2015年 Stamp inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface MultipartFormData : NSObject

/**
 append value to formdata
 @param value
 @param name
 */
- (void)appendValue:(NSString *)value name:(NSString *)name;

/**
 append file to formdata from URL
 @param fileURL
 @param name
 */
- (void)appendFileURL:(NSURL *)fileURL
                 name:(NSString *)name
                error:(NSError * __autoreleasing *)error;

/**
 append file to formdata from URL
 @param fileURL
 @param name
 @param fileName
 @param mimeType
 */
- (void)appendFileURL:(NSURL *)fileURL
                 name:(NSString *)name
             fileName:(NSString *)fileName
             mimeType:(NSString *)mimeType
                error:(NSError * __autoreleasing *)error;

/**
 append data to formdata
 @param data
 @param name
 @param mimeType
 */
- (void)appnedFileData:(NSData *)data
                  name:(NSString *)name
              mimeType:(NSString *)mimeType
                 error:(NSError * __autoreleasing *)error;

/**
 append data to formdata
 @param data
 @param name
 @param fileName
 @param mimeType
 */
- (void)appnedFileData:(NSData *)data
                  name:(NSString *)name
              fileName:(NSString *)fileName
              mimeType:(NSString *)mimeType
                 error:(NSError * __autoreleasing *)error;
@end

@interface NSMutableURLRequest (Multipart)
/**
 @return NSMutableURLRequest
 @param request URL
 @param constructing block
 */
- (instancetype)initWithMultipartFormRequestWithURL:(NSURL *)URL
                          constructingBodyWithBlock:(void (^)(MultipartFormData *formData))block;
@end
