//
//  ParameterEntryViewController.m
//  Kaviar
//
//  Created by Tapan Srivastava on 5/18/16.
//  Copyright © 2016 Institute of Systems Biology. All rights reserved.
//

#import "ParameterEntryViewController.h"
#import "InitialDisplayTableViewController.h"
@interface ParameterEntryViewController ()

@end

@implementation ParameterEntryViewController
{
	NSArray *freezePickerArray, *inputPickerArray, *outputPickerArray, *variantTypesArray, *displayPickerArray; //arrays contianing options for each component of the picker.
}

//loads the view, creates picker, maps color to var/posCategory.
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//Each array holds titles for respective components of pickerView. Arrays loaded up into master array, where the index of displayPickerArray is component, that returns titles of component
	freezePickerArray = [NSArray arrayWithObjects:@"hg18 (NCBI Build 36.1)", @"hg19 (GRCh37)", @"hg38 (GRCh38)", nil];
	
	inputPickerArray = [NSArray arrayWithObjects:@"zero-based", @"one-based", nil];
	
	outputPickerArray = [NSArray arrayWithObjects:@"zero-based", @"one-based", @"Same as input", nil];
	
	variantTypesArray = [NSArray arrayWithObjects:@"All", @"SNV's Only", @"Indels & Subs", nil];

	displayPickerArray = [NSArray arrayWithObjects:freezePickerArray, inputPickerArray, outputPickerArray, variantTypesArray, nil];
	
	//sets data source and delegate to self for each text field and picker
	self.displayPicker.dataSource = self;
	self.displayPicker.delegate = self;
	self.chrNumber.delegate = self;
	self.coordinate.delegate = self;

	//creates colors (same as website but converted to floats from 0-1.0) and then sets colors of top four labels, title label, the help button, and submit button
	UIColor *backgroundColorEven = [UIColor colorWithRed:0 green:0.247 blue:0.447 alpha:0.4f];
	UIColor *backgroundColorOdd = [UIColor colorWithRed:0 green:0.247 blue:0.447 alpha:0.2];
	self.titleLabel.backgroundColor = [UIColor whiteColor];
	self.freezeLabel.backgroundColor = backgroundColorEven;
	self.inputLabel.backgroundColor = backgroundColorOdd;
	self.outputLabel.backgroundColor = backgroundColorEven;
	self.variantTypes.backgroundColor = backgroundColorOdd;
	self.submitLabel.backgroundColor = backgroundColorEven;
	self.helpLabel.backgroundColor = backgroundColorEven;
 	
	//text color for both buttons is white
	[self.submitLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.helpLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	//maps specific category values to colors. used to change color of container view's tableView
	NSArray* keyPosCategoryArray = @[@"represented", @"novel", @"suspicious"];
	NSArray* keyVarCategoryArray = @[@"rare", @"common"];
	
	UIColor *rareColor = [UIColor colorWithRed:0 green:0.525f blue:0.820f alpha:1.0f];	
	UIColor *novelColor = [UIColor colorWithRed:0.13f green:0.67f blue:0.22f alpha:1.0f];
	UIColor *suspiciousColor = [UIColor colorWithRed:0.99f green:0.78f blue:0 alpha:1.0f];
	UIColor *commonColor = [UIColor colorWithRed:0.95f green:0.60f blue:0 alpha:1.0f];
	UIColor *representedColor = [UIColor colorWithRed:0 green:0.247 blue:0.447 alpha:0.2f];

	NSArray* valuePosColorArray = @[representedColor, novelColor, suspiciousColor];
	NSArray* valueVarColorArray = @[rareColor, commonColor];
	
	self.posCategoryToColor = [NSDictionary dictionaryWithObjects:valuePosColorArray forKeys:keyPosCategoryArray];
	
	self.varCategoryToColor = [NSDictionary dictionaryWithObjects:valueVarColorArray forKeys:keyVarCategoryArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//keyboard goes away when return key hit
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
	return YES;
}

//when user touches whitespace keyboard disappears if visible.
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	[[self view]endEditing:YES];
}
#pragma mark - PickerView Setup

//Freeze, input, output, variant type each has one component
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 4;
}

