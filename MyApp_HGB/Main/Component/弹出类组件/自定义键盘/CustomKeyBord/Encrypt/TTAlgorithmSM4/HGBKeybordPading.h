//
//  HGBKeybordPading.h
//  HelloCordova
//
//  Created by huangguangbao on 2017/8/9.
//
//

#ifndef HGBKeybordPading_h
#define HGBKeybordPading_h

#include <stdio.h>

/**
 *  @author TTwong, 16-03-30 23:03:27
 *
 *  对要加密的字符串进行补足字节
 *
 *  @param input        要加密的字符串
 *  @param stringLength 输入参数：要加密的字符串的长度
 */
void hgbkeybordpaddingForEncryption(unsigned char **input, unsigned long stringLength);


/**
 *  @author TTwong, 16-03-30 23:03:05
 *
 *  补足字节的反操作
 *
 *  @param input        要解密的字符串
 *  @param stringLength 输出参数：字符串的实际长度
 */
void hgbkeybordunpaddingForDecryption(unsigned char **input, unsigned long *stringLength);
#endif /* HGBKeybordPading_h */
