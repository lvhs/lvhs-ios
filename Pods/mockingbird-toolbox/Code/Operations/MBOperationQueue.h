//
//  MBOperationQueue.h
//  Mockingbird Toolbox
//
//  Created by Evan Coyne Maloney on 4/7/14.
//  Copyright (c) 2014 Gilt Groupe. All rights reserved.
//

#import "Mockingbird-Toolbox.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBOperationQueue class
/******************************************************************************/

/*!
 A generic `NSOperationQueue` implementation used as the base class for various
 operation queues used within Mockingbird.
 */
@interface MBOperationQueue : NSOperationQueue

/*!
 Initializes the queue.
 
 This implementation sets the queue's `maxConcurrentOperationCount` value to
 `NSOperationQueueDefaultMaxConcurrentOperationCount`.
 
 @return    self
 */
- (id) init;

/*!
 Initializes the queue.

 @param     cnt The initial value of the queue's `maxConcurrentOperationCount`.
 
 @return    self
 */
- (id) initWithMaxConcurrentOperationCount:(NSInteger)cnt;

@end
