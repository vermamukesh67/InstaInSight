//
//  HungamaMisicInApp.m
//  HungamaMusic
//
//  Created by Mukesh Verma on 15/07/16.
//  Copyright © 2016 Hungama.com. All rights reserved.
//

#import "HungamaMisicInApp.h"
#import "NSData+Base64.h"



NSString *const HungamaMusicProductPurchasedNotification = @"ProductPurchasedNotification";

static HungamaMisicInApp *sharedManager = nil;

@implementation HungamaMisicInApp

+ (HungamaMisicInApp *)sharedHungamaMisicInAppInstance
{
    if (sharedManager) {
        return sharedManager;
    }
    
    static dispatch_once_t t = 0;
    dispatch_once(&t, ^{
        sharedManager = [[HungamaMisicInApp alloc] init];
        
    });
    
    return sharedManager;
}

- (void)SetProductIdentifiers:(NSSet *)productIdentifiers {
    
    if (productIdentifiers) {
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            } else {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
    }
    
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    self = [super init];
    if (self) {
        
        if (productIdentifiers) {
            // Store product identifiers
            _productIdentifiers = productIdentifiers;
            
            // Check for previously purchased products
            _purchasedProductIdentifiers = [NSMutableSet set];
            for (NSString * productIdentifier in _productIdentifiers) {
                BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
                if (productPurchased) {
                    [_purchasedProductIdentifiers addObject:productIdentifier];
                    NSLog(@"Previously purchased: %@", productIdentifier);
                } else {
                    NSLog(@"Not purchased: %@", productIdentifier);
                }
            }
        }
       
        
    }
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    return self;
    
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    
    AppDelegate *appDelegate=APP_DELEGATE;
    [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    // 1
    _completionHandler = [completionHandler copy];
    
    // 2
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
    
}

- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}


#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    if (skProducts.count==0) {
        AppDelegate *appDelegate=APP_DELEGATE;
        [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
    }
    _completionHandler(YES, skProducts);
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    AppDelegate *appDelegate=APP_DELEGATE;
    [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
    
    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    
}

#pragma mark SKPaymentTransactionOBserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        
        if (self.isTransactionFailureHandling) {
            
            switch (transaction.transactionState)
            {
                case SKPaymentTransactionStatePurchased:
                    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                    
                    break;
                    
                case SKPaymentTransactionStateFailed:
                    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                    
                    break;
                    
                case SKPaymentTransactionStateRestored:
                    
                    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                    
                default:
                    
                    break;
                    
            }
        }
        
        else
        {
            switch (transaction.transactionState)
            {
                case SKPaymentTransactionStatePurchased:
                    [self completeTransaction:transaction];
                    break;
                    
                case SKPaymentTransactionStateFailed:
                    [self failedTransaction:transaction];
                    break;
                    
                case SKPaymentTransactionStateRestored:
                    [self restoreTransaction:transaction];
                    
                default:
                    
                    break;
                    
            }
            
        }
        
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"completeTransaction...");
    // Validate recipt here
    if (isApiCalling) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:kIsProductPurchased];
    [[NSUserDefaults standardUserDefaults] synchronize];
    AppDelegate *appDelegate=APP_DELEGATE;
    [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
    [HelperMethod ShowAlertWithMessage:@"Purchase successful" InViewController:appDelegate.window.rootViewController];
    [self provideContentForProductIdentifier:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");
    // Validate recipt here
    if (isApiCalling) {
        return;
    }
    isSubscriptionAlreadyPurchased=TRUE;
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:kIsProductPurchased];
    [[NSUserDefaults standardUserDefaults] synchronize];
    AppDelegate *appDelegate=APP_DELEGATE;
    [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
    [HelperMethod ShowAlertWithMessage:@"Restore successful" InViewController:appDelegate.window.rootViewController];
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    if (!isSubscriptionAlreadyPurchased) {
        AppDelegate *appDelegate=APP_DELEGATE;
        appDelegate.isProductISBeingPurchased=FALSE;
        [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
        __block UINavigationController *navVC=(UINavigationController *)appDelegate.window.rootViewController;
        [HelperMethod ShowAlertWithMessage:@"You have not purchased before anytime" InViewController:navVC];
    }
   
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    AppDelegate *appDelegate=APP_DELEGATE;
    appDelegate.isProductISBeingPurchased=FALSE;
    [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"Transaction error: %@", error.localizedDescription);
    AppDelegate *appDelegate=APP_DELEGATE;
    appDelegate.isProductISBeingPurchased=FALSE;
    [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
}

- (void)provideContentForProductIdentifier:(SKPaymentTransaction *)transaction {
    AppDelegate *appDelegate=APP_DELEGATE;
    appDelegate.isProductISBeingPurchased=FALSE;
    [[NSNotificationCenter defaultCenter] postNotificationName:HungamaMusicProductPurchasedNotification object:transaction.payment.productIdentifier userInfo:nil];
    [[NSUserDefaults standardUserDefaults] setObject:transaction forKey:transaction.payment.productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)buyProduct:(SKProduct *)product {
    
    NSLog(@"Buying %@...", product.productIdentifier);
    strPurchaseType=@"subscription";
    AppDelegate *appDelegate=APP_DELEGATE;
    appDelegate.isProductISBeingPurchased=TRUE;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}


- (void)restoreCompletedTransactions {
    strPurchaseType=@"restore";
    isSubscriptionAlreadyPurchased=FALSE;
    AppDelegate *appDelegate=APP_DELEGATE;
    appDelegate.isProductISBeingPurchased=TRUE;
    [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (NSString *)encodeBase64:(const uint8_t *)input length:(NSInteger)length
{
    NSData * data = [NSData dataWithBytes:input length:length];
    return [data base64EncodedString];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

@end
