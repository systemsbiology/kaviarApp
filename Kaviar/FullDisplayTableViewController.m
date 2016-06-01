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

- (void)viewDidLoad {
    [super viewDidLoad];

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
		
	if (cellTitle.length > 1000)
	{
		return 1000.0f;
	}
	else if (cellTitle.length > 750)
	{
		return 800.0f;
	}
	else if (cellTitle.length > 500)
	{
		return 600.0f;
	}
	else if (cellTitle.length > 250)
	{
		return 450.0f;
	}
	else if (cellTitle.length > 100)
	{
		return 315.0f;
	}
	else if (cellTitle.length > 80)
	{
		return 250.0f;
	}
	else if (cellTitle.length > 60)
	{
		return 175.0f;
	}
	else if (cellTitle.length > 40)
	{
		return 100.0f;
	}
	
	return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* cellIdentifier = @"FullDisplayCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
	cell.textLabel.backgroundColor = [UIColor clearColor];
	
	if (self.fullCellTitles && self.fullCellTitles.count != 0)
	{
		NSString* cellTitle = [self.fullCellTitles objectAtIndex:indexPath.row];
		//change font size scaling and number of lines text can appear on based on length of string
		if (cellTitle.length > 1000)
		{
			cell.textLabel.numberOfLines = 195;
			cell.textLabel.minimumScaleFactor = 0.5f;
			cell.textLabel.adjustsFontSizeToFitWidth = true;
		}
		else if (cellTitle.length > 750)
		{
			cell.textLabel.numberOfLines = 145;
			cell.textLabel.minimumScaleFactor = 0.5f;
			cell.textLabel.adjustsFontSizeToFitWidth = true;
		}
		else if (cellTitle.length > 500)
		{
			cell.textLabel.numberOfLines = 95;
			cell.textLabel.minimumScaleFactor = 0.5f;
			cell.textLabel.adjustsFontSizeToFitWidth = true;
		}
		else if (cellTitle.length > 250)
		{
			cell.textLabel.numberOfLines = 45;
			cell.textLabel.minimumScaleFactor = 0.5f;
			cell.textLabel.adjustsFontSizeToFitWidth = true;
		}
		else if (cellTitle.length > 100)
		{
			cell.textLabel.numberOfLines = 15;
			cell.textLabel.minimumScaleFactor = 0.6f;
			cell.textLabel.adjustsFontSizeToFitWidth = true;
		}
		else if (cellTitle.length > 80)
		{
			cell.textLabel.numberOfLines = 11;
			cell.textLabel.minimumScaleFactor = 0.7f;
			cell.textLabel.adjustsFontSizeToFitWidth = true;
		}
		else if (cellTitle.length > 60)
		{
			cell.textLabel.numberOfLines = 7;
			cell.textLabel.minimumScaleFactor = 0.8f;
			cell.textLabel.adjustsFontSizeToFitWidth = true;

		}
		else if (cellTitle.length > 40)
		{
			cell.textLabel.numberOfLines = 3;
			cell.textLabel.minimumScaleFactor = 0.9f;
			cell.textLabel.adjustsFontSizeToFitWidth = true;
		}

		cell.textLabel.text = cellTitle;
	}
	else
	{
		cell.textLabel.text = @"No Data Inputted. Please Try Again.";
	}
	
	UIColor *backgroundColorEven = [UIColor colorWithRed:0 green:0.247 blue:0.447 alpha:0.4];
	UIColor *backgroundColorOdd = [UIColor colorWithRed:0 green:0.247 blue:0.447 alpha:0.2];
	
	if ([self tableView:self.tableView numberOfRowsInSection:1] == 1)
	{
    
		cell.backgroundColor = [UIColor whiteColor];
	}
	else
	{
		if (indexPath.row % 2 == 0)
		{
			cell.backgroundColor = backgroundColorEven;
		}
		else
		{
			cell.backgroundColor = backgroundColorOdd;
		}
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
