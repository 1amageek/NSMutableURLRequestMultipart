# NSMutableURLRequestMultipart

NSMutableURLRequestMultipart is a category of NSMutableURLRequest for sending a simple POST request.

## MultipartFormData

You create a form using the MultipartFormData.

``` objective-c
- (void)appendValue:(NSString *)value name:(NSString *)name;
```

``` objective-c
- (void)appendFileURL:(NSURL *)fileURL
                 name:(NSString *)name
                error:(NSError * __autoreleasing *)error;

```

``` objective-c
- (void)appnedFileData:(NSData *)data
                  name:(NSString *)name
              fileName:(NSString *)fileName
              mimeType:(NSString *)mimeType
                 error:(NSError * __autoreleasing *)error;

```

## Usage
``` objective-c
NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    UIImage *image = [UIImage imageNamed:@"Lenna"];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithMultipartFormRequestWithURL:[NSURL URLWithString:@"http://localhost:3000/media/upload"] constructingBodyWithBlock:^(MultipartFormData *formData) {
        [formData appnedFileData:data name:@"fileName" mimeType:@"image/jpeg" error:nil];
    }];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // response
    }];
    [task resume];
    
```
