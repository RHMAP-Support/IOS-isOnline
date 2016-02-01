//
//  HomeViewController.m
//  iOS-Template-App
//
//

#import "FHStarterProjectViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface FHStarterProjectViewController ()

@end

@implementation FHStarterProjectViewController

@synthesize button, name, result;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)cloudCall:(id)sender {
    [FH initWithSuccess:^(FHResponse *response) {
        NSLog(@"initialized OK");
        
        NSDictionary *args = [NSDictionary dictionaryWithObject:name.text forKey:@"hello"];
        FHCloudRequest *req = (FHCloudRequest *) [FH buildCloudRequest:@"/hello" WithMethod:@"POST" AndHeaders:nil AndArgs:args];

        
        
        if (![FH isOnline]) {
            // not connected
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"DefaultStyle"
                                      message:@"not connected"
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      otherButtonTitles:@"OK", nil];
            
            [alertView show];
        } else {
            // not connected.
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"DefaultStyle"
                                      message:@"connected"
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      otherButtonTitles:@"OK", nil];
            
            [alertView show];
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
     
