//
//  ViewController.m
//  BasicInteraction
//
//  Created by Tom Lewis on 5/27/14.
//  
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *simpleTextField;
@property (weak, nonatomic) IBOutlet UILabel *simpleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end


@implementation ViewController

- (IBAction)uploadPressed:(id)sender {
    NSString * contents = self.simpleTextField.text;
    NSString * message = [NSString stringWithFormat:@"Hello, %@", contents];
    [self.simpleLabel setText:message];
    [self.simpleTextField resignFirstResponder];
    
    //set caption
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"name"] = contents;
   
    // Resize and set image
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [self.imageView.image drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
    
    PFFile*imageFile = [PFFile fileWithName:@"image.jpg"data:imageData];
    testObject[@"imageFile"] = imageFile;
    
    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"object saved");
            self.imageView.image = nil;
            self.simpleLabel.text = @"Caption:";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Object Saved"
                                                            message:@"Your object has successfully saved"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
        else {
            NSLog(@"ERROR SAVING");
            self.simpleLabel.text = @"Caption:";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Uploading"
                                                            message:@"Please try again."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    self.simpleTextField.text = @"";
    self.simpleLabel.text = @"UPLOADING ...";
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Get picked image from info dictionary
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // Put that image onto the screen in  image view
    self.imageView.image = image;
    
    //dismiss picker
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)getPicture:(id)sender {
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    
    // Check for camera
    
    // If the device has a camera, take a picture, otherwise,
    // just pick from photo library
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate = self;
    
    // Place image picker on the screen
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL) textFieldShouldReturn: (UITextField *)textField {
    [self.simpleTextField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