//Access the array of values for each component. Then return the length of that array.
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	NSInteger count = [[displayPickerArray objectAtIndex:component] count];
	return count;
}

- (CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 20.0f;
}

//Initialize pickerLabel if it hasn't been, then based on the row and component access the respective string and it as it's text.
- (UIView*) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
	UILabel* pickerLabel = (UILabel*) view;
	
	if (!pickerLabel)
	{
		pickerLabel = [[UILabel alloc] init];
		
		pickerLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
		
		pickerLabel.textAlignment = NSTextAlignmentCenter;
	}
	
	NSString* data = [[displayPickerArray objectAtIndex:component] objectAtIndex:row];
	
	[pickerLabel setText:data];
	
	UIColor *backgroundColorEven = [UIColor colorWithRed:0 green:0.247 blue:0.447 alpha:0.4f];
	UIColor *backgroundColorOdd = [UIColor colorWithRed:0 green:0.247 blue:0.447 alpha:0.2f];
	
	//check if row is odd or even and set its color accordingly
	if (row % 2 == 0)
	{
		pickerLabel.backgroundColor = backgroundColorEven;
	}
	else
	{
		pickerLabel.backgroundColor = backgroundColorOdd;
	}
		
	return pickerLabel;
}

//simply return the corresponding string to the (component, row) data set.
- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [[displayPickerArray objectAtIndex:component] objectAtIndex:row];
}

#pragma mark - Get Call Methods

//value array contains user-inputted parameters. This method actually performs the get call
-(void) placeRequest:(NSArray*)valueArray
{
	//names of each parameter
	NSArray* keyArray = [NSArray arrayWithObjects:@"chr", @"pos", @"frz", @"onebased", @"onebased_output",@"variant_type", nil];
	
	//base url without any parameter input
	NSString* urlString = @"http://db.systemsbiology.net/kaviar-beta/cgi-pub/Kaviar?";
	
	//cycle through value array. Access value and append it to the base url in the format "(paramname)=(paramValue)&"
	for (int i = 0; i < valueArray.count; i++)
	{
		NSString* value = [valueArray objectAtIndex:i];
		NSString* key = [keyArray objectAtIndex:i];

		//appending url. if adding last param, there is no & at the end
		NSString* appendingString;
		if (i + 1 == valueArray.count)
		{
			appendingString = [NSString stringWithFormat:@"%@=%@", key, value];
		}
		else
		{
			appendingString = [NSString stringWithFormat:@"%@=%@&", key, value];
		}
		
		//final url used to access backend
		urlString = [urlString stringByAppendingString:appendingString];
	}
	
	//create NSMutableURLRequest object with NSURL object. Object communicates with backend
	NSURL* url = [NSURL URLWithString:urlString];
	
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
	
	//data retrieved from backend placed into data object defined in block
	[[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse* response, NSError* error)
	{
		
		//data object transfered to NSData property
		self.jsonData = [NSData dataWithData:data];
		
		if (self.jsonData)
		{
			NSArray* tableCellContainer = [NSArray arrayWithArray:[self parseJSONObject]];

			//this method ensures that the request occurs on the main thread
			dispatch_async(dispatch_get_main_queue(), ^
			{
				InitialDisplayTableViewController* idtvc = self.childViewControllers[0];
				
				idtvc.tableCellContainer = [NSArray arrayWithArray:tableCellContainer];
				idtvc.fullJSONResult = [NSArray arrayWithArray:self.fullJSONResultArray];
				[idtvc.tableView reloadData];
				self.chrNumber.text = @"";
				self.coordinate.text = @"";
			});
		}
	}] resume];
}

