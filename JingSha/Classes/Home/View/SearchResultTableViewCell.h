//
//  SearchResultTableViewCell.h
//  
//
//  Created by bocweb on 15/11/10.
//
//

#import <UIKit/UIKit.h>
#import "SearchModel.h"
@interface SearchResultTableViewCell : UITableViewCell

- (void)configureDataWithModel:(SearchModel *)model
                   inputString:(NSString *)string;
@end
