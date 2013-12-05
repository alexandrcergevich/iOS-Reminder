//
//  SleepSelectMusicController.m
//  AlarmAndClock
//
//  Created by Alexandr on 11/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SleepSelectMusicController.h"
#import "Database.h"
@implementation SleepSelectMusicController
@synthesize songList;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.songList = [NSMutableArray arrayWithArray:[Database getSongList]];

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *editBt = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(addAction:)];
	
	self.navigationItem.rightBarButtonItem = editBt;
	self.navigationItem.title = @"Song List";
    isEditing = NO;
    [self.tableView setEditing:YES];
    
 //   self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
}
- (void)addAction:(id)sender
{
    
    isEditing = !isEditing;
    if (isEditing)
    {
        [self.navigationItem.rightBarButtonItem  setTitle:@"Done"];
    }
    else
    {
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [Database updateSongList:self.songList];
    }
    [self.tableView reloadData];
    NSLog(@"Hey here, button pressed%@", self.tableView.isEditing?@"Done":@"Edit");
}


- (void)viewDidUnload
{
    
    [super viewDidUnload];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"The view is about to disappear");
    [super viewWillDisappear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (isEditing)
        return [songList count] + 1;
    return [songList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if (isEditing)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"Add song";
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        else
        {
            SongInfo *info = [songList objectAtIndex:indexPath.row - 1];
            cell.textLabel.text =  info.songTitle;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.showsReorderControl = NO;
    }
    else
    {
        SongInfo *info = [songList objectAtIndex:indexPath.row];
        cell.textLabel.text =  info.songTitle;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.showsReorderControl = YES;
    }
    cell.showsReorderControl = YES;
    
    NSLog(@"showReorderControl %d", cell.showsReorderControl);
    // Configure the cell...
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isEditing)
        return NO;
    return YES;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSLog(@"Moving source:%d , destination:%d", sourceIndexPath.row, destinationIndexPath.row);
    if (sourceIndexPath.row < 0 || sourceIndexPath.row >= [songList count])
        return;
    if (destinationIndexPath.row < 0 || destinationIndexPath.row >= [songList count])
        return;
    if (destinationIndexPath.row == sourceIndexPath.row)
        return;
    SongInfo *info = [songList objectAtIndex:sourceIndexPath.row];
    [songList removeObjectAtIndex:sourceIndexPath.row];
    [songList insertObject:info atIndex:destinationIndexPath.row];
    [Database updateSongList:self.songList];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (isEditing)
    {
        if (indexPath.row == 0)
            return UITableViewCellEditingStyleInsert;
        return UITableViewCellEditingStyleDelete;
        NSLog(@"Editing Style");
    }
//    return UITableViewCellEditingStyleDelete;;
    return UITableViewCellEditingStyleNone;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.songList removeObjectAtIndex:(indexPath.row - 1)];
        [self.tableView reloadData];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        MPMediaPickerController * picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
        if (picker != nil)
        {
            picker.delegate = self;
            picker.allowsPickingMultipleItems = YES;
            picker.prompt = @"Select musics to play";
            picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentModalViewController:picker animated:YES];
            [picker release];
            
        }

    }   
}
#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected %d", indexPath.row);
    if (isEditing)
    {
        if (indexPath.row == 0)
        {
            MPMediaPickerController * picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAny];
            if (picker != nil)
            {
                picker.delegate = self;
                picker.allowsPickingMultipleItems = YES;
                picker.prompt = @"Select musics to play";
                picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                [self presentModalViewController:picker animated:YES];
                [picker release];
                
            }
        }
    }
}
 
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



#pragma mark MPMediaPickerControllerDelegate
- (void) mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
	[mediaPicker dismissModalViewControllerAnimated:YES];
    NSLog (@"Picker count %d", [mediaItemCollection count]);
    NSArray *items = [mediaItemCollection items];
    for (MPMediaItem *item in items) {
        SongInfo *info = [[[SongInfo alloc] init] autorelease];
        info.persistentID = [NSString stringWithFormat:@"%d",[item valueForProperty:MPMediaItemPropertyPersistentID]];
        info.songTitle = [item valueForProperty:MPMediaItemPropertyTitle];
        [self.songList addObject:info];
    
        NSLog(@"%@, %@", [item valueForProperty:MPMediaItemPropertyPersistentID], [item valueForProperty:MPMediaItemPropertyTitle]);
    }
    [self.tableView reloadData];
   
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [mediaPicker dismissModalViewControllerAnimated:YES];
}

-(void)dealloc
{
    [songList release];
    [super dealloc];
}

@end
