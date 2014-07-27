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

@property NSString *currentPlayer;

// stretch 1
@property (weak, nonatomic) IBOutlet UILabel *draggableLabel;
@property CGPoint draggableLabelOriginalPosition;
@property BOOL isDraggingLabel;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.draggableLabelOriginalPosition = self.draggableLabel.center;
    [self initGame];
}

- (void)initGame
{
    self.currentPlayer = @"X";
    self.whichPlayerLabel.text = self.currentPlayer;
    self.draggableLabel.text = self.currentPlayer;
    self.draggableLabel.textColor = [UIColor blueColor];
}

-(UILabel *)findLabelUsingPoint:(CGPoint)point
{
    UILabel *touchedLabel;

    // get the view which contains the point
    UIView *touchedView = [self.view hitTest:point withEvent:nil];

    // if the view is a label, return it
    if ([touchedView isKindOfClass:[UILabel class]])
    {
        touchedLabel = (UILabel *)touchedView;
    }

    return touchedLabel;
}

- (IBAction)onLabelTapped:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint point = [tapGestureRecognizer locationInView:self.view];
        UILabel *tappedLabel = [self findLabelUsingPoint:point];
        [self tapOnLabel:tappedLabel];
    }

}

- (void)tapOnLabel:(UILabel *)label
{
    // If label was tapped and it was not already tapped
    if (label && [label.text length] == 0)
    {
        // set it's text and text color properties
        [self adjustLabelTextAndColorToCurrentPlayer: label];

        NSString *winner = [self whoWon];

        if (winner)
        {
            UIAlertView *alertView = [[UIAlertView alloc] init];
            alertView.title = @"Congratulations!";
            alertView.message = [NSString stringWithFormat:@"%@ wins!", winner];
            alertView.delegate = self;

            [alertView addButtonWithTitle:@"Play again"];
            [alertView show];

            return;
        }

        // change to next player and show it on whichPlayerLabel
        [self changeCurrentPlayer];
        [self adjustLabelTextAndColorToCurrentPlayer:self.draggableLabel];
        self.whichPlayerLabel.text = self.currentPlayer;
        
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
    if ([firstLabel.text length] == 0 || [secondLabel.text length] == 0 || [thirdLabel.text length] == 0)
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
    else
    {
        self.currentPlayer = @"X";
    }
}

- (void)adjustLabelTextAndColorToCurrentPlayer:(UILabel *)label
{
    if ([self.currentPlayer isEqualToString:@"X"])
    {
        label.text = @"X";
        label.textColor = [UIColor blueColor];
    }
    else
    {
        label.text = @"O";
        label.textColor = [UIColor redColor];
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

- (IBAction)onDrag:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        // start drag
        if (CGRectContainsPoint(self.draggableLabel.frame, [gestureRecognizer locationOfTouch:0 inView:self.view]))
        {
            self.isDraggingLabel = YES;
        }
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        // move the label
        if (self.isDraggingLabel)
        {
            self.draggableLabel.center = [gestureRecognizer locationOfTouch:0 inView:self.view];
        }
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        UILabel *targetLabel = [self findLabelUsingPoint:self.draggableLabel.center];
        [self tapOnLabel:targetLabel];

        // return draggable label it to its original position
        self.draggableLabel.center = self.draggableLabelOriginalPosition;
        self.isDraggingLabel = NO;
    }
}

@end
