//
//  ParameterEntryViewController.h
//  Kaviar
//
//  Created by Tapan Srivastava on 5/18/16.
//  Copyright © 2016 Institute of Systems Biology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParameterEntryViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) NSData* jsonData;
@property (strong, nonatomic) NSDictionary* jsonDataDictionary;
@property (strong, nonatomic) NSArray* fullJSONResultArray;
@property (strong, nonatomic) NSDictionary* posCategoryToColor;
@property (strong, nonatomic) NSDictionary* varCategoryToColor;

//Methods to place the request for JSON data and then to parse object into dictionary/array
- (void) placeRequest:(NSArray*)valueArray;
- (NSArray*) parseJSONObject;

//Sub-methods in algorithm to determine if input values are valid
- (void) removeDuplicates: (NSString*) posString;
- (BOOL) dashCheck: (NSString*) posString withErrorLog: (NSMutableArray*)parameterErrorLog;

//Outlets and buttons linked to UI elements whose contents are accessed programmatically via these properties/method
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIPickerView *displayPicker;
@property (weak, nonatomic) IBOutlet UITextField *chrNumber;
@property (weak, nonatomic) IBOutlet UITextField *coordinate;
@property (strong, nonatomic) IBOutlet UILabel *freezeLabel;
@property (strong, nonatomic) IBOutlet UILabel *inputLabel;
@property (strong, nonatomic) IBOutlet UILabel *outputLabel;
@property (strong, nonatomic) IBOutlet UILabel *variantTypes;
@property (strong, nonatomic) IBOutlet UIButton *submitLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)submit:(id)sender;

@end
