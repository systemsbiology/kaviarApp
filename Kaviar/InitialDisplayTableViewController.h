//
//  InitialDisplayTableViewController.h
//  Kaviar
//
//  Created by Tapan Srivastava on 5/18/16.
//  Copyright © 2016 Institute of Systems Biology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InitialDisplayTableViewController : UITableViewController

//JSON array parsed in parseJSONObject in ParamaterEntryVC
@property (nonatomic, strong) NSArray* fullJSONResult;

//contains 3 arrays, each with as many indices as there are table cells in table
//1: contains titles for each cell. 2: contains background color. 3: which overall coordinate/chr pair it belongs to
@property (nonatomic, strong) NSArray* tableCellContainer;

@end
