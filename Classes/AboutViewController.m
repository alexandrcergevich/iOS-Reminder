//
//  AboutViewController.m
//  AlarmAndClock
//
//  Created by Alexandr on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
//#import "SHK.h"
//#import "SHKFacebook.h"
//#import "SHKTwitter.h"
@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - IBAction
- (IBAction)giftButtonPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/giftSongsWizard?gift=1&salableAdamId=469759110&productType=C&pricingParameter=STDQ"]];
}
- (IBAction)visitButtonPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.iappsologic.com"]];
}
- (IBAction)emailButtonPressed:(id)sender
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if ( !mailClass || ![mailClass canSendMail] )
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Mail Accounts"
                                                        message:@"Please set up a Mail account in order to send email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
		return;
	}
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    //	NSArray *toRecipients = [NSArray arrayWithObject:@"test@testapp.co.uk"]; 
	NSArray *toRecipients = [NSArray arrayWithObject:@"support@iappsologic.com"]; 
	[picker setToRecipients:toRecipients];
	NSString *emailBody = @"";
	[picker setMessageBody:emailBody isHTML:NO];
	[self presentModalViewController:picker animated:NO];
	[picker release];
}
//- (IBAction)facebookButtonPressed:(id)sender
//{
//	NSString *PostItem = [NSString stringWithFormat:@"I am using Alarm clock , try it too", @"Rich Clock"];
//	SHKItem *postData = [SHKItem text:PostItem];	
//	[SHKFacebook shareItem:postData];
//    
//}
//- (IBAction)twitterButtonPressed:(id)sender
//{
//    
//	NSString *PostItem = [NSString stringWithFormat:@"I am using Alarm Clock, try it too", @"Rich Clock"];
//	SHKItem *postData = [SHKItem text:PostItem];
//	[SHKTwitter shareItem:postData];
//}
- (IBAction)bannerButtonPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/app/whatsmsapp-custom-sms-alerts/id481148621?mt=8"]];
}


#pragma mark Compose Mail Delegate


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{	
	switch (result)
	{
		case MFMailComposeResultCancelled:
		{
			break;
		}
			
		case MFMailComposeResultSaved:
		{
			UIAlertView *stop = [[UIAlertView alloc] initWithTitle:@"" message:@"Mail saved." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[stop show];
			[stop release];
			break;
		}
			
		case MFMailComposeResultSent:
		{
			UIAlertView *stop = [[UIAlertView alloc] initWithTitle:@"" message:@"Mail sent." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[stop show];
			[stop release];
			break;
		}
			
		case MFMailComposeResultFailed:
		{
			UIAlertView *stop = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Mail send failed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[stop show];
			[stop release];
			break;
		}
			
		default:
		{
			UIAlertView *stop = [[UIAlertView alloc] initWithTitle:@"" message:@"Mail not sent." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[stop show];
			[stop release];
			break;
		}
	}
	
	[self dismissModalViewControllerAnimated:YES];
}
@end
