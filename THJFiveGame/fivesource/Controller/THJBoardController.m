//
//  THJBoardController.m
//  THJFiveGame
//
//  Created by tianhaojie on 2018/12/23.
//  Copyright © 2018 tianXiaotian. All rights reserved.
//

#import "THJBoardController.h"
#import "THJPacket.h"
#import "THJMenuContoller.h"
#import <CocoaAsyncSocket/GCDAsyncSocket.h>

NSString * const INFO_YOUR_TURN = @"您的回合";
NSString * const INFO_OPPONENT_TURN = @"对方回合";

@interface THJBoardController ()<GCDAsyncSocketDelegate>
{
    THJBoard *board;
    THJPlayerType playerType;
    THJPlayer *AI;
    int timeSecBlack;
    int timeMinBlack;
    int timeSecWhite;
    int timeMinWhite;
    NSTimer *timer;
    BOOL isHost;
    BOOL oppositeReset;
    BOOL shouldDismiss;
    THJMove *whiteMove;
    THJMove *blackMove;
}

@property (weak, nonatomic) IBOutlet UILabel *lblInformation;
@property (weak, nonatomic) IBOutlet UIButton *btnReset;
@property (weak, nonatomic) IBOutlet UIButton *btnUndo;
@property (weak, nonatomic) IBOutlet UILabel *timerWhiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerBlackLabel;
@property (strong, nonatomic) UIAlertController *resetWaitAlertController;
@property (strong, nonatomic) UIAlertController *resetChooseAlertController;
@property (strong, nonatomic) UIAlertController *resetRejectAlertController;
@property (strong, nonatomic) UIAlertController *waitAlertController;
@property (strong, nonatomic) UIAlertController *winAlertController;
@property (strong, nonatomic) UIAlertController *undoWaitAlertController;
@property (strong, nonatomic) UIAlertController *undoChooseAlertController;
@property (strong, nonatomic) UIAlertController *undoRejectAlertController;
@property (strong, nonatomic) GCDAsyncSocket *socket;


@end

@implementation THJBoardController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    board = [[THJBoard alloc] init];
    
    // First piece will always be black
    playerType = THJPlayerTypeBlack;
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _boardView.delegate = self;
    
    _btnUndo.enabled = NO;
    if (_gameMode == THJModeSingle) {
        [self choosePlayerType];
    } else if (_gameMode == THJModeDouble) {
        [self startTimer];
    } else if (_gameMode == THJModeLAN && shouldDismiss == YES) {
        [self dismissViewControllerAnimated:NO completion:nil];
    } else if (_gameMode == THJModeLAN && _socket == nil) {
        [self performSegueWithIdentifier:@"findGame" sender:nil];
    } else if (_gameMode == THJModeLAN && _socket != nil) {
        [self startGameInLANMode];
    }
}

#pragma mark - Gomoku basic logic

- (void)startGameInLANMode {
    [self startTimer];
    if (!isHost) {
        _lblInformation.text = INFO_OPPONENT_TURN;
        self.waitAlertController = [UIAlertController alertControllerWithTitle:@"请等待对方先下" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:_waitAlertController animated:YES completion:nil];
    } else {
        _lblInformation.text = INFO_YOUR_TURN;
    }
    
}

- (void)choosePlayerType {
    
    THJDifficulty difficulty;
    
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"difficulty"]) {
        case 0:
            difficulty = THJDifficultyEasy;
            break;
        case 1:
            difficulty = THJDifficultyMedium;
            break;
        case 2:
            difficulty = THJDifficultyHard;
            break;
        default:
            difficulty = THJDifficultyEasy;
            break;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请您选择先后" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionBlack = [UIAlertAction actionWithTitle:@"我先" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startTimer];
        AI = [[THJPlayer alloc] initWithPlayer:THJPlayerTypeWhite difficulty:difficulty];
        _lblInformation.text = INFO_YOUR_TURN;
    }];
    UIAlertAction *actionWhite = [UIAlertAction actionWithTitle:@"我后" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startTimer];
        AI = [[THJPlayer alloc] initWithPlayer:THJPlayerTypeBlack difficulty:difficulty];
        [self AIPlayWithMove:nil];
        _lblInformation.text = INFO_OPPONENT_TURN;
    }];
    [alert addAction:actionBlack];
    [alert addAction:actionWhite];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)saveMove:(THJMove *)move {
    if (playerType == THJPlayerTypeBlack) {
        blackMove = move;
    } else {
        whiteMove = move;
    }
}

