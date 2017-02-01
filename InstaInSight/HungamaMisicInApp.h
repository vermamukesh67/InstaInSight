//
//  HungamaMisicInApp.h
//  HungamaMusic
//
//  Created by Mukesh Verma on 15/07/16.
//  Copyright © 2016 Hungama.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

/*!
 * @brief Delegate Optional Method to handle the case when product is purchased and open user list for slient user try to purchase with already existing itunes id
 */

@protocol HungamaPurchaseDelegate <NSObject>

@optional

/*!
 * @discussion Delegate Method to open user list for slient user try to purchase with already existing itunes id
 * @param arrUsers array of email ids and mobile number
 */

-(void)OpenUserList:(NSArray *)arrUsers;

/*!
 * @brief Delegate Method to handle the case when product is purchased
 */
- (void)productPurchased;

@end

/// NSNotification observer constant key

UIKIT_EXTERN NSString *const HungamaMusicProductPurchasedNotification;

/*!
 * @brief When products is loaded from store sucessfully or error occured then execute RequestProductsCompletionHandler
 * @param success true if products loaded and false for error occured
 * @param products array of products
 * @code [HungamaMisicInApp RequestProductsCompletionHandler:^(BOOL success, NSArray * products){
        if(success)
                NSLog(@"products = %@", products);
        else
 
 }];
 */

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

/*!
 * @brief :  A Class to handle all the activites related to in app purchase for loading products from itunes store, product purchase and restore purchase
 */

@interface HungamaMisicInApp : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    SKProductsRequest * _productsRequest;
    RequestProductsCompletionHandler _completionHandler;
    NSSet * _productIdentifiers;
    NSMutableSet * _purchasedProductIdentifiers;
    BOOL isApiCalling,isSubscriptionAlreadyPurchased;
    SKPaymentTransaction *originalTransaction;
    NSString *strPurchaseType;
}

/*!
 * @brief :  delegate object
 */
@property(nonatomic,strong) id<HungamaPurchaseDelegate> delegate;

/*!
 * @brief :  Bool value used just for checking transaction done sucessfully or not
 */
@property(nonatomic,assign) BOOL isTransactionFailureHandling;

/*!
 * @discussion A Method to request products from itunes store
 * @param completionHandler An Block to handle the suscess and error case
 */
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

/*!
 * @discussion A Method buy perticular product from itunes store
 * @param product product to buy
 */
- (void)buyProduct:(SKProduct *)product;

/*!
 * @discussion A Method to check product is already bought before from NSUserDefault
 * @param productIdentifier id if product
 * @return true if yes and false for no
 */
- (BOOL)productPurchased:(NSString *)productIdentifier;

/*!
 * @brief A Method to restore previous purchased subscription from itunes store
 */
- (void)restoreCompletedTransactions;

/*!
 * @discussion A Method to set productIdentifiers
 * @param productIdentifiers NSSet of multiple product ids
 */
- (void)SetProductIdentifiers:(NSSet *)productIdentifiers;

/*!
 * @discussion A Single ton class method to init the object that can be used to through out the project
 * @return object of class
 */
+ (HungamaMisicInApp *)sharedHungamaMisicInAppInstance;
@end
