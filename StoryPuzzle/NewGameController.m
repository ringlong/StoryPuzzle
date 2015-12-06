//
//  NewGameController.m
//  StoryPuzzle
//
//  Created by Ryan on 15/12/2.
//  Copyright © 2015年 BitAuto. All rights reserved.
//

#import "NewGameController.h"
#import "PuzzleViewController.h"

static const NSInteger RRNewGameButtonTag = 30;

@interface NewGameController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *piecesNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *typeOfImageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIButton *tapToSelectButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (strong, nonatomic) NSString *imagePath;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation NewGameController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Wood"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PuzzleViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.image = self.imageView.image;
}

- (IBAction)unwindSegue:(UIStoryboardSegue *)sender {}

#pragma mark - IBActions

- (IBAction)numberSelected:(UISlider *)sender {
    self.piecesNumberLabel.text = @((NSInteger)powf((floorf(sender.value)), 2)).stringValue;
}

- (IBAction)gameStarted:(UIButton *)sender {
}

- (IBAction)back:(id)sender {
}

- (IBAction)tapToSelectImage:(UIButton *)sender {
    sender.hidden = YES;
    _typeOfImageView.hidden = NO;
}

- (IBAction)selectImageFromPhotoLibrary:(UIButton *)sender {
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.allowsEditing = YES;
    picker.delegate = self;
    if (sender.tag == RRNewGameButtonTag + 3) {
        //Camera
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        //Photos
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)selectImageFromLibrary:(UIButton *)sender {
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSData *dataJPG = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 0.5);
    UIImage *temp = [UIImage imageWithData:dataJPG];
    CGRect rect = [info[UIImagePickerControllerCropRect] CGRectValue];
    
    NSLog(@"Original Rect is %@", NSStringFromCGRect(rect));
    
    _imagePath = [info[UIImagePickerControllerReferenceURL] absoluteString];
    _startButton.enabled = YES;
    _tapToSelectButton.hidden = YES;
    
    _imageView.image = temp;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