- (void)moveAtPoint:(THJPoint)point sendPacketInLAN:(BOOL)sendPacket {
    if([board canMoveAtPoint:point]) {
        if (_gameMode == THJModeDouble) {
            _btnUndo.enabled = YES;
        }
        
        THJMove *move = [[THJMove alloc] initWithTHJPlayer:playerType amdPoint:point];
        
        [board makeMove:move];
        [self saveMove:move];
        
        [_boardView insertPieceAtPoint:point playerType:playerType];
        
        // play move sound
        THJMenuContoller *menuController = (THJMenuContoller *)self.presentingViewController;
        [menuController.moveSoundPlayer play];
        
        if ([board checkWinAtPoint:point]) {
            if (_gameMode == THJModeLAN && sendPacket == YES) {
                NSDictionary *data = @{ @"i" : @(point.i), @"j" : @(point.j) };
            
                 THJPacket *packet = [[THJPacket alloc] initWithTHJData:data andType:THJPacketTypeMove andAction:THJPacketActionUnknown];
                [self sendPacket:packet];
            }
            [self handleWin];
        } else {
            [self switchPlayer];
            
            if (_gameMode == THJModeSingle) {
                [self AIPlayWithMove:move];
            } else if (_gameMode == THJModeLAN && sendPacket == YES) {
                _btnUndo.enabled = NO;
                NSDictionary *data = @{ @"i" : @(point.i), @"j" : @(point.j) };
                 THJPacket *packet = [[THJPacket alloc] initWithTHJData:data andType:THJPacketTypeMove andAction:THJPacketActionUnknown];
                [self sendPacket:packet];
                _boardView.userInteractionEnabled = NO;
            } else if (_gameMode == THJModeLAN && sendPacket == NO) {
                _boardView.userInteractionEnabled = YES;
            }
        }
    }
}

- (void)AIPlayWithMove:(THJMove *)move {
    _btnReset.enabled = NO;
    _btnUndo.enabled = NO;
    _boardView.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [AI update:move];
        THJMove *AIMove = [AI getMove];
        [board makeMove:AIMove];
        [self saveMove:AIMove];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _btnReset.enabled = YES;
            if (blackMove != nil && whiteMove != nil) {
                _btnUndo.enabled = YES;
            }
            
            [_boardView insertPieceAtPoint:AIMove.point playerType:AIMove.playerType];
            
            // play move sound
            THJMenuContoller *menuController = (THJMenuContoller *)self.presentingViewController;
            [menuController.moveSoundPlayer play];
            
            if ([board checkWinAtPoint:AIMove.point]) {
                [self handleWin];
                NSLog(@"win %ld", (long)playerType);
            } else {
                [self switchPlayer];
                _boardView.userInteractionEnabled = YES;
            }
        });
        
    });
    
}

