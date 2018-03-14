//
//  AMTagView.m
//  AMTagListView
//
//  Created by Andrea Mazzini on 20/01/14.
//  Copyright (c) 2014 Fancy Pixel. All rights reserved.
//

#import "AMTagView.h"

#define DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)

#define kDefaultInnerPadding	3
#define kDefaultHoleRadius		4
#define kDefaultTagLength		10
#define kDefaultTextPadding		CGPointMake(10, 10)
#define kDefaultRadius			8
#define kDefaultTextColor		[UIColor whiteColor]
#define kDefaultFont			[UIFont systemFontOfSize:14]
#define kDefaultTagColor		[UIColor redColor]
#define kDefaultInnerTagColor	[UIColor colorWithWhite:1 alpha:0.3]
#define kDefaultImagePadding	3

NSString * const AMTagViewNotification = @"AMTagViewNotification";

@interface AMTagView ()

@property (nonatomic, strong) UILabel *labelText;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation AMTagView

#pragma mark - NSObject

+ (void)initialize {
//    [[self appearance] setRadius: kDefaultRadius];
    [[self appearance] setTagLength:kDefaultTagLength];
    [[self appearance] setHoleRadius:kDefaultHoleRadius];
    [[self appearance] setInnerTagPadding:kDefaultInnerPadding];
    [[self appearance] setTextPadding:kDefaultTextPadding];
    [[self appearance] setTextFont:kDefaultFont];
    [[self appearance] setTextColor:kDefaultTextColor];
    [[self appearance] setTagColor:kDefaultTagColor];
    [[self appearance] setInnerTagColor:kDefaultInnerTagColor];
    [[self appearance] setAccessoryImage:nil];
    [[self appearance] setImagePadding:kDefaultImagePadding];
}

#pragma mark - UIResponder

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;

        self.labelText = [[UILabel alloc] init];
        self.button = [[UIButton alloc] init];
//        self.imageView = [[UIImageView alloc] init];
        self.labelText.textAlignment = NSTextAlignmentCenter;
//        _radius = [[[self class] appearance] radius];
        _tagLength = [[[self class] appearance] tagLength];
        _holeRadius = [[[self class] appearance] holeRadius];
        _innerTagPadding = [[[self class] appearance] innerTagPadding];
//        _textPadding = [[[self class] appearance] textPadding];
        _textFont = [[[self class] appearance] textFont];
//        _textColor = [[[self class] appearance] textColor];
//        _tagColor = [[[self class] appearance] tagColor];
//        _innerTagColor = [[[self class] appearance] innerTagColor];
        _accessoryImage = [[[self class] appearance] accessoryImage];
        _imagePadding = [[[self class] appearance] imagePadding];
        [self addSubview:self.labelText];
//        [self addSubview:self.imageView];
        [self addSubview:self.button];
        [self.button addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.backgroundColor = RGB(227, 227, 227);
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat leftMargin = (int)(self.innerTagPadding + self.tagLength + (self.tagLength ? self.radius / 2 : 0));
    CGFloat rightMargin = self.innerTagPadding;

    if (self.accessoryImage) {
        CGRect imageRect = self.imageView.bounds;
        rightMargin = (int)ceilf(rightMargin + imageRect.size.width + self.imagePadding);
        imageRect.origin.x = (int)(self.frame.size.width - rightMargin);
        imageRect.origin.y = (int)(self.frame.size.height - self.imageView.frame.size.height) / 2;
        self.imageView.frame = imageRect;
    }

    [self.labelText.layer setCornerRadius:self.radius / 2];
    [self.labelText setFrame:self.bounds];
    CGRect buttonRect = self.labelText.frame;
    if (self.accessoryImage) {
        buttonRect.size.width = buttonRect.size.width + self.imageView.bounds.size.width + self.imagePadding * 2;
    }

    [self.button setFrame:buttonRect];
//    [self.labelText setTextColor:self.textColor];
    [self.labelText setFont:self.textFont];
}

- (void)drawRect:(CGRect)rect {
    if (self.tagLength > 0) {
        [self drawWithTagForRect:rect];
    } else {
        [self drawWithoutTagForRect:rect];
    }
}

#pragma mark - Private Interface

- (void)actionButton:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotification:[[NSNotification alloc] initWithName:AMTagViewNotification object:self userInfo:@{@"superview": self.superview}]];
}

- (void)drawWithTagForRect:(CGRect)rect {
  
}

- (void)drawWithoutTagForRect:(CGRect)rect {
    if (self.innerTagPadding > 0) {
        UIBezierPath* backgroundPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.radius];
        [self.tagColor setFill];
        [backgroundPath fill];
    }

    CGRect inset = CGRectInset(rect, self.innerTagPadding, self.innerTagPadding);
    UIBezierPath* insidePath = [UIBezierPath bezierPathWithRoundedRect:inset cornerRadius:self.radius - self.innerTagPadding];
    [self.innerTagColor setFill];
    [insidePath fill];
}

#pragma mark - Public Interface

- (void)setupWithText:(NSString*)text {
    UIFont* font = self.textFont;
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: font}];

    float innerPadding = self.innerTagPadding;
    float tagLength = self.tagLength;

    size.width = size.width + self.textPadding.x * 2 + innerPadding * 2 + tagLength;
    if (self.accessoryImage) {
        self.imageView.image = self.accessoryImage;
        [self.imageView sizeToFit];
        size.width += self.imageView.frame.size.width + self.imagePadding;
    }
    size.height = (int)ceilf(size.height + self.textPadding.y);
    size.width = (int)ceilf(size.width);

    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;

    [self.labelText setText:text];
}

- (NSString *)tagText {
    return self.labelText.text;
}

- (void)setTagText:(NSString *)tagText {
    [self setupWithText:tagText];
}

#pragma mark - Custom setters

- (void)setAccessoryImage:(UIImage *)accessoryImage {
    _accessoryImage = accessoryImage;
    self.imageView.image = accessoryImage;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self setNeedsLayout];
}

- (void)setTagColor:(UIColor *)tagColor {
    _tagColor = tagColor;
    [self setNeedsDisplay];
}

- (void)setInnerTagColor:(UIColor *)innerTagColor {
    _innerTagColor = innerTagColor;
    [self setNeedsDisplay];
}

@end
