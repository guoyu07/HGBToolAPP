//
//  HGBMailListTool.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/31.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBMailListTool.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>

#pragma mark 系统版本

#ifndef HVersion
#define HVersion [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号
#endif

#ifndef KiOS6Later
#define KiOS6Later (HVersion >= 6)
#endif

#ifndef KiOS7Later
#define KiOS7Later (HVersion >= 7)
#endif

#ifndef KiOS8Later
#define KiOS8Later (HVersion >= 8)
#endif

#ifndef KiOS9Later
#define KiOS9Later (HVersion >= 9)
#endif

#ifndef KiOS10Later
#define KiOS10Later (HVersion >= 10)
#endif

#ifndef KiOS11Later
#define KiOS11Later (HVersion >= 11)
#endif

#define ReslutCode @"reslutCode"
#define ReslutMessage @"reslutMessage"
#define ReslutError @"reslutError"


#ifdef KiOS9Later
@interface HGBMailListTool()<CNContactPickerDelegate>
#else
@interface HGBMailListTool()<ABPeoplePickerNavigationControllerDelegate>
#endif

/**
 代理
 */
@property(strong,nonatomic)id<HGBMailListToolDelegate>delegate;
/**
 代理
 */
@property(strong,nonatomic)UIViewController *parent;
/**
 是否打开联系人详情进行选择联系方式
 */
@property(assign,nonatomic)BOOL isCanOpenMailDetails;
@end
@implementation HGBMailListTool
static HGBMailListTool* instance=nil;
#pragma mark init
/**
 单例

 @return 实例
 */
+ (instancetype)shareInstance
{
    if (instance==nil) {
        instance=[[HGBMailListTool alloc]init];
    }
    return instance;
}
/**
 单例

 @param parent 父控制器
 @param delegate 代理
 */
+(void)shareInstanceMailListBookInParent:(UIViewController *)parent andWithDelegate:(id<HGBMailListToolDelegate>)delegate{
    [HGBMailListTool shareInstance];
    instance.parent=parent;
    instance.delegate=delegate;
    
}
#pragma mark 功能
/**
 是否打开联系人详情进行选择联系方式

 @param isCanOpenMailDetails 是否
 */
+(void)setIsCanOpenMailDetails:(BOOL)isCanOpenMailDetails{
    [HGBMailListTool shareInstance];
    instance.isCanOpenMailDetails=isCanOpenMailDetails;
}
/**
 获取权限问题

 @return 权限结果
 */
+(HGBMailListAuthStatus)getAuthStatus{
#ifdef KiOS9Later
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];

    if (status == CNAuthorizationStatusNotDetermined) {
        return HGBMailListAuthStatusNotDetermined;
    }else if (status == CNAuthorizationStatusAuthorized){
        return HGBMailListAuthStatusAuthorized;
    }else if (status == CNAuthorizationStatusDenied){
        return HGBMailListAuthStatusDenied;
    }else{
        return HGBMailListAuthStatusRestricted;
    }
#else
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusNotDetermined) {
        NSLog(@"还没问呢");
        return HGBMailListAuthStatusDenied;
    }else if (status == kABAuthorizationStatusAuthorized){
        NSLog(@"已经授权");
        return HGBMailListAuthStatusAuthorized;
    }else if (status == kABAuthorizationStatusRestricted){
        NSLog(@"没有授权");
        return HGBMailListAuthStatusRestricted;
    }else{
        NSLog(@"没有授权");
        return HGBMailListAuthStatusNotDetermined;
    }
#endif


}
/**
 初始化通讯录

 @param completeBlock 结果
 */
+(void)initMailListWithCompleteBlock:(void(^)(BOOL status,NSDictionary *info))completeBlock{
#ifdef KiOS9Later
    [[[CNContactStore alloc]init] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if(granted){
            completeBlock(YES,@{});

        }else{
            if(error){
                completeBlock(NO,@{ReslutCode:@(error.code),ReslutMessage:error.localizedDescription,ReslutError:error});
            }else{
                completeBlock(NO,@{ReslutCode:@(0),ReslutMessage:@"未知错误"});
            }
        }
    }];
