//
//  FTRouterComponents.m
//  Router
//
//  Created by 胡金友 on 2018/4/26.
//

#import "FTRouterComponents.h"
#import "_FTRouterTools.h"
#import "FTRouter.h"
#import "FTRouterComponents+FTExtension.h"

@interface FTRouterComponents()

@property (nonatomic, readwrite, copy) NSString *scheme;
@property (nonatomic, readwrite, copy) NSURL *originalURL;
@property (nonatomic, readwrite, copy) NSString *host;
@property (nonatomic, readwrite, copy) NSString *path;
@property (nonatomic, readwrite, strong) NSArray *pathComponents;
@property (nonatomic, readwrite, strong) NSDictionary *queryParams;
@property (nonatomic, readwrite, strong) NSDictionary *additionalParams;
@property (nonatomic, readwrite, assign) FTRouterTransitionType transitionType;
@property (nonatomic, readwrite, copy) NSURL *followedURL;

@end

@implementation FTRouterComponents

- (instancetype)initWithURL:(NSURL *)URL additionalParameters:(NSDictionary *)params treatsHostAsPathComponent:(BOOL)treatsHostAsPathComponent {
    return [self initWithURL:URL additionalParameters:params treatsHostAsPathComponent:treatsHostAsPathComponent defaultScheme:nil];
}

- (instancetype)initWithURL:(NSURL *)URL
       additionalParameters:(NSDictionary *)params
  treatsHostAsPathComponent:(BOOL)treatsHostAsPathComponent
              defaultScheme:(NSString *)defaultScheme{
    
    if (self = [super init]) {
        self.originalURL = URL;
        self.additionalParams = params;
        self.scheme = _FT_UNIFY_SCHEME_(URL.scheme ?: defaultScheme);
        
        NSURLComponents *components = [NSURLComponents componentsWithString:URL.absoluteString];
        
        if (components.host.length > 0 && treatsHostAsPathComponent &&
            [components.host rangeOfString:@"."].location == NSNotFound) {
            //
            // 如果是 ft://futures.com/market/detail     host是一个网址，不拼到path里
            // 如果是 ft://futures/market/detail       host不是一个网址，就当path的一段拼到path里
            //
            NSString *host = [components.percentEncodedHost copy];
            components.host = @"/";
            components.percentEncodedPath = [host stringByAppendingPathComponent:(components.percentEncodedPath ?: @"")];
        }
        
        if ([FTRouter shared].alwaysTreatsURLHostsAsRoot && components.host &&
            [components.host containsString:@"."]) {
            components.host = @"/";
        }
        
        NSString *path = [components percentEncodedPath];
                
        self.host = _FT_IS_VALIDATE_STRING_(components.host) ? components.host : @"/";
       
        if (path.length > 0 && [path characterAtIndex:0] == '/') {
            path = [path substringFromIndex:1];
        }
        
        if (path.length > 0 && [path characterAtIndex:path.length - 1] == '/') {
            path = [path substringToIndex:path.length - 1];
        }
        
        NSMutableArray *pathComponents = [[path componentsSeparatedByString:@"/"] mutableCopy];
        if (pathComponents && pathComponents.count > 0) {
            if ([[pathComponents.firstObject lowercaseString] isEqualToString:FTPageTransitionTypePush]) {
                self.transitionType = FTRouterTransitionTypePush;
            } else if ([[pathComponents.firstObject lowercaseString] isEqualToString:FTPageTransitionTypePresent]) {
                self.transitionType = FTRouterTransitionTypePresent;
            } else if ([[pathComponents.firstObject lowercaseString] isEqualToString:FTPageTransitionTypePageBack]) {
                self.transitionType = FTRouterTransitionTypePageback;
            } else if ([[pathComponents.firstObject lowercaseString] isEqualToString:FTPageTransitionTypeRoot]) {
                self.transitionType = FTRouterTransitionTypeRoot;
            } else {
                self.transitionType = FTRouterTransitionTypeDefault;
            }
            
            if (self.transitionType != FTRouterTransitionTypeDefault) {
                [pathComponents removeObjectAtIndex:0];
            }
        }
        
        self.pathComponents = [pathComponents copy];
        self.path = [pathComponents componentsJoinedByString:@"/"];
        
        
        //**************************************************************************
        
        NSString *fragment = components.percentEncodedFragment;
        if (_FT_IS_VALIDATE_STRING_(fragment)) {
            NSURLComponents *fragmentComponents = [NSURLComponents componentsWithString:fragment];
            if (!fragmentComponents.scheme) {
                fragmentComponents.scheme = self.scheme;
            }
            
            self.followedURL = fragmentComponents.URL;
        }
        
        
        //**************************************************************************
        //**************************************************************************
        
        self.queryParams = components.queryParameters;
    }
    return self;
}

- (UIViewController *)destinationViewController {
    if (_FT_IS_VALIDATE_STRING_(self.destination)) {
        Class cls = NSClassFromString(self.destination);
        if (cls && [cls isSubclassOfClass:[UIViewController class]]) {
            return [[[cls alloc] init] mergeParamsFromComponents:self];
        }
    }
    
    return nil;
}

- (NSString *)description {
    NSMutableString *desc = [[NSMutableString alloc] init];
    
    [desc appendFormat:@"\n"];
    [desc appendFormat:@"**********************************************************\n"];
    [desc appendFormat:@"   FTRouterComponents\n"];
    [desc appendFormat:@"----------------------------------------\n"];
    
    [desc appendFormat:@"url : %@\n", self.originalURL];
    [desc appendFormat:@"scheme : %@\n", self.scheme];
    [desc appendFormat:@"host : %@\n", self.host];
    [desc appendFormat:@"path : %@\n", self.path];
    [desc appendFormat:@"pathComponents : %@\n", self.pathComponents];
    [desc appendFormat:@"transitionType : %@\n", [self transitionTypeString]];
    
    if (self.queryParams && self.queryParams.count > 0) {
        [desc appendFormat:@"queryParams : %@\n", self.queryParams];
    }
    
    if (self.additionalParams && self.additionalParams.count > 0) {
        [desc appendFormat:@"additionalParams : %@\n", self.additionalParams];
    }
    
    if (self.destination) {
        [desc appendFormat:@"destination : %@\n", self.destination];
    }
    
    if (self.callback) {
        [desc appendFormat:@"destination : %@\n", self.callback];
    }
    
    if (self.followedURL) {
        [desc appendFormat:@"followedURL : %@\n", self.followedURL];
    }
    
    [desc appendFormat:@"**********************************************************\n"];
    
    return desc;
}

- (NSString *)transitionTypeString {
    switch (self.transitionType) {
        case FTRouterTransitionTypePresent: return FTPageTransitionTypePresent;
        case FTRouterTransitionTypePush:    return FTPageTransitionTypePush;
        case FTRouterTransitionTypePageback:return FTPageTransitionTypePageBack;
        case FTRouterTransitionTypeRoot:    return FTPageTransitionTypeRoot;
        default:                            return @"default";
    }
}

@end

