//
//  InitialDisplayTableViewController.m
//  Kaviar
//
//  Created by Tapan Srivastava on 5/18/16.
//  Copyright © 2016 Institute of Systems Biology. All rights reserved.
//

#import "InitialDisplayTableViewController.h"
#import "FullDisplayTableViewController.h"
@interface InitialDisplayTableViewController ()

@end

@implementation InitialDisplayTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//for each chr/coordinate entered, 1 row for title. 1 row for comments. As many rows as there are var-freq pairs
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (self.tableCellContainer)
	{
		NSArray* cellTitles = [NSArray arrayWithArray:[self.tableCellContainer objectAtIndex:0]];
		return cellTitles.count;
	}
	else
	{
		return 1;
	}
}

//if there are no comments, don't display cell (by making height 0)
//else if cell's text is too long, make it taller
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (self.tableCellContainer)
	{
		NSArray* cellTitles = [NSArray arrayWithArray:[self.tableCellContainer objectAtIndex:0]];
	
		NSString* thisCellTitle = [cellTitles objectAtIndex:indexPath.row];
	
		if ([thisCellTitle length] > 50)
		{
			return 88.0f;
		}
	}
	return 44.0f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* CellIdentifier = @"cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
	
	}

	if (self.fullJSONResult)
	{
		//no black lines between tableViewCells
		[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
		
		//access cell title and cell colors from tableCellContainer (component is used in prepareForSegue as it is only relevant in the transition to FullDisplayTVC).
		NSArray* cellTitles = [NSArray arrayWithArray:[self.tableCellContainer objectAtIndex:0]];
		NSArray* cellColors = [NSArray arrayWithArray:[self.tableCellContainer objectAtIndex:1]];
		
		//default indentation is 0
		cell.indentationLevel = 0;
		
		NSString* thisCellTitle = [cellTitles objectAtIndex:indexPath.row];
		
		//if the cell is not containing the title of the component, indent it and make it smaller if text is too long.
		if (![thisCellTitle containsString:@"chr"])
		{
			UIFont *normalFont = [UIFont fontWithName:@"HelveticaNeue" size:14];
			cell.textLabel.font = normalFont;
			cell.indentationLevel = 1;
			if (thisCellTitle.length > 50)
			{
				cell.textLabel.numberOfLines = 3;
				cell.textLabel.minimumScaleFactor = 0.7f;
			}
		}
		//if this cell does contain title, bold it and scale if too long
		else
		{
			UIFont *boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
			cell.textLabel.font = boldFont;
			if (thisCellTitle.length > 40)
			{
				cell.textLabel.numberOfLines = 3;
				cell.textLabel.minimumScaleFactor = 0.7f;
			}
		}
		cell.textLabel.text = thisCellTitle;
		
		//set backgroundColor accordingly. Make cell.textlabel's color be clear so only the tableViewCell's color shows
		cell.backgroundColor = [cellColors objectAtIndex:indexPath.row];
		cell.textLabel.backgroundColor = [UIColor clearColor];
	}
	
	//if there is no jsonData, there was an error
	else if (self.tableCellContainer)
	{
		NSArray* cellTitles = [NSArray arrayWithArray:[self.tableCellContainer objectAtIndex:0]];
		NSArray* cellColors = [NSArray arrayWithArray:[self.tableCellContainer objectAtIndex:1]];
		
		//there is only one cell, so have black lines between cells
		[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
		
		//scale down if text is too long
		if ([[cellTitles objectAtIndex:indexPath.row]length] > 40)
		{
			cell.textLabel.numberOfLines = 2;
			cell.textLabel.minimumScaleFactor = 0.8f;
		}
		
		//display error
		UIFont *normalFont = [UIFont fontWithName:@"HelveticaNeue" size:14];
		cell.textLabel.font = normalFont;
		cell.textLabel.text = [cellTitles objectAtIndex:indexPath.row];
		cell.backgroundColor = [cellColors objectAtIndex:indexPath.row];
		cell.textLabel.backgroundColor = [UIColor clearColor];
	}
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


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
// transfers fullJSONResult data to next FullDisplayTableViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

	if ([segue.identifier isEqualToString:@"fullDisplay"]) {
    	
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		NSMutableArray* fullDisplayCellTitles = [NSMutableArray array];
		FullDisplayTableViewController* fdtvc = (FullDisplayTableViewController*) segue.destinationViewController;
		
		//if there was  jsonData retrieved from backend, present data. else only present error message
		if (self.fullJSONResult)
		{
			//each tableCell corresponds to a zero-based integer. That cell will also have a corresponding component, which will be the componentHolder array within self.tableCellContainer at the index of its own indexPath.row
			NSArray* componentHolder = [NSArray arrayWithArray:[self.tableCellContainer objectAtIndex:2]];
			int component = [[componentHolder objectAtIndex:indexPath.row] intValue];
			
			//get data from that component and create an array that stores it (essentially same process as parseJSONObject in ParameterEntry)
			NSDictionary* individualVarianceDictionary = [NSDictionary dictionaryWithDictionary:[self.fullJSONResult objectAtIndex:component]];
		
			NSString* retrievedChr = [individualVarianceDictionary objectForKey:@"chromosome"];
			NSString* retrievedPos = [individualVarianceDictionary objectForKey:@"position"];
			NSString* posCategory = [individualVarianceDictionary objectForKey:@"posCategory"];
			NSString* titleString;
			
			if ([individualVarianceDictionary objectForKey:@"rsids"])
			{
				NSArray* rsID = [individualVarianceDictionary objectForKey:@"rsids"];
			
				titleString = [NSString stringWithFormat:@"%@  %@  %@  %@", rsID[0], retrievedChr, retrievedPos, posCategory];
			}
		
			else
			{
				titleString = [NSString stringWithFormat:@"%@  %@  %@", retrievedChr, retrievedPos, posCategory];
			}
			
			[fullDisplayCellTitles addObject:titleString];
		
			NSString* comments;
			if ([individualVarianceDictionary objectForKey:@"comments"])
			{
				comments = [individualVarianceDictionary objectForKey:@"comments"];
				[fullDisplayCellTitles addObject:comments];
			}
			if ([[individualVarianceDictionary objectForKey:@"varInfo"] count] > 0)
			{
				NSArray* variantArray = [NSArray arrayWithArray:[individualVarianceDictionary objectForKey:@"varInfo"]];
				
				for (int k = 0; k < variantArray.count; k++)
				{
					NSString* variant = [[variantArray objectAtIndex:k] objectForKey:@"variant"];
					NSString* frequency = [[variantArray objectAtIndex:k] objectForKey:@"frequency"];
					NSString* varCategory = [[variantArray objectAtIndex:k] objectForKey:@"varCategory"];
					float frequencyFloat = [frequency floatValue];
					frequencyFloat = frequencyFloat * 100;
					NSString* frequencyDisplay;
				
					if (frequencyFloat - 1 < 0)
					{
						frequencyDisplay = [NSString stringWithFormat:@"%.04f%%", frequencyFloat];
					}
					else if (frequencyFloat - 10 < 0)
					{
						frequencyDisplay = [NSString stringWithFormat:@"%.03f%%", frequencyFloat];
					}
					else
					{
						frequencyDisplay = [NSString stringWithFormat:@"%.02f%%", frequencyFloat];
					}
					NSString* varFreq = [NSString stringWithFormat:@"Variant: %@   Frequency: %@\nCategory: %@", variant, frequencyDisplay, varCategory];
					NSString* sources = [[variantArray objectAtIndex:k] objectForKey:@"sources"];
					
					NSString* displaySources = [NSString stringWithFormat:@"Sources: %@", sources];
				
					[fullDisplayCellTitles addObject:varFreq];
					[fullDisplayCellTitles addObject:displaySources];
				}
			}
			//transfer array
			fdtvc.fullCellTitles = [NSArray arrayWithArray:fullDisplayCellTitles];
		}
		else
		{
			//only transfer error message
			fdtvc.fullCellTitles = [NSArray arrayWithObject:@"Invalid Data Inputted. Try Again."];
		}
 	}
}
@end
