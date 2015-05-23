//
//  LHConfig.m
//  LiveHouse
//
//  Created by Masayuki Uehara on 8/31/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import "LHBaseConfig.h"

//NSString *const kConfigAPIBaseURL = @"kConfigAPIBaseURL";
//NSString *const kConfigAPIBaseAuthUsername = @"kConfigAPIBaseAuthUsername";
//NSString *const kConfigAPIBaseAuthPassword = @"kConfigAPIBaseAuthPassword";
//NSString *const kConfigCookieDomain = @"kConfigCookieDomain";

#define kSelectedConfigKey @"selected.config"

@interface LHBaseConfig()

@property (nonatomic) LHBaseConfigItem* item;
@property (nonatomic) NSArray* items;

@end

@implementation LHBaseConfig

+ (id)sharedInstance
{
    static LHBaseConfig* _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        assert(self.items.count > 0);
        
        NSString* name = [[NSUserDefaults standardUserDefaults] stringForKey:kSelectedConfigKey];
        if (!name) {
            LHBaseConfigItem* item = self.items[0];
            name =item.name;
        }
        
        LHBaseConfigItem* item = [self itemAtName:name];
        if (!item) item = self.items[0];
        
        self.item = item;
        
    }
    
    return self;
}

- (NSString*)selectedName
{
    return self.item.name;
}

- (NSArray*)itemNames
{
    NSMutableArray* names = @[].mutableCopy;
    for (LHBaseConfigItem* item in self.items) {
        [names addObject:item.name];
    }
    
    return names;
}

- (LHBaseConfigItem*)itemAtName:(NSString*)name
{
    for (LHBaseConfigItem *item in self.items) {
        if ([item.name isEqualToString:name]) {
            return item;
        }
    }
    return nil;
}

- (void)setEnvironment:(NSString*)name
{
    LHBaseConfigItem* item = [self itemAtName:name];
	if (item) {
		self.item = item;
        
		[[NSUserDefaults standardUserDefaults] setObject:name forKey:kSelectedConfigKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (id)objectForKey:(id)key
{
    return [self.item.dict objectForKey:key];
}


- (void)showSelectView:(UIViewController*)fromController
{
    LHBaseConfigViewController* controller = [[LHBaseConfigViewController alloc] init];
    
    controller.config = self;
    fromController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [fromController presentModalViewController:controller animated:NO];
}

@end


//--------------------------------------------------------------------------------

@implementation LHBaseConfigItem

-(id)initWithName:(NSString *)name withDict:(NSDictionary *)dict
{
    self = [super init];
    
    if (self) {
        self.name = name;
        self.dict = dict;
    }
    return self;
}

@end


//--------------------------------------------------------------------------------

@interface LHBaseConfigViewController()
@property (nonatomic) NSArray* names;
@end

@implementation LHBaseConfigViewController

- (void)viewDidLoad
{
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor colorWithWhite:.0f alpha:.5f]];
    self.names = [self.config itemNames];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUInteger selectedIndex = [self.names indexOfObject:self.config.selectedName];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
}

#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.names count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:identifier];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    NSString* name =self.names[indexPath.row];
    cell.textLabel.text = name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* name = [self.names objectAtIndex:indexPath.row];
    if (![name isEqualToString:self.config.selectedName]) {
        
        // index
        [self.config setEnvironment:name];
    }
    
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

@end
