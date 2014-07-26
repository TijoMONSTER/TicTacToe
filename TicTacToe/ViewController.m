//
//  ViewController.m
//  TicTacToe
//
//  Created by Iván Mervich on 7/24/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIAlertViewDelegate>
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

@property int numberOfTurns;
@property UILabel *lastTappedLabel;
@property NSString *currentPlayer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];


    [self initGame];
}

- (void)initGame
{
    self.currentPlayer = @"X";
    self.whichPlayerLabel.text = self.currentPlayer;

    self.numberOfTurns = 0;
}

-(UILabel *)findLabelUsingPoint:(CGPoint)point
{
    UILabel *touchedLabel;

    // get the view which contains the point
    UIView *touchedView = [self.view hitTest:point withEvent:nil];

    // if the view is a label, return it
    if ([touchedView isKindOfClass:[UILabel class]]) {
        touchedLabel = (UILabel *)touchedView;
    }

    return touchedLabel;
}

- (IBAction)onLabelTapped:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [tapGestureRecognizer locationInView:self.view];
        self.lastTappedLabel = [self findLabelUsingPoint:point];

        // If a label was tapped and it was not already tapped
        if (self.lastTappedLabel && [self.lastTappedLabel.text length] == 0) {

            // set it's text and text color properties
            if ([self.currentPlayer isEqualToString:@"X"])
            {
                self.lastTappedLabel.text = @"X";
                self.lastTappedLabel.textColor = [UIColor blueColor];
            }
            else
            {
                self.lastTappedLabel.text = @"O";
                self.lastTappedLabel.textColor = [UIColor redColor];
            }

            // increment the number of labels tapped
            self.numberOfTurns ++;

            // at least five turns to check who won
//             if (self.numberOfTurns >= 5)
//             {
                 NSString *winner = [self whoWon];

                 if (winner != nil)
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] init];
                     alertView.title = @"Congratulations!";
                     alertView.message = [NSString stringWithFormat:@"%@ wins!", winner];
                     alertView.delegate = self;
                     
                     [alertView addButtonWithTitle:@"Play again"];
                     [alertView show];

                     return;
                 }
//             }

            // change to next player and show it on whichPlayerLabel
            [self changeCurrentPlayer];
            self.whichPlayerLabel.text = self.currentPlayer;

        }
    }

}

- (NSString *)whoWon
{
    NSString *winner;

    // first row
    if ([self compareLabelText:self.myLabelOne secondLabel:self.myLabelTwo thirdLabel:self.myLabelThree])
    {
        winner = self.currentPlayer;
    }
    // second row
    else if ([self compareLabelText:self.myLabelFour secondLabel:self.myLabelFive thirdLabel:self.myLabelSix])
    {
        winner = self.currentPlayer;
    }
    // third row
    else if ([self compareLabelText:self.myLabelSeven secondLabel:self.myLabelEight thirdLabel:self.myLabelNine])
    {
        winner = self.currentPlayer;
    }

    // first column
    else if ([self compareLabelText:self.myLabelOne secondLabel:self.myLabelFour thirdLabel:self.myLabelSeven])
    {
        winner = self.currentPlayer;
    }
    // second column
    else if ([self compareLabelText:self.myLabelTwo secondLabel:self.myLabelFive thirdLabel:self.myLabelEight])
    {
        winner = self.currentPlayer;
    }
    // third column
    else if ([self compareLabelText:self.myLabelThree secondLabel:self.myLabelSix thirdLabel:self.myLabelNine])
    {
        winner = self.currentPlayer;
    }

    // top-left diagonal
    else if ([self compareLabelText:self.myLabelOne secondLabel:self.myLabelFive thirdLabel:self.myLabelNine])
    {
        winner = self.currentPlayer;
    }
    // top-right diagonal
    else if ([self compareLabelText:self.myLabelThree secondLabel:self.myLabelFive thirdLabel:self.myLabelSeven])
    {
        winner = self.currentPlayer;
    }

    return winner;
}

- (BOOL)compareLabelText:(UILabel *)firstLabel secondLabel:(UILabel *)secondLabel thirdLabel:(UILabel *)thirdLabel
{
    // check for empty labels
    if ((firstLabel.text == nil || [firstLabel.text isEqualToString:@""]) || (secondLabel.text == nil || [secondLabel.text isEqualToString:@""]) || (thirdLabel.text == nil || [thirdLabel.text isEqualToString:@""]))
    {
        return NO;
    }

    // same text, return YES
    return [firstLabel.text isEqualToString:secondLabel.text] && [firstLabel.text isEqualToString:thirdLabel.text];
}

- (void)changeCurrentPlayer
{
    if ([self.currentPlayer isEqualToString:@"X"])
    {
        self.currentPlayer = @"O";
    }
    else if ([self.currentPlayer isEqualToString:@"O"])
    {
        self.currentPlayer = @"X";
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // reset game
    self.myLabelOne.text = nil;
    self.myLabelTwo.text = nil;
    self.myLabelThree.text = nil;
    self.myLabelFour.text = nil;
    self.myLabelFive.text = nil;
    self.myLabelSix.text = nil;
    self.myLabelSeven.text = nil;
    self.myLabelEight.text = nil;
    self.myLabelNine.text = nil;

    [self initGame];
}

@end
