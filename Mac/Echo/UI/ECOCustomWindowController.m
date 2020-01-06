//
//  ECOCustomWindowController.m
//  Echo
//
//  Created by 陈爱彬 on 2019/4/29. Maintain by 陈爱彬
//  Description 
//

#import "ECOCustomWindowController.h"

@interface ECOCustomWindowController ()

@end

@implementation ECOCustomWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.titlebarAppearsTransparent = YES;
    self.window.styleMask |= NSWindowStyleMaskFullSizeContentView;
    
    self.window.backgroundColor = [NSColor colorNamed:@"deviceBgColor"];
    
    [self.window center];
}
@end
