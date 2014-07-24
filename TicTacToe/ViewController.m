//
//  ViewController.m
//  TicTacToe
//
//  Created by Iván Mervich on 7/24/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *myLabelOne;
@property (weak, nonatomic) IBOutlet UILabel *myLabelTwo;
@property (weak, nonatomic) IBOutlet UILabel *myLabelThree;
@property (weak, nonatomic) IBOutlet UILabel *myLabelFour;
@property (weak, nonatomic) IBOutlet UILabel *myLabelFive;
@property (weak, nonatomic) IBOutlet UILabel *myLabelSix;
@property (weak, nonatomic) IBOutlet UILabel *myLabelSeven;
@property (weak, nonatomic) IBOutlet UILabel *myLabelEight;
@property (weak, nonatomic) IBOutlet UILabel *myLabelNine;
@property (weak, nonatomic) IBOutlet UILabel *whichPlayerLabel;

@property NSArray *gameLabels;
@property NSString *currentPlayer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.gameLabels = @[self.myLabelOne,
                            self.myLabelTwo,
                            self.myLabelThree,
                            self.myLabelFour,
                            self.myLabelFive,
                            self.myLabelSix,
                            self.myLabelSeven,
                            self.myLabelEight,
                            self.myLabelNine];

    self.currentPlayer = @"X";
    self.whichPlayerLabel.text = self.currentPlayer;
}

-(UILabel *)findLabelUsingPoint:(CGPoint)point
{
    // check in the array of labels if any was tapped
    for (UILabel *label in self.gameLabels) {
        if (CGRectContainsPoint(label.frame, point)) {
            return label;
        }
    }

    NSLog(@"No label tapped");
    return nil;
}

- (IBAction)onLabelTapped:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        UILabel *tappedLabel = [self findLabelUsingPoint:[tapGestureRecognizer locationInView:self.view]];

        // If a label was tapped and it was not already tapped
        if (tappedLabel && [tappedLabel.text length] == 0) {

            if ([self.currentPlayer isEqualToString:@"X"]) {
                tappedLabel.text = @"X";
                tappedLabel.textColor = [UIColor blueColor];
            } else {
                tappedLabel.text = @"O";
                tappedLabel.textColor = [UIColor redColor];
            }
//            tappedLabel.text = self.currentPlayer;

            // change next player and show it
            if ([self.currentPlayer isEqualToString:@"X"]) {
                self.currentPlayer = @"O";
            } else {
                self.currentPlayer = @"X";
            }
            self.whichPlayerLabel.text = self.currentPlayer;

        }
    }
}

@end