#else
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
        if(granted){
            completeBlock(YES,@{});
        }else{
            if(error){
                completeBlock(NO,@{ReslutCode:@(error.code),ReslutMessage:error.localizedDescription,ReslutError:error});
            }else{
                completeBlock(NO,@{ReslutCode:@(1),ReslutMessage:@"未知错误"});
            }
        }
    });
#endif
}



/**
 打开通讯录选择联系人

 @param parent 父控制器
 @param delegate 代理
 */
+(void)openMailListBookInParent:(UIViewController *)parent andWithDelegate:(id<HGBMailListToolDelegate>)delegate{
    [HGBMailListTool shareInstanceMailListBookInParent:parent andWithDelegate:delegate];
    if(instance.parent==nil){
        instance.parent=[HGBMailListTool currentViewController];
    }
    HGBMailListAuthStatus status=[HGBMailListTool getAuthStatus];
    if(status==HGBMailListAuthStatusNotDetermined){
        [HGBMailListTool initMailListWithCompleteBlock:^(BOOL status, NSDictionary *info) {
            if(status==YES){
                [HGBMailListTool openMailListBook];

            }else{
                if(instance.delegate&&[instance.delegate respondsToSelector:@selector(mailList:didFailedWithError:)]){
                    [instance.delegate mailList:instance didFailedWithError:info];
                }

            }
        }];

    }else if(status==HGBMailListAuthStatusAuthorized){
         [HGBMailListTool openMailListBook];
    }else{
        if(instance.delegate&&[instance.delegate respondsToSelector:@selector(mailList:didFailedWithError:)]){
            [instance.delegate mailList:instance didFailedWithError:@{ReslutCode:@(0),ReslutMessage:@"权限足"}];
        }
    }


}
/**
 打开通讯簿
 */
+(void)openMailListBook{
#ifdef KiOS9Later
    CNContactPickerViewController *contactVc = [[CNContactPickerViewController alloc] init];
    //    这行代码false就是可以点进详通讯录情页，true就是点击列表页就返回
    if(instance.isCanOpenMailDetails){
        contactVc.predicateForSelectionOfContact = [NSPredicate predicateWithValue:false];
    }else{
        contactVc.predicateForSelectionOfContact = [NSPredicate predicateWithValue:true];
    }
    contactVc.delegate = instance;
    [instance.parent presentViewController:contactVc animated:YES completion:nil];
#else
    ABPeoplePickerNavigationController *mailList = [[ABPeoplePickerNavigationController alloc] init];
    mailList.peoplePickerDelegate = instance;
    [instance.parent presentViewController:mailList animated:YES completion:nil];
#endif
}
/**
 获取全部联系人

 @param delegate 代理
 */
+(void)getMailListWithDelegate:(id<HGBMailListToolDelegate>)delegate{
    [HGBMailListTool shareInstance];
    instance.delegate=delegate;
    HGBMailListAuthStatus status=[HGBMailListTool getAuthStatus];
    if(status==HGBMailListAuthStatusNotDetermined){
        [HGBMailListTool initMailListWithCompleteBlock:^(BOOL status, NSDictionary *info) {
            if(status==YES){
                NSArray *mailList=[HGBMailListTool getPersonInfoArray];
                if(instance.delegate&&[instance.delegate respondsToSelector:@selector(mailList:didSucessedWithMailArray:)]){
                    [instance.delegate mailList:instance didSucessedWithMailArray:mailList];
                }
            }else{
                if(instance.delegate&&[instance.delegate respondsToSelector:@selector(mailList:didFailedWithError:)]){
                    [instance.delegate mailList:instance didFailedWithError:info];
                }

            }
        }];

    }else if(status==HGBMailListAuthStatusAuthorized){
        NSArray *mailList=[HGBMailListTool getPersonInfoArray];
        if(instance.delegate&&[instance.delegate respondsToSelector:@selector(mailList:didSucessedWithMailArray:)]){
            [instance.delegate mailList:instance didSucessedWithMailArray:mailList];
        }
    }else{
        if(instance.delegate&&[instance.delegate respondsToSelector:@selector(mailList:didFailedWithError:)]){
            [instance.delegate mailList:instance didFailedWithError:@{ReslutCode:@(0),ReslutMessage:@"权限足"}];
        }
    }

}