//takes JSON object and moves through map to isolate important information
- (NSArray*) parseJSONObject
{
	NSError* error = nil;
	
	//first move json from a data object to a dictionary (map). Important information is the object to the key "sites". That info stored in array
	self.jsonDataDictionary = [NSDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:self.jsonData options:0 error:&error]];
			
	self.fullJSONResultArray = [NSArray arrayWithArray:[self.jsonDataDictionary objectForKey:@"sites"]];
	
	//Each index holds title for one table cell in InitialDisplay
	NSMutableArray* parsedJSONArray = [NSMutableArray array];
	//Each index holds background color for one table cell
	NSMutableArray* parsedJSONColor = [NSMutableArray array];
	//Each index holds coordinate/chromosome for each table cell
	NSMutableArray* componentHolder = [NSMutableArray array];
	//starts at -1 bc when loop begins, the component is at 0. Whenever loop repeats, moves onto next component
	int numComponent = -1;
	
	//loop iterates through JSON object until every returned data is formatted correctly and packaged in the appropriate array
	//these arrays will then be sent and opened by InitialDisplay
	for (int i = 0; i < self.fullJSONResultArray.count; i++)
	{
		numComponent = numComponent + 1;

		//i corresponds to the chr/coordinate pair being dealt with. As i increases, loop iterates through all chr-coordinate pairs inputted that have a variance
		//gets data for that locus
		NSDictionary* individualVarianceDictionary = [NSDictionary dictionaryWithDictionary:[self.fullJSONResultArray objectAtIndex:i]];
		
		//creates title string from chromosome and position
		NSString* retrievedChr = [individualVarianceDictionary objectForKey:@"chromosome"];
		NSString* retrievedPos = [individualVarianceDictionary objectForKey:@"position"];
		NSString* titleString;
		
		//adds RSID if it exists
		if ([individualVarianceDictionary objectForKey:@"rsids"])
		{
			NSArray* rsID = [individualVarianceDictionary objectForKey:@"rsids"];
			
			titleString = [NSString stringWithFormat:@"%@  %@  %@", retrievedChr, retrievedPos, rsID[0]];
		}
		else
		{
			titleString = [NSString stringWithFormat:@"%@  %@", retrievedChr, retrievedPos];

		}
		//gets color to corresponding posCategory for title string
		NSString* posCategory = [individualVarianceDictionary objectForKey:@"posCategory"];
		UIColor* backgroundColor = [self.posCategoryToColor objectForKey:posCategory];
		
		//store title string, color, and component in same index of all 3 arrays. Each will be accessed by table depending on indexPath.
		[parsedJSONArray addObject:titleString];
		[parsedJSONColor addObject:backgroundColor];
		[componentHolder addObject:[NSNumber numberWithInteger:numComponent]];
		
		//add comments and corresponding numComponent and color
		NSString* comments;
		if ([individualVarianceDictionary objectForKey:@"comments"])
		{
			comments = [individualVarianceDictionary objectForKey:@"comments"];
			UIColor *commentColor = [UIColor colorWithRed:0 green:0.247 blue:0.447 alpha:0.4];
			[parsedJSONArray addObject:comments];
			[parsedJSONColor addObject:commentColor];
			[componentHolder addObject:[NSNumber numberWithInteger:numComponent]];
		}
				
		//if a variance exists, add as many strings as there are var-frequency pairs. varCategory determines color of specific var-freq pair
		//frequency given as % to 4 significant figures
		if ([individualVarianceDictionary objectForKey:@"varInfo"])
		{
			NSArray* variantArray = [NSArray arrayWithArray:[individualVarianceDictionary objectForKey:@"varInfo"]];
			
			for (int k = 0; k < variantArray.count; k++)
			{
				NSString* variant = [[variantArray objectAtIndex:k] objectForKey:@"variant"];
				NSString* frequency = [[variantArray objectAtIndex:k] objectForKey:@"frequency"];
				NSString* sources = [[variantArray objectAtIndex:k] objectForKey:@"sources"];
				NSString* varCategory = [[variantArray objectAtIndex:k] objectForKey:@"varCategory"];
				float frequencyFloat = [frequency floatValue];
				frequencyFloat = frequencyFloat * 100;
				NSString* frequencyDisplay;
				NSString* variantOrRef;
				
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
				
				//identify on initial display which variant is the reference
				if ([sources containsString:@"reference"])
				{
					variantOrRef = @"Reference";
				}
				else
				{
					variantOrRef = @"Variant";
				}
				NSString* varFreq = [NSString stringWithFormat:@"%@: %@   Frequency: %@", variantOrRef, variant, frequencyDisplay];
				UIColor* varFreqBackgroundColor = [self.varCategoryToColor objectForKey:varCategory];
				
				[parsedJSONArray addObject:varFreq];
				[parsedJSONColor addObject:varFreqBackgroundColor];
				[componentHolder addObject:[NSNumber numberWithInteger:numComponent]];
			}
		}
	}
	NSArray* containerArray = [NSArray arrayWithObjects:parsedJSONArray, parsedJSONColor, componentHolder, nil];
	return containerArray;
}

