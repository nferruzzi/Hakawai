//
//  TableDemoViewController.m
//  HakawaiDemo
//
//  Created by Nicola Ferruzzi on 03/03/15.
//  Copyright (c) 2015 LinkedIn. All rights reserved.
//

#import "TableDemoViewController.h"
#import "HKWTextView.h"
#import "HKWMentionsPlugin.h"
#import "MentionsManager.h"

@interface TableDemoViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSArray *fakeModel;
@property (nonatomic, strong) HKWMentionsPlugin *plugin;
@end

@implementation TableDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    self.fakeModel = @[@"dummy",@"dummy",@"dummy",@"bio",@"dummy",@"dummy"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _fakeModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_fakeModel[indexPath.row]];
    
    if ([_fakeModel[indexPath.row] isEqual:@"bio"]) {
        
        UIView *container = [cell viewWithTag:10];
        HKWTextView *textView = (HKWTextView *)[container.subviews firstObject];
        UIButton *fullscreen = (UIButton *)[container.subviews lastObject];

        [fullscreen addTarget:self
                       action:@selector(fullscreenTapped:)
             forControlEvents:UIControlEventTouchUpInside];
        
        // Set up the mentions system
        HKWMentionsChooserPositionMode mode = HKWMentionsChooserPositionModeEnclosedTop;
        // In this demo, the user may explicitly begin a mention with either the '@' or '+' characters
        NSCharacterSet *controlCharacters = [NSCharacterSet characterSetWithCharactersInString:@"@+"];
        // The user may also begin a mention by typing three characters (set searchLength to 0 to disable)
        HKWMentionsPlugin *mentionsPlugin = [HKWMentionsPlugin mentionsPluginWithChooserMode:mode
                                                                           controlCharacters:controlCharacters
                                                                                searchLength:3];
        
        // NOTE: If you want to see an example of a custom chooser, uncomment the following line.
        //        mentionsPlugin.chooserViewClass = [SimpleChooserView class];
        
        
        // If the text view loses focus while the mention chooser is up, and then regains focus, it will automatically put
        //  the mentions chooser back up
        mentionsPlugin.resumeMentionsCreationEnabled = YES;
        // Add edge insets so chooser view doesn't overlap the text view's cosmetic grey border
        mentionsPlugin.chooserViewEdgeInsets = UIEdgeInsetsMake(2, 0.5, 0.5, 0.5);
        self.plugin = mentionsPlugin;
        self.plugin.chooserViewBackgroundColor = LIGHT_GRAY_COLOR;
        // The mentions plug-in requires a delegate, which provides it with mentions entities in response to a query string
        mentionsPlugin.delegate = [MentionsManager sharedInstance];
        mentionsPlugin.stateChangeDelegate = [MentionsManager sharedInstance];
        textView.controlFlowPlugin = mentionsPlugin;        
    }
    
    return cell;
}

- (void)fullscreenTapped:(UIButton *)sender
{
    UIView *container = sender.superview;
    [self.view addSubview:container];
    
    NSArray *constraints;
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[c]|"
                                                          options:0
                                                          metrics:nil
                                                            views:@{@"c":container}];
    [self.view addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[c]-80-|"
                                                          options:0
                                                          metrics:nil
                                                            views:@{@"c":container}];
    [self.view addConstraints:constraints];
}

@end