/**
 获取通讯录列表

 @return 通讯录列表
 */
+ (NSArray *)getPersonInfoArray
{
#ifdef KiOS9Later
    NSMutableArray *personArray = [NSMutableArray array];
    CNContactStore *contactStore = [[CNContactStore alloc] init];

    NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];

    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];

    [contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        HGBMailModel *personEntity = [HGBMailListTool transeContactToModel:contact];
        [personArray addObject:personEntity];
    }];
    return personArray;
#else
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef peopleArray = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex peopleCount = CFArrayGetCount(peopleArray);

    NSMutableArray *personArray = [NSMutableArray array];
    for (int i = 0; i < peopleCount; i++) {

         ABRecordRef person = CFArrayGetValueAtIndex(peopleArray, i);
        HGBMailModel *personEntity =[HGBMailListTool transeABRecordToModel:person];
        [personArray addObject:personEntity];

    }
    CFRelease(addressBook);
    CFRelease(peopleArray);
    return personArray;
#endif

}

/**
 创建联系人

 @param name 联系人姓名
 @param phone 手机号
 @param delegate 代理
 */
+(void)creatItemWithName:(NSString *)name phone:(NSString *)phone andWithDelegate:(id<HGBMailListToolDelegate>)delegate
{
    [HGBMailListTool shareInstance];
    instance.delegate=delegate;
        HGBMailListAuthStatus status=[HGBMailListTool getAuthStatus];
    if(status==HGBMailListAuthStatusNotDetermined){
        [HGBMailListTool initMailListWithCompleteBlock:^(BOOL status, NSDictionary *info) {
            if(status==YES){
                BOOL flag=[HGBMailListTool creatPeopleWithName:name phone:phone];
                if(flag){
                    if(instance.delegate&&[instance.delegate respondsToSelector:@selector(mailListDidCreateItemSucessed:)]){
                        [instance.delegate mailListDidCreateItemSucessed:instance];
                    }
                }else{
                    if(instance.delegate&&[instance.delegate respondsToSelector:@selector(mailList:didFailedWithError:)]){
                        [instance.delegate mailList:instance didFailedWithError:@{ReslutCode:@(2),ReslutMessage:@"创建联系人失败"}];
                    }
                }
            }else{
                if(instance.delegate&&[instance.delegate respondsToSelector:@selector(mailList:didFailedWithError:)]){
                    [instance.delegate mailList:instance didFailedWithError:info];
                }

            }
        }];

    }else if(status==HGBMailListAuthStatusAuthorized){
        BOOL flag=[HGBMailListTool creatPeopleWithName:name phone:phone];
        if(flag){
            if(instance.delegate&&[instance.delegate respondsToSelector:@selector(mailListDidCreateItemSucessed:)]){
                [instance.delegate mailListDidCreateItemSucessed:instance];
            }
        }else{
            if(instance.delegate&&[instance.delegate respondsToSelector:@selector(mailList:didFailedWithError:)]){
                [instance.delegate mailList:instance didFailedWithError:@{ReslutCode:@(2),ReslutMessage:@"创建联系人失败"}];
            }
        }
    }else{
        if(instance.delegate&&[instance.delegate respondsToSelector:@selector(mailList:didFailedWithError:)]){
            [instance.delegate mailList:instance didFailedWithError:@{ReslutCode:@(0),ReslutMessage:@"权限足"}];
        }
    }



}
/**
 创建联系人

 @param name 联系人姓名
 @param phone 手机号
 */
