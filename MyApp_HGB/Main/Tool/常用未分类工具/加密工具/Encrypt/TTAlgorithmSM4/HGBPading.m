//
//  HGBPading.m
//  测试app
//
//  Created by huangguangbao on 2017/7/6.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#include "HGBPading.h"
#include <stdlib.h>
#include <string.h>

//为要加密的原文进行填充字节
void hgbpaddingForEncryption(unsigned char **input, unsigned long stringLength)
{
    unsigned long length = stringLength;
    if (!*input || length <= 0)
    {
        return;
    }
    
    int mod = 16 - length % 16;
    length = length + mod;
    unsigned char *modChar = (unsigned char*)malloc(sizeof(unsigned char) * (mod + 1));
    memset(modChar, 0, mod + 1);
    memset(modChar, mod, mod);
    
    unsigned char *newChar = (unsigned char*)malloc(sizeof(unsigned char) * (length + 1));
    memset(newChar, 0, length + 1);
    unsigned char *pNewChar = newChar;
    
    unsigned char *pInput = *input;
    
    while (*pInput)
    {
        *pNewChar = *pInput;
        ++pNewChar;
        ++pInput;
    }
    
    unsigned char *pModChar = modChar;
    while (*pModChar)
    {
        *pNewChar = *pModChar;
        ++pNewChar;
        ++pModChar;
    }
    
    pInput = NULL;
    pNewChar = NULL;
    pModChar = NULL;
    free(modChar);
    free(*input);
    *input = newChar;
}

//为已解密的消息去掉填充的字节
void hgbunpaddingForDecryption(unsigned char **input, unsigned long *stringLength)
{
    if (!*input)
    {
        return;
    }
    
    size_t length = 0;
    unsigned char *pInput = *input;
    while (*pInput)
    {
        ++length;
        ++pInput;
    }
    
    //将pInput指向最后一个字节
    --pInput;
    
    //将后面mod个字节置为0
    int mod = *pInput;
    *stringLength = length - mod;
    
    while (mod)
    {
        *pInput = 0;
        --mod;
        --pInput;
    }
}
