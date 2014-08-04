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
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property int turnTime;
@property NSString *currentPlayer;

// stretch 1
@property (weak, nonatomic) IBOutlet UILabel *draggableLabel;
@property CGPoint draggableLabelOriginalPosition;
@property BOOL isDraggingLabel;

// stretch 2
@property NSTimer *turnTimer;

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

	self.turnTime = 5;
	[self updateTimeLabelText];
    [self setTurnTimer];
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

        [self setTappedLabelAndEndTurn:tappedLabel];
    }
}

- (void)setTappedLabelAndEndTurn:(UILabel *)label
{
    // If label was not already tapped
    if (label && [label.text length] == 0)
    {
        // set it's text and text color properties
        [self adjustLabelTextAndColorToCurrentPlayer:label];
        [self endTurn];
    }
}

- (void)endTurn
{
	NSLog(@"end turn");
    // remove current timer
    [self removeTurnTimer];

    NSString *winner = [self whoWon];

    if (!winner) {
        // If there's no winner, change to next player
        [self changeCurrentPlayer];
        // Adjust the draggable label according to current player
        [self adjustLabelTextAndColorToCurrentPlayer:self.draggableLabel];

        // set a new timer
        [self setTurnTimer];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] init];
        alertView.delegate = self;
        alertView.alpha = 0.2;

        // if it was not a draw
        if (![winner isEqualToString:@"-"])
        {
            alertView.title = @"Congratulations!";
            alertView.message = [NSString stringWithFormat:@"%@ wins!", winner];
        }
        else
        {
            alertView.title = @"Boooo!";
            alertView.message = @"It was a draw!";
        }

        [alertView addButtonWithTitle:@"Play again"];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // reset game
    self.myLabelOne.text = @"";
    self.myLabelTwo.text = @"";
    self.myLabelThree.text = @"";
    self.myLabelFour.text = @"";
    self.myLabelFive.text = @"";
    self.myLabelSix.text = @"";
    self.myLabelSeven.text = @"";
    self.myLabelEight.text = @"";
    self.myLabelNine.text = @"";

    [self initGame];
}

- (void)setTurnTimer
{
    [self removeTurnTimer];
	self.turnTime = 5;
    // 5 seconds for each turn
    self.turnTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTurnTimer:) userInfo:nil repeats:YES];
}

- (void)onTurnTimer:(NSTimer *)timer
{
	if (-- self.turnTime <= 0) {
		[self stopDrag];
		[self endTurn];
	}

	[self updateTimeLabelText];
}

- (void)removeTurnTimer
{
    if (self.turnTimer) {
        [self.turnTimer invalidate];
        self.turnTimer = nil;
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
    else
    {
        // If all of the slots are taken
        if ([self.myLabelOne.text length] > 0 &&
            [self.myLabelTwo.text length] > 0 &&
            [self.myLabelThree.text length] > 0 &&
            [self.myLabelFour.text length] > 0 &&
            [self.myLabelFive.text length] > 0 &&
            [self.myLabelSix.text length] > 0 &&
            [self.myLabelSeven.text length] > 0 &&
            [self.myLabelEight.text length] > 0 &&
            [self.myLabelNine.text length] > 0)
        {
            winner = @"-";
        }
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
	self.currentPlayer = [self.currentPlayer isEqualToString:@"X"] ? @"O" : @"X";
    self.whichPlayerLabel.text = self.currentPlayer;
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
        // stop drag and set the target label
        UILabel *targetLabel = [self findLabelUsingPoint:self.draggableLabel.center];
        [self setTappedLabelAndEndTurn:targetLabel];
        [self stopDrag];
    }
}

- (void)stopDrag
{
    // return draggable label it to its original position
    self.draggableLabel.center = self.draggableLabelOriginalPosition;
    self.isDraggingLabel = NO;
}

- (void)updateTimeLabelText
{
	self.timeLabel.text = [NSString stringWithFormat:@"%d", self.turnTime];
}

@end
