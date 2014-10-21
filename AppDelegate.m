//
//  AppDelegate.m
//  WifiCommunicationMac
//
//  Created by Samuel Scott Robbins on 10/20/14.
//  Copyright (c) 2014 Scott Robbins. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize window, isConnectedToService, message;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application

    NSString *type = @"TestingProtocol";
    
    _server = [[Server alloc] initWithProtocol:type];
    _server.delegate = self;
    tableView.dataSource = (id<NSTableViewDataSource>)self;
    tableView.delegate = (id<NSTableViewDelegate>)self;
    self.services = [[NSMutableArray alloc] init];
    
    NSError *error = nil;
    if(![_server start:&error]) {
        NSLog(@"error = %@", error);
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)connectToService:(id)sender;
{
    [self.server connectToRemoteService:[self.services objectAtIndex:selectedRow]];
}

- (IBAction)sendMessage:(id)sender;
{
    message = [self.messageTextField stringValue];
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    [self.server sendData:data error:&error];
}

- (void)serverRemoteConnectionComplete:(Server *)server
{
    NSLog(@"Connected to service");
    
    self.isConnectedToService = YES;
    
    connectedRow = selectedRow;
    [tableView reloadData];
}


- (void)serverStopped:(Server *)server
{
    NSLog(@"Disconnected from service");
    self.isConnectedToService = NO;
    connectedRow = -1;
    [tableView reloadData];
}

- (void)server:(Server *)server didNotStart:(NSDictionary *)errorDict
{
    NSLog(@"Server did not start %@", errorDict);
}

- (void)server:(Server *)server didAcceptData:(NSData *)data
{
    NSLog(@"Server did accept data %@", data);
    NSString *textReceived = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if(nil != textReceived || [textReceived length] > 0) {
        [self.receivedTextField setStringValue:textReceived];
    } else {
        [self.receivedTextField setStringValue:@"no data received"];
    }
}

- (void)server:(Server *)server lostConnection:(NSDictionary *)errorDict
{
    NSLog(@"Lost Connection");
    
    self.isConnectedToService = NO;
    connectedRow = -1;
    [tableView reloadData];
}

- (void)serviceAdded:(NSNetService *)service moreComing:(BOOL)more
{
    NSLog(@"Added a service: %@", service.name);
    
    [self.services addObject:service];
    if(!more) {
        [tableView reloadData];
    }
}

- (void)serviceRemoved:(NSNetService *)service moreComing:(BOOL)more
{
    NSLog(@"Removed a service: %@", service.name);
    
    [self.services removeObject:service];
    if(!more) {
        [tableView reloadData];
    }
}

#pragma mark - TableView Properties
- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    if (rowIndex == connectedRow)
        [aCell setTextColor:[NSColor greenColor]];
    else
        [aCell setTextColor:[NSColor blackColor]];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{
    return [[self.services objectAtIndex:rowIndex] name];
}

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    NSLog(@"Count: %lu", (unsigned long)[self.services count]);
    return (int)[self.services count];
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification;
{
    selectedRow = [[aNotification object] selectedRow];
}


@end