+(BOOL)creatPeopleWithName:(NSString *)name phone:(NSString *)phone{
    if(name==nil||phone==nil||(name.length < 1)||(phone.length < 1)){
        return NO;
    }

#ifdef KiOS9Later
    // 创建对象
    // 这个里面可以添加多个电话，email，地址等等。 感觉使用率不高，只提供了最常用的属性：姓名+电话，需要时可以自行扩展。
    CNMutableContact * contact = [[CNMutableContact alloc]init];
    contact.givenName = name?:@"defaultname";
    CNLabeledValue *phoneNumber = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile value:[CNPhoneNumber phoneNumberWithStringValue:phone?:@"10086"]];
    contact.phoneNumbers = @[phoneNumber];

    // 把对象加到请求中
    CNSaveRequest * saveRequest = [[CNSaveRequest alloc]init];
    [saveRequest addContact:contact toContainerWithIdentifier:nil];

    // 执行请求
    CNContactStore * store = [[CNContactStore alloc]init];
    [store executeSaveRequest:saveRequest error:nil];
    return YES;

#else


    CFErrorRef error = NULL;

    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    ABRecordRef newRecord = ABPersonCreate();
    ABRecordSetValue(newRecord, kABPersonFirstNameProperty, (__bridge CFTypeRef)name, &error);

    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)name, kABPersonPhoneMobileLabel, NULL);

    ABRecordSetValue(newRecord, kABPersonPhoneProperty, multi, &error);
    CFRelease(multi);

    ABAddressBookAddRecord(addressBook, newRecord, &error);

    ABAddressBookSave(addressBook, &error);
    CFRelease(newRecord);
    CFRelease(addressBook);
    return YES;
#endif
}
#pragma mark  数据转换
/**
 将ABRecord转化为模型

 @param person ABRecord
 @return model 模型
 */
+(HGBMailModel *)transeABRecordToModel:(ABRecordRef )person{
     HGBMailModel *personEntity = [HGBMailModel new];
    NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    personEntity.lastname = lastName;
    personEntity.firstname = firstName;

    NSMutableString *fullname = [[NSString stringWithFormat:@"%@%@",lastName,firstName] mutableCopy];
    [fullname replaceOccurrencesOfString:@"(null)" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, fullname.length)];
    personEntity.fullname = fullname;

    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex phoneCount = ABMultiValueGetCount(phones);

     NSMutableArray *phoneNums=[NSMutableArray array];
    NSString *fullPhoneStr = [NSString string];
    for (int i = 0; i < phoneCount; i++) {
        NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
        if (phoneValue.length > 0) {
            fullPhoneStr = [fullPhoneStr stringByAppendingString:phoneValue];
            fullPhoneStr = [fullPhoneStr stringByAppendingString:@","];
            [phoneNums addObject:phoneValue];
        }

    }
    if (fullPhoneStr.length > 1) {
        personEntity.phoneNumber = [fullPhoneStr substringToIndex:fullPhoneStr.length - 1];
    }
    CFRelease(phones);
    return personEntity;
}
/**
 将contact转化为模型

 @param contact contact
 @return model
 */
