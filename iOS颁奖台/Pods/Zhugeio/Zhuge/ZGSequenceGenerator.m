//
// Copyright (c) 2014 Zhuge. All rights reserved.

#import <libkern/OSAtomic.h>
#import "ZGSequenceGenerator.h"

@implementation ZGSequenceGenerator

{
    int32_t _value;
}

- (instancetype)init
{
    return [self initWithInitialValue:0];
}

- (instancetype)initWithInitialValue:(int32_t)initialValue
{
    self = [super init];
    if (self) {
        _value = initialValue;
    }

    return self;
}

- (int32_t)nextValue
{
    return OSAtomicAdd32(1, &_value);
}

@end
