//
//  TimeSheetsTableCellTableViewCell.m
//  iPadScheduler
//
//  Created by Deja Cespedes on 23/04/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "TimeSheetsCell.h"
#import "BaseViewController.h"

@implementation TimeSheetsCell
@synthesize jobTitleLbl;
@synthesize businessInfoLbl;
@synthesize clientInfoLbl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.jobTitleLbl.font = [UIFont fontWithName:@"Avenir" size:12];
        self.businessInfoLbl.font = [UIFont fontWithName:@"Avenir" size:12];
        self.clientInfoLbl.font = [UIFont fontWithName:@"Avenir" size:10];

        [self.clientInfoLbl sizeToFit];
        [self.jobTitleLbl sizeToFit];
        [self.businessInfoLbl sizeToFit];
        
        self.jobTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 800, 35)]; // width value needs resizing for different iPads
        self.businessInfoLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 800, 82.5)];
        self.clientInfoLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 117.5, 800, 82.5)];

        self.jobTitleLbl.backgroundColor = ORANGE;
        self.businessInfoLbl.backgroundColor = LIGHT_GREY;
        self.clientInfoLbl.backgroundColor = BEIGE;

        self.jobTitleLbl.textColor = [UIColor whiteColor];
        self.businessInfoLbl.textColor = DARK_GREY;
        self.clientInfoLbl.textColor = DARK_GREY;
        
        self.jobTitleLbl.numberOfLines = 1;
        self.clientInfoLbl.numberOfLines = 2;
        
        self.jobTitleLbl.lineBreakMode = NSLineBreakByWordWrapping;
        self.clientInfoLbl.lineBreakMode = NSLineBreakByWordWrapping;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.frame = CGRectMake(0, 0, self.bounds.size.width, 70);
        
        [self addSubview:self.jobTitleLbl];
        [self addSubview:self.businessInfoLbl];
        [self addSubview:self.clientInfoLbl];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