//method called when 'submit' button pressed
- (IBAction)submit:(id)sender
{
	//Data, dictionary, and array must be set to nil so they can be allocated if request is sent
	self.jsonData = nil;
	self.jsonDataDictionary = nil;
	self.fullJSONResultArray = nil;
	//will hold string of validated parameter entries
	NSMutableArray* valueArray = [NSMutableArray array];

	//PARAMETER CHECK
	
	//errorLog will hold string describing what the error is if there is any
	NSMutableArray* parameterErrorLog = [NSMutableArray array];
	
	NSString* chr = self.chrNumber.text;
	NSString* pos = self.coordinate.text;
	
	//start as false. once validation is complete, will be set to true and request can be sent
	bool chrIsCorrect = false;
	bool posIsCorrect = false;
	//starts as not blank. if blank will be switched (assumption is most times it won't be blank).
	bool chrIsBlank = false;
	bool posIsBlank = false;
	
	//remove all spaces from strings
	chr = [chr stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	pos = [pos stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	//check if blank
	if (chr.length == 0)
	{
		chrIsBlank = true;
	}
	if (pos.length == 0)
	{
		posIsBlank = true;
	}
	
	//chromosome input check
	//if it's blank, we don't even need to check.
	if (!chrIsBlank)
	{
		//chromosome can be inputted either as number/'x'/'y' or as chr+number
		if ([chr containsString:@"chr"])
		{
			NSSet* acceptedCHRInput = [NSSet setWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"x", @"y", @"X", @"Y",nil];

			NSMutableArray* splitByCHR = [NSMutableArray arrayWithArray:[chr componentsSeparatedByString:@"chr"]];
			
			//remove 'chr' character
			if ([chr hasPrefix:@"chr"])
			{
				[splitByCHR removeObjectAtIndex:0];
			}
			//there should be 1 element. check if this element contains illegal character. if so, =false, else, = true
			if (splitByCHR.count == 1)
			{
				if ([acceptedCHRInput containsObject:[splitByCHR objectAtIndex:0]])
				{
					chrIsCorrect = true;
				}
				else
				{
					chrIsCorrect = false;
					NSString* chrErrorMessage = @"Improper chromosome entered.";
					[parameterErrorLog addObject:chrErrorMessage];
				}
			}
			//more or less than 1 means that either only 'chr' was inputted or more than 1 'chr' was inputted. both of which are improper
			else
			{
				chrIsCorrect = false;
				NSString* chrErrorMessage = @"Chromsome given in improper format";
				[parameterErrorLog addObject:chrErrorMessage];
			}
		}
		//if no 'chr' then just check if string is illegal or not
		else
		{
			NSSet* acceptedCHRInput = [NSSet setWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"x", @"y", @"X", @"Y",nil];

			if ([acceptedCHRInput containsObject:chr])
			{
				chrIsCorrect = true;
			}
			else
			{
				chrIsCorrect = false;
				NSString* chrErrorMessage = @"Chromsome given in improper format";
				[parameterErrorLog addObject:chrErrorMessage];
			}
		}
	}
	//just print this error message
	else
	{
		NSString* chrBlankMessage = @"No chromosome entered.";
		[parameterErrorLog addObject:chrBlankMessage];
	}
	
	//coordinate input check
	//if either the position is blank or the chromsome is incorrect, don't even bother going through the check. only check if chromsome is valid and something inputted for coordinate
	if (!posIsBlank)
	{
		if (chrIsCorrect)
		{
			//coordinates can only contain digits, dashes, and commas. first check that no illegal characters exist
			NSCharacterSet* positionCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789-,"]invertedSet];
			
			if ([pos rangeOfCharacterFromSet:positionCharacterSet].location != NSNotFound)
			{
				posIsCorrect = false;
				NSString* positionErrorMessage = @"Coordinates contain illegal characters. Use only digits, commas, and dashes";
				[parameterErrorLog addObject:positionErrorMessage];
			}
			else
			{
				//make sure coordinates begin with a number
				if ([pos hasPrefix:@","] || [pos hasSuffix:@","] || [pos hasPrefix:@"-"] || [pos hasSuffix:@"-"])
				{
					posIsCorrect = false;
					NSString* positionErrorMessage = @"Coordinates given in improper format.";
					[parameterErrorLog addObject:positionErrorMessage];
				}
				//make sure coordinates do not begin with zero
				else if ([pos hasPrefix:@"0"])
				{
					posIsCorrect = false;
					NSString* positionErrorMessage = @"Coordinates cannot begin with 0";
					[parameterErrorLog addObject:positionErrorMessage];
				}
				//remove any duplicate dashes or commas (not numbers). If range inputted, check to make sure that the range is valid
				else
				{
					[self removeDuplicates:pos];
					//divide up pos into components (each component is separated by comma)
					NSArray* posDividedByComma = [NSArray arrayWithArray:[pos componentsSeparatedByString:@","]];
					
					//iterate through each component and check 1) if range exists and 2) if range is valid
					for (NSString* posComponent in posDividedByComma)
					{
						posIsCorrect = [self dashCheck:posComponent withErrorLog:parameterErrorLog];
					}
				}
			}
		}
	}
	else
	{
		if (chrIsCorrect)
		{
			NSString* posBlankMessage = @"No coordinates entered.";
			[parameterErrorLog addObject:posBlankMessage];
		}
	}
	
	//if both valid, send request
	if (chrIsCorrect && posIsCorrect)
	{
		//both chr and pos are valid, so add to value
		[valueArray addObject:chr];
		[valueArray addObject:pos];
		
		//add each selection of pickerView
		//access number of components, use as bound of for-loop
		NSUInteger numComponents = [[self.displayPicker dataSource] numberOfComponentsInPickerView:self.displayPicker];
		
		//cycles through picker. Based on component, performs unique method to access data
		for (NSUInteger i = 0; i < numComponents; i++) {
			NSInteger selectedRowInt = [self.displayPicker selectedRowInComponent:i];
		
			if (i == 0)
			{
				NSString* value = [[self.displayPicker delegate] pickerView:self.displayPicker titleForRow:selectedRowInt forComponent:i];
			
				NSArray *parsedValue = [NSArray arrayWithArray:[value componentsSeparatedByString:@" "]];
			
				[valueArray addObject:[parsedValue objectAtIndex:0]];

			}
			else if (i == 3)
			{
				NSDictionary* variantTypesDictionary = [NSDictionary dictionaryWithObjects:@[@"all",@"snvs", @"ranged"] forKeys:@[@"All", @"SNV's Only", @"Indels & Subs"]];
				
				NSString* title = [[self.displayPicker delegate] pickerView:self.displayPicker titleForRow:selectedRowInt forComponent:i];
				
				NSString* value = [variantTypesDictionary objectForKey:title];
				
				[valueArray addObject:value];
			}
			else
			{
				NSString *value = [NSString stringWithFormat:@"%li", (long)selectedRowInt];
				[valueArray addObject:value];
			}
		}
		[self placeRequest:valueArray];
	}
	//otherwise send error message to containerView and reload table
	else
	{
		NSArray* paramErrorMessage = [NSArray arrayWithArray:parameterErrorLog];
		NSArray* paramErrorColor = [NSArray arrayWithObject:[UIColor whiteColor]];
		NSArray* paramErrorComponent = [NSArray arrayWithObject:[NSNumber numberWithInt:0]];
		NSArray* containerArray = [NSArray arrayWithObjects:paramErrorMessage, paramErrorColor, paramErrorComponent, nil];
		
		dispatch_async(dispatch_get_main_queue(), ^
		{
			InitialDisplayTableViewController* idtvc = self.childViewControllers[0];
			idtvc.fullJSONResult = nil;
			idtvc.tableCellContainer = [NSArray arrayWithArray:containerArray];
				
			[idtvc.tableView reloadData];
			//make textLabel's blank
			self.chrNumber.text = @"";
			self.coordinate.text = @"";

		});
	}
}

#pragma mark - Parameter Check
//This method is not a check. it is removing duplicate characters for the user
- (void) removeDuplicates: (NSString*) posString
{
	NSMutableString* removeDuplicatePos = [NSMutableString string];
	NSMutableSet* removeDash = [NSMutableSet setWithCapacity:1];
	NSMutableSet* removeComma = [NSMutableSet setWithCapacity:1];
	
	//Aim is to remove duplicate dashes and commas but not duplicate numbers
	//If dash is seen for the first time by the enumerateSubstringInRange method, it is added to the empty mutableSet (removeDash) and then added to the empty mutable string.
	//If dash is the next character, it is already in removeDash, so it is not added to mutable string
	//If dash is not the next character, removeDash is emptied.
	//Same process applies to commas. MutableSet only contains an object if the previous substring contained a dash or comma.
	
	
	//each substring represents 1 character in posString
	[posString enumerateSubstringsInRange:NSMakeRange(0, posString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString*_Nonnull substring, NSRange substringRange, NSRange enclosingRange, BOOL* _Nonnull stop){
		
		if ([substring containsString:@"-"])
		{
			if ([removeComma count])
			{
				[removeComma removeAllObjects];
			}
				
			if (![removeDash containsObject:substring])
			{
				[removeDash addObject:substring];
				[removeDuplicatePos appendString:substring];
			}
		}
		else if ([substring containsString:@","])
		{
			if ([removeDash count])
			{
				[removeDash removeAllObjects];
			}

			if (![removeComma containsObject:substring])
			{
				[removeComma addObject:substring];
				[removeDuplicatePos appendString:substring];
			}
		}
		else
		{
			if ([removeDash count])
			{
				[removeDash removeAllObjects];
			}
			if ([removeComma count])
			{
				[removeComma removeAllObjects];
			}
					
			[removeDuplicatePos appendString:substring];
		}
	}];
	//then set paramater string to new string without duplicates.
	posString = removeDuplicatePos;
}

//checks if the range is valid and adds a message to error log if it isn't. Returns false if range is invalid
- (BOOL) dashCheck: (NSString*) posString withErrorLog: (NSMutableArray*)parameterErrorLog
{
	//must be numbers on either side of the dash
	if ([posString hasPrefix:@"-"] || [posString hasSuffix:@"-"])
	{
		NSString* positionErrorMessage = @"Coordinates given in improper format.";
		[parameterErrorLog addObject:positionErrorMessage];

		return false;
	}
	
	//makes sure that only one dash exists in one inputted range
	int dashCounter = 0;
					
	for (int i = 0; i < posString.length; i++)
	{
		unichar findDash = [posString characterAtIndex:i];
						
		if (findDash == '-')
		{
			dashCounter++;
		}
	}
	
	//if more than one dash, it's improper
	if (dashCounter > 1)
	{
		NSString* positionErrorMessage = @"Coordinates given in improper format.";
		[parameterErrorLog addObject:positionErrorMessage];
		
		return false;
	}
	//if there's no dash, the component string does not contain a range, so as long as string only contains numbers it is valid
	else if (dashCounter == 0)
	{
		if ([posString rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet]invertedSet]].location == NSNotFound)
		{
			return true;
		}
		else
		{
			NSString* positionErrorMessage = @"Coordinates given in improper format.";
			[parameterErrorLog addObject:positionErrorMessage];
			
			return false;
		}
	}
	//if there is 1, a validly formatted range exists
	else
	{
		//get values for each number in range
		NSArray* posComponentRange = [posString componentsSeparatedByString:@"-"];
		long long value2 = [[posComponentRange objectAtIndex:1] longLongValue];
		long long value1 = [[posComponentRange objectAtIndex:0] longLongValue];
		
		
		//make sure that 2nd value is greater than 1st
		if (value2 > value1)
		{
			//make sure range does not exceed 50000 (backend returns an error)
			if (value2-value1 > 50000)
			{
				NSString* positionErrorMessage = @"Query range greater than limit 50000";
				[parameterErrorLog addObject:positionErrorMessage];
			
				return false;
			}

			return true;
		}
		else
		{
			NSString* positionErrorMessage = @"Improper coordinate range given.";
			[parameterErrorLog addObject:positionErrorMessage];
				
			return false;
		}
	}
	return 0;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