- (void)handleWin {
    NSString *alertTitle;
    if (playerType == THJPlayerTypeBlack) {
        alertTitle = @"黑方获胜!";
    } else {
        alertTitle = @"白方获胜!";
    }
    
    [self dismissAlertControllers];
    
    self.winAlertController = [UIAlertController alertControllerWithTitle:alertTitle message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [_winAlertController addAction:action];
    [self presentViewController:_winAlertController animated:YES completion:nil];
    
    _btnReset.enabled = YES;
    _btnUndo.enabled = NO;
    _boardView.userInteractionEnabled = NO;
    [self stopTimer];
}

- (void)handleReset {
    [self stopTimer];
    [board initBoard];
    _boardView.userInteractionEnabled = YES;
    playerType = THJPlayerTypeBlack;
    [_boardView reset];
    _btnUndo.enabled = NO;
    blackMove = nil;
    whiteMove = nil;
}

- (void)switchPlayer {
    if (playerType == THJPlayerTypeBlack) {
        playerType = THJPlayerTypeWhite;
    } else {
        playerType = THJPlayerTypeBlack;
    }
    if (_lblInformation.text == INFO_YOUR_TURN) {
        _lblInformation.text = INFO_OPPONENT_TURN;
    } else if (_lblInformation.text == INFO_OPPONENT_TURN) {
        _lblInformation.text = INFO_YOUR_TURN;
    }
}

- (void)startTimer {
    // initialize the timer label
    timeSecBlack = 0;
    timeMinBlack = 0;
    timeSecWhite = 0;
    timeMinWhite = 0;
    
    NSString* timeNow = [NSString stringWithFormat:@"%02d:%02d", timeMinBlack, timeSecBlack];
    
    _timerWhiteLabel.text = timeNow;
    _timerBlackLabel.text = timeNow;
    
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
}

- (void)stopTimer
{
    [timer invalidate];
    timer = nil;
}

- (void)timerTick:(NSTimer *)timer {
    if (playerType == THJPlayerTypeBlack) {
        timeSecBlack++;
        if (timeSecBlack == 60)
        {
            timeSecBlack = 0;
            timeMinBlack++;
        }
        //Format the string 00:00
        NSString* timeNow = [NSString stringWithFormat:@"%02d:%02d", timeMinBlack, timeSecBlack];
        _timerBlackLabel.text= timeNow;
    } else {
        timeSecWhite++;
        if (timeSecWhite == 60)
        {
            timeSecWhite = 0;
            timeMinWhite++;
        }
        //Format the string 00:00
        NSString* timeNow = [NSString stringWithFormat:@"%02d:%02d", timeMinWhite, timeSecWhite];
        _timerWhiteLabel.text= timeNow;
    }
}

- (void) dismissAlertControllers {
    [_winAlertController dismissViewControllerAnimated:YES completion:nil];
    [_waitAlertController dismissViewControllerAnimated:YES completion:nil];
    [_resetWaitAlertController dismissViewControllerAnimated:YES completion:nil];
    [_resetChooseAlertController dismissViewControllerAnimated:YES completion:nil];
    [_resetRejectAlertController dismissViewControllerAnimated:YES completion:nil];
    [_undoWaitAlertController dismissViewControllerAnimated:YES completion:nil];
    [_undoChooseAlertController dismissViewControllerAnimated:YES completion:nil];
    [_undoRejectAlertController dismissViewControllerAnimated:YES completion:nil];
    
    self.winAlertController = nil;
    self.waitAlertController = nil;
    self.resetWaitAlertController = nil;
    self.resetChooseAlertController = nil;
    self.resetRejectAlertController = nil;
    self.undoWaitAlertController = nil;
    self.undoChooseAlertController = nil;
    self.undoRejectAlertController = nil;
}


#pragma mark - Socket related functions

- (void)sendPacket:(THJPacket *)packet {
    
    // Encode Packet Data
    NSMutableData *packetData = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:packetData];
    [archiver encodeObject:packet forKey:@"packet"];
    [archiver finishEncoding];
    
    // Initialize Buffer
    NSMutableData *buffer = [[NSMutableData alloc] init];
    
    // Fill Buffer
    [buffer appendBytes:packetData.bytes length:packetData.length];
    
    [_socket writeData:buffer withTimeout:-1.0 tag:0];
    
}


