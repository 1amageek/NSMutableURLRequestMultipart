//
//  NSMutableURLRequest+Multipart.m
//  STPBackgroundTransfer
//
//  Created by 1amageek on 2015/11/20.
//  Copyright © 2015年 Stamp inc. All rights reserved.
//

#import "NSMutableURLRequest+Multipart.h"

static NSString * CreateMultipartFormBoundary() {
    return [NSString stringWithFormat:@"Boundary%08X%08X", arc4random(), arc4random()];
}

static inline NSString * ContentTypeForPathExtension(NSString *extension) {
    NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
    NSString *contentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
    if (!contentType) {
        return @"application/octet-stream";
    } else {
        return contentType;
    }
}

@interface MultipartFormData ()
@property (nonatomic) NSMutableURLRequest *request;
@property (nonatomic, copy) NSString *boundary;
@property (nonatomic) NSStringEncoding stringEncoding;
@end

@implementation MultipartFormData

- (id)initWithURLRequest:(NSMutableURLRequest *)urlRequest
          stringEncoding:(NSStringEncoding)encoding
{
    self = [super init];
    if (self) {
        self.request = urlRequest;
        self.stringEncoding = encoding;
        self.boundary = CreateMultipartFormBoundary();
    }
    return self;
}

- (void)appendValue:(NSString *)value name:(NSString *)name
{
    NSMutableData *body = self.request.HTTPBody.mutableCopy;
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"name=\"%@\"\r\n\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", value] dataUsingEncoding:NSUTF8StringEncoding]];
    self.request.HTTPBody = body;
}

- (void)appendFileURL:(NSURL *)fileURL
                 name:(NSString *)name
                error:(NSError * __autoreleasing *)error
{
    NSString *fileName = [fileURL lastPathComponent];
    NSString *mimeType = ContentTypeForPathExtension([fileURL pathExtension]);
    [self appendFileURL:fileURL name:name fileName:fileName mimeType:mimeType error:error];
}

- (void)appendFileURL:(NSURL *)fileURL
                 name:(NSString *)name
             fileName:(NSString *)fileName
             mimeType:(NSString *)mimeType
                error:(NSError * __autoreleasing *)error
{
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    [self appendFileData:data name:name fileName:fileName mimeType:mimeType error:error];
}

- (void)appendFileData:(NSData *)data
                  name:(NSString *)name
              mimeType:(NSString *)mimeType
                 error:(NSError * __autoreleasing *)error
{
    [self appendFileData:data name:name fileName:nil mimeType:mimeType error:error];
}

- (void)appendFileData:(NSData *)data
                  name:(NSString *)name
              fileName:(NSString *)fileName
              mimeType:(NSString *)mimeType
                 error:(NSError * __autoreleasing *)error
{
    NSMutableData *body = self.request.HTTPBody.mutableCopy;
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"name=\"%@\";", name] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"filename=\"%@\"\r\n", fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimeType] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:data];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    self.request.HTTPBody = body;
}

- (NSMutableURLRequest *)requestByFinalizingMultipartFormData {
    
    NSMutableData *body = self.request.HTTPBody.mutableCopy;
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    self.request.HTTPBody = body;
    
    [self.request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", self.boundary] forHTTPHeaderField:@"Content-Type"];
    return self.request;
}

@end

@implementation NSMutableURLRequest (Multipart)

- (instancetype)initWithMultipartFormRequestWithURL:(NSURL *)URL
                          constructingBodyWithBlock:(void (^)(MultipartFormData *formData))block
{
    self = [super initWithURL:URL];
    if (self) {
        self.HTTPMethod = @"POST";
        self.HTTPBody = [NSData data];
        __block MultipartFormData *formData = [[MultipartFormData alloc] initWithURLRequest:self stringEncoding:NSUTF8StringEncoding];
        if (block) {
            block(formData);
        }
        self = [formData requestByFinalizingMultipartFormData];
    }
    return self;
}

@end
