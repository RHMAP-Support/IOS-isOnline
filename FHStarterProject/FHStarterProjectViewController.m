//
//  HomeViewController.m
//  iOS-Template-App
//
//

#import "FHStarterProjectViewController.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface FHStarterProjectViewController ()

@end

@implementation FHStarterProjectViewController

@synthesize button, name, result;

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (BOOL)connected;

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (IBAction)cloudCall:(id)sender {
    [FH initWithSuccess:^(FHResponse *response) {
        NSLog(@"initialized OK");
        
        NSDictionary *args = [NSDictionary dictionaryWithObject:name.text forKey:@"hello"];
        FHCloudRequest *req = (FHCloudRequest *) [FH buildCloudRequest:@"/hello" WithMethod:@"POST" AndHeaders:nil AndArgs:args];

        if (connected) {
            // connected
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle: @"Alert"
                                                  message: @"connected"
                                                  preferredStyle:UIAlertControllerStyleAlert];

            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            // not connected.
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle: @"Alert"
                                                  message: @"not connected"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }

        [req execAsyncWithSuccess:^(FHResponse * res) {
            // Response
            NSLog(@"Response: %@", res.rawResponseAsString);
            result.text = [res.parsedResponse objectForKey:@"msg"];
        } AndFailure:^(FHResponse * res){
            // Errors
            NSLog(@"Failed to call. Response = %@", res.rawResponseAsString);
            result.text = res.rawResponseAsString;
        }];
        
    } AndFailure:^(FHResponse *response) {
        NSLog(@"initialize fail, %@", response.rawResponseAsString);
    }];
}


@end