- (void)parseData:(NSData *)data {
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    THJPacket *packet = [unarchiver decodeObjectForKey:@"packet"];
    [unarchiver finishDecoding];
    
    
    if ([packet type] == THJPacketTypeMove) {
        NSNumber *i = [(NSDictionary *)[packet data] objectForKey:@"i"];
        
        NSNumber *j = [(NSDictionary *)[packet data] objectForKey:@"j"];
        
        THJPoint point;
        point.i = i.intValue;
        point.j = j.intValue;
        
        if (_waitAlertController != nil) {
            [_waitAlertController dismissViewControllerAnimated:YES completion:nil];
            self.waitAlertController = nil;
        }
        
        [self moveAtPoint:point sendPacketInLAN:NO];
        if (blackMove != nil && whiteMove != nil && ![board checkWinAtPoint:point]) {
            _btnUndo.enabled = YES;
        }
        
        
    } else if ([packet type] == THJPacketTypeReset) {
        if ([packet action] == THJPacketActionResetRequest) {
            
            [self dismissAlertControllers];
            
            self.resetChooseAlertController = [UIAlertController alertControllerWithTitle:@"对方请求重开" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionAgree = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                 THJPacket *packet = [[THJPacket alloc] initWithTHJData:nil andType:THJPacketTypeReset andAction:THJPacketActionResetAgree];

                [self sendPacket:packet];
                [self handleReset];
                [self startGameInLANMode];
            }];
            
            UIAlertAction *actionReject = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 THJPacket *packet = [[THJPacket alloc] initWithTHJData:nil andType:THJPacketTypeReset andAction:THJPacketActionResetReject];
                
                [self sendPacket:packet];
            }];
            
            [_resetChooseAlertController addAction:actionAgree];
            [_resetChooseAlertController addAction:actionReject];
            [self presentViewController:_resetChooseAlertController animated:YES completion:nil];
            
        } else if ([packet action] == THJPacketActionResetAgree) {
            [self dismissAlertControllers];
            
            [self handleReset];
            [self startGameInLANMode];
            
        } else if ([packet action] == THJPacketActionResetReject) {
            [self dismissAlertControllers];
            
            self.resetRejectAlertController = [UIAlertController alertControllerWithTitle:@"对方拒绝了你的请求" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [_resetRejectAlertController addAction:action];
            [self presentViewController:_resetRejectAlertController animated:YES completion:nil];
        }
        
    } else if (packet.type == THJPacketTypeUndo) {
        if (packet.action == THJPacketActionUndoRequest) {
            [self dismissAlertControllers];
            
            self.undoChooseAlertController = [UIAlertController alertControllerWithTitle:@"对方请求悔棋" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionAgree = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 THJPacket *packet = [[THJPacket alloc] initWithTHJData:nil andType:THJPacketTypeUndo andAction:THJPacketActionUndoAgree];
                [self sendPacket:packet];
                [board undoMove:blackMove];
                [board undoMove:whiteMove];
                [_boardView removeImageWithCount:2];
                blackMove = nil;
                whiteMove = nil;
                _btnUndo.enabled = NO;
            }];
            
            UIAlertAction *actionReject = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    THJPacket *packet = [[THJPacket alloc] initWithTHJData:nil andType:THJPacketTypeUndo andAction:THJPacketActionUndoReject];
                [self sendPacket:packet];
            }];
            
            [_undoChooseAlertController addAction:actionAgree];
            [_undoChooseAlertController addAction:actionReject];
            [self presentViewController:_undoChooseAlertController animated:YES completion:nil];
        } else if (packet.action == THJPacketActionUndoAgree) {
            [self dismissAlertControllers];
            
            [board undoMove:blackMove];
            [board undoMove:whiteMove];
            [_boardView removeImageWithCount:2];
            blackMove = nil;
            whiteMove = nil;
            _btnUndo.enabled = NO;
        } else if (packet.action == THJPacketActionUndoReject) {
            [self dismissAlertControllers];
            
            self.undoRejectAlertController = [UIAlertController alertControllerWithTitle:@"对方拒绝了你的请求" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [_undoRejectAlertController addAction:action];
            [self presentViewController:_undoRejectAlertController animated:YES completion:nil];
        }
    }
}