+(HGBMailModel *)transeContactToModel:(CNContact *)contact{
    HGBMailModel *personEntity = [HGBMailModel new];
    NSString *lastname = contact.familyName;
    NSString *firstname = contact.givenName;
    personEntity.lastname = lastname;
    personEntity.firstname = firstname;

    NSMutableString *fullname = [[NSString stringWithFormat:@"%@%@",lastname,firstname] mutableCopy];
    [fullname replaceOccurrencesOfString:@"(null)" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, fullname.length)];
    personEntity.fullname = fullname;

    NSArray *phoneNums = contact.phoneNumbers;
    NSMutableArray *phones=[NSMutableArray array];

    NSString *fullPhoneStr = [NSString string];
    for (CNLabeledValue *labeledValue in phoneNums) {
        CNPhoneNumber *phoneNumer = labeledValue.value;
        NSString *phoneValue = phoneNumer.stringValue;
        if (phoneValue.length > 0) {
            fullPhoneStr = [fullPhoneStr stringByAppendingString:phoneValue];
            fullPhoneStr = [fullPhoneStr stringByAppendingString:@","];
            [phones addObject:phoneValue];
        }

    }
    if (fullPhoneStr.length > 1) {
        personEntity.phoneNumber = [fullPhoneStr substringToIndex:fullPhoneStr.length - 1];
    }
    return personEntity;
}
#ifdef KiOS9Later
#pragma mark contactDelegate
/**
 *  这个方法是点击列表缩回就回调的方法，现在不会调用了
 */
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    HGBMailModel *personEntity = [HGBMailListTool transeContactToModel:contact];
    if(self.delegate&&[self.delegate respondsToSelector:@selector(mailList:didSucessedWithMail:)]){
        [self.delegate mailList:self didSucessedWithMail:personEntity];
    }
}

/**
 *  这个是点击详情页里面的一个字段才回调的方法
 */
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    NSLog(@"选中用户 %@ %@",contactProperty.contact.givenName,contactProperty.contact.familyName);
    [contactProperty.contact.phoneNumbers indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        CNLabeledValue *phoneObj = (CNLabeledValue *)obj;
        if([contactProperty.identifier isEqualToString:phoneObj.identifier]){

            CNPhoneNumber *phoneNumer = phoneObj.value;
            NSString *phoneValue = phoneNumer.stringValue;
            NSLog(@"选中联系人属性 %@",phoneValue);
            HGBMailModel *personEntity = [HGBMailModel new];
            personEntity.lastname = contactProperty.contact.familyName;
            personEntity.firstname = contactProperty.contact.givenName;
            NSMutableString *fullname = [[NSString stringWithFormat:@"%@ %@",personEntity.firstname,personEntity.lastname] mutableCopy];
            [fullname replaceOccurrencesOfString:@"(null)" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, fullname.length)];
            personEntity.fullname = fullname;
            personEntity.phoneNumber = phoneValue;
            if(self.delegate&&[self.delegate respondsToSelector:@selector(mailList:didSucessedWithMail:)]){
                [self.delegate mailList:self didSucessedWithMail:personEntity];
            }
            return true;
        }else{
            return false;
        }
    }];
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    if(self.delegate &&[self.delegate respondsToSelector:@selector(mailListDidCanceled:)]){
        [self.delegate mailListDidCanceled:self];
    }
    NSLog(@"点击取消后的代码");
}

#else
#pragma mark AddressBookDelegate
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(mailListDidCanceled:)]){
        [self.delegate mailListDidCanceled:self];
    }
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    HGBMailModel *personEntity= [HGBMailListTool transeABRecordToModel:person];
    if(self.delegate&&[self.delegate respondsToSelector:@selector(mailList:didSucessedWithMail:)]){
        [self.delegate mailList:self didSucessedWithMail:personEntity];
    }
    if (phone) {
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }
    return YES;
}
#endif




#pragma mark 工具
#pragma mark 获取当前控制器

/**
 获取当前控制器

 @return 当前控制器
 */
+ (UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [HGBMailListTool findBestViewController:viewController];
}

/**
 寻找上层控制器

 @param vc 控制器
 @return 上层控制器
 */
+ (UIViewController *)findBestViewController:(UIViewController *)vc
{
    if (vc.presentedViewController) {
        // Return presented view controller
        return [HGBMailListTool findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBMailListTool findBestViewController:svc.viewControllers.lastObject];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBMailListTool findBestViewController:svc.topViewController];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBMailListTool findBestViewController:svc.selectedViewController];
        }else{
            return vc;
        }
    } else {
        return vc;
    }
}
@end
