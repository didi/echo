//
//  ECOTemplateOutlineCell.m
//  Echo
//
//  Created by 陈爱彬 on 2019/9/16. Maintain by 陈爱彬
//  Description 
//

#import "ECOTemplateOutlineCell.h"

@interface ECOTemplateOutlineCell()

@property (weak) IBOutlet NSBox *bgBox;
@end

@implementation ECOTemplateOutlineCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)setSelectedMark:(BOOL)selectedMark {
    _selectedMark = selectedMark;
    self.bgBox.hidden = !_selectedMark;
}

@end