#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)socket didReadData:(NSData *)data withTag:(long)tag {
    [self parseData:data];
    [socket readDataWithTimeout:-1 tag:1];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)socket withError:(NSError *)error {
    if (error) {
        NSLog(@"Socket Did Disconnect with Error %@ with User Info %@.", error, [error userInfo]);
    } else {
        NSLog(@"Socket Disconnect.");
    }
    
    if (_socket == socket) {
        _socket.delegate = nil;
        _socket = nil;
    }
    [self stopTimer];
    
    [self dismissAlertControllers];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"对方已经断开连接" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - THJBoardViewDelegate
- (void)THJboardView:(nonnull THJBoardView *)boardView didTapOnPoint:(THJPoint)point {
     [self moveAtPoint:point sendPacketInLAN:YES];
}


#pragma mark - THJHostListControllerDelegate

//- (void)controller:(THJHostListController *)controller didJoinGameOnSocket:(GCDAsyncSocket *)socket {
//    self.socket = socket;
//    [_socket setDelegate:self];
//    _boardView.userInteractionEnabled = NO;
//    isHost = NO;
//
//    [_socket readDataWithTimeout:-1 tag:1];
//
//}
//
//- (void)controller:(THJHostListController *)controller didHostGameOnSocket:(GCDAsyncSocket *)socket {
//    self.socket = socket;
//    [_socket setDelegate:self];
//    isHost = YES;
//    [_socket readDataWithTimeout:-1 tag:1];
//}

- (void)shouldDismiss {
    shouldDismiss = YES;
}


#pragma mark - IBAction

- (IBAction)btnReset_TouchUp:(UIButton *)sender {
    
    if (_gameMode == THJModeSingle) {
        [self handleReset];
        [self choosePlayerType];
    } else if (_gameMode == THJModeDouble){
        [self handleReset];
        [self startTimer];
    } else if (_gameMode == THJModeLAN) {
        if (oppositeReset == YES) {
            [self handleReset];
            [self startGameInLANMode];
            
            oppositeReset = NO;
            NSString *data = @"reset";
    
             THJPacket *packet = [[THJPacket alloc] initWithTHJData:data andType:THJPacketTypeReset andAction:THJPacketActionUnknown];
            [self sendPacket:packet];
        } else {
            self.resetWaitAlertController = [UIAlertController alertControllerWithTitle:@"等待对方回应" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:_resetWaitAlertController animated:YES completion:nil];
            THJPacket *packet = [[THJPacket alloc] initWithTHJData:nil andType:THJPacketTypeReset andAction:THJPacketActionResetRequest];
            [self sendPacket:packet];
        }
    }
    
}

- (IBAction)btnUndo_TouchUp:(UIButton *)sender {
    if (_gameMode == THJModeSingle) {
        if (blackMove != nil && whiteMove != nil) {
            [board undoMove:blackMove];
            [board undoMove:whiteMove];
            [AI regret:blackMove];
            [AI regret:whiteMove];
            [_boardView removeImageWithCount:2];
            blackMove = nil;
            whiteMove = nil;
            _btnUndo.enabled = NO;
        }
    } else if (_gameMode == THJModeDouble) {
        if (playerType == THJPlayerTypeBlack) {
            [board undoMove:whiteMove];
            [_boardView removeImageWithCount:1];
            [self switchPlayer];
            _btnUndo.enabled = NO;
            whiteMove = nil;
        } else {
            [board undoMove:blackMove];
            [_boardView removeImageWithCount:1];
            [self switchPlayer];
            _btnUndo.enabled = NO;
            blackMove = nil;
        }
    } else if (_gameMode == THJModeLAN) {
        self.undoWaitAlertController = [UIAlertController alertControllerWithTitle:@"等待对方回应" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:_undoWaitAlertController animated:YES completion:nil];
        THJPacket *packet = [[THJPacket alloc] initWithTHJData:nil andType:THJPacketTypeUndo andAction:THJPacketActionUndoRequest];
    
        [self sendPacket:packet];
        
    }
    
}

- (IBAction)btnBack_TouchUp:(UIButton *)sender {
    [timer invalidate];
    timer = nil;
    [_socket disconnect];
    [self dismissViewControllerAnimated:NO completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
