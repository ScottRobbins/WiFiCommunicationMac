//
//  AppDelegate.h
//  WifiCommunicationMac
//
//  Created by Samuel Scott Robbins on 10/20/14.
//  Copyright (c) 2014 Scott Robbins. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Server.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, ServerDelegate>
{
    __weak IBOutlet NSTableView *tableView;
    Server *_server;
    NSMutableArray *_services;
    NSString *message;
    NSInteger selectedRow, connectedRow;
    BOOL isConnectedToService;
}

@property (assign) IBOutlet NSWindow *window;
@property(nonatomic, retain) Server *server;
@property(nonatomic, retain) NSMutableArray *services;
@property(readwrite, copy) NSString *message;
@property(readwrite, nonatomic) BOOL isConnectedToService;
@property (weak) IBOutlet NSTextField *messageTextField;
@property (weak) IBOutlet NSTextField *receivedTextField;

// Interface methods
- (IBAction)connectToService:(id)sender;
- (IBAction)sendMessage:(id)sender;

@end

