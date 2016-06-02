//
//  FullDisplayTableViewController.m
//  Kaviar
//
//  Created by Tapan Srivastava on 5/19/16.
//  Copyright © 2016 Institute of Systems Biology. All rights reserved.
//

#import "FullDisplayTableViewController.h"

@interface FullDisplayTableViewController ()

@end

@implementation FullDisplayTableViewController
{
	bool lastWasVar;
	UIColor *lastColor;
}
- (void)viewDidLoad {
    [super viewDidLoad];
	lastWasVar = false;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (self.fullCellTitles && self.fullCellTitles.count != 0)
	{
		return self.fullCellTitles.count;
	}
	else
	{
		return 1;
	}
}

//change cell height if 'Sources' list too long
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString* cellTitle = [self.fullCellTitles objectAtIndex:indexPath.row];
	
	if (cellTitle.length < 50)
	{
		return 44.0f;
	}
		
	CGFloat width = [UIScreen mainScreen].bounds.size.width;
	
	float lengthPerLines = 60.0f;
	
	if (width == 414)
	{
		lengthPerLines = 110.0f;
	}
	else if (width == 375)
	{
		lengthPerLines = 105.0f;
	}
	else if (width == 320)
	{
		lengthPerLines = 95.0f;
	}
	
	if (cellTitle.length > 900)
	{
		lengthPerLines = 125.0f;
	}
	else if (cellTitle.length > 750)
	{
		lengthPerLines = 150.0f;
	}

	float rowsPerCell = (float)cellTitle.length / lengthPerLines;
	float cellHeight = rowsPerCell * 44.0f;
	
	return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* cellIdentifier = @"FullDisplayCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
	cell.textLabel.backgroundColor = [UIColor clearColor];
	
	if (self.fullCellTitles && self.fullCellTitles.count != 0)
	{
		[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

		NSString* cellTitle = [self.fullCellTitles objectAtIndex:indexPath.row];
		
		cell.textLabel.numberOfLines = 50;

		if (cellTitle.length < 750)
		{
			UIFont *normalFont = [UIFont fontWithName:@"HelveticaNeue" size:14];
			cell.textLabel.font = normalFont;
		}
		else if (cellTitle.length < 900)
		{
			UIFont *condensedFont = [UIFont fontWithName:@"HelveticaNeue" size:11];
			cell.textLabel.font = condensedFont;
		}
		else
		{
			UIFont *superCondensedFont = [UIFont fontWithName:@"HelveticaNeue" size:9];
			cell.textLabel.font = superCondensedFont;
		}
		
		
		UIColor *backgroundColor1 = [UIColor colorWithRed:0 green:0.247 blue:0.447 alpha:0.4];
		UIColor *backgroundColor2 = [UIColor colorWithRed:0 green:0.247 blue:0.447 alpha:0.2];

		if (indexPath.row == 0)
		{
			lastWasVar = false;
			cell.backgroundColor = backgroundColor1;
			lastColor = backgroundColor1;
		}
		else
		{
			if (lastWasVar == true)
			{
				cell.backgroundColor = lastColor;
				if ([cellTitle containsString:@"Sources"])
				{
					lastWasVar = false;
				}
			}
			else
			{
				if ([lastColor isEqual:backgroundColor1])
				{
					cell.backgroundColor = backgroundColor2;
					lastColor = backgroundColor2;
				}
				else
				{
					cell.backgroundColor = backgroundColor1;
					lastColor = backgroundColor1;
				}

				if ([cellTitle containsString:@"Variant:"] || [cellTitle containsString:@"Frequency"] || [cellTitle containsString:@"Category"])
				{
					lastWasVar = true;
				}
			}
		}

		cell.textLabel.text = cellTitle;
	}
	else
	{
		[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];

		cell.backgroundColor = [UIColor whiteColor];
		cell.textLabel.text = @"No Data Inputted. Please Try Again.";
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
