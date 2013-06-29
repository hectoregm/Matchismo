//
//  SetCardView.m
//  Matchismo
//
//  Created by Hector Enrique Gomez Morales on 6/28/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

#define WHOLE_CARD_CORNER_RADIUS 12.0

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:WHOLE_CARD_CORNER_RADIUS];
    
    [roundedRect addClip];
    
    if (self.faceUp) {
        [[UIColor colorWithWhite:0.9 alpha:1.0] setFill];
    } else {
        [[UIColor whiteColor] setFill];
    }
    UIRectFill(self.bounds);

    [[UIColor colorWithWhite:0.8 alpha:1.0] setStroke];
    [roundedRect stroke];
    
    [self drawSymbols];
}

#define SYMBOL_OFFSET 0.2;
#define SYMBOL_LINE_WIDTH 0.02;

- (void)drawSymbols
{
    [[self uiColor] setStroke];
    CGPoint centerPoint = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    if (self.number == 1) {
        [self drawSymbolAtPoint:centerPoint];
        return;
    }
    CGFloat dx = self.bounds.size.width * SYMBOL_OFFSET;
    if (self.number == 2) {
        [self drawSymbolAtPoint:CGPointMake(centerPoint.x - dx / 2, centerPoint.y)];
        [self drawSymbolAtPoint:CGPointMake(centerPoint.x + dx / 2, centerPoint.y)];
        return;
    }
    if (self.number == 3) {
        [self drawSymbolAtPoint:centerPoint];
        [self drawSymbolAtPoint:CGPointMake(centerPoint.x - dx, centerPoint.y)];
        [self drawSymbolAtPoint:CGPointMake(centerPoint.x + dx, centerPoint.y)];
        return;
    }
}

#define RED_COLOR 0
#define GREEN_COLOR 1
#define PURPLE_COLOR 2

- (UIColor *)uiColor
{
    UIColor *color;
    switch (self.color) {
        case RED_COLOR:
            color = [UIColor redColor];
            break;
        case GREEN_COLOR:
            color = [UIColor greenColor];
            break;
        case PURPLE_COLOR:
            color = [UIColor purpleColor];
            break;
        default:
            color = nil;
            break;
    }

    return color;
}

#define DIAMOND 0
#define SQUIGGLE 1
#define OVAL 2

- (void)drawSymbolAtPoint:(CGPoint)center
{
    switch (self.symbol) {
        case DIAMOND:
            [self drawDiamondAtPoint:center];
            break;
        case SQUIGGLE:
            [self drawSquiggleAtPoint:center];
            break;
        case OVAL:
            [self drawOvalAtPoint:center];
            break;
        default:
            break;
    }
}

#define DIAMOND_WIDTH 0.15
#define DIAMOND_HEIGHT 0.4

- (void)drawDiamondAtPoint:(CGPoint)point;
{
    CGFloat dx = self.bounds.size.width * DIAMOND_WIDTH / 2;
    CGFloat dy = self.bounds.size.height * DIAMOND_HEIGHT / 2;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(point.x, point.y - dy)];
    [path addLineToPoint:CGPointMake(point.x + dx, point.y)];
    [path addLineToPoint:CGPointMake(point.x, point.y + dy)];
    [path addLineToPoint:CGPointMake(point.x - dx, point.y)];
    [path closePath];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [self shadePath:path];
    [path stroke];
}

#define SQUIGGLE_WIDTH 0.12
#define SQUIGGLE_HEIGHT 0.3
#define SQUIGGLE_FACTOR 0.8

- (void)drawSquiggleAtPoint:(CGPoint)point;
{
    CGFloat dx = self.bounds.size.width * SQUIGGLE_WIDTH / 2;
    CGFloat dy = self.bounds.size.height * SQUIGGLE_HEIGHT / 2;
    CGFloat dsqx = dx * SQUIGGLE_FACTOR;
    CGFloat dsqy = dy * SQUIGGLE_FACTOR;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(point.x - dx, point.y - dy)];
    [path addQuadCurveToPoint:CGPointMake(point.x + dx, point.y - dy)
                 controlPoint:CGPointMake(point.x - dsqx, point.y - dy - dsqy)];
    [path addCurveToPoint:CGPointMake(point.x + dx, point.y + dy)
            controlPoint1:CGPointMake(point.x + dx + dsqx, point.y - dy + dsqy)
            controlPoint2:CGPointMake(point.x + dx - dsqx, point.y + dy - dsqy)];
    [path addQuadCurveToPoint:CGPointMake(point.x - dx, point.y + dy)
                 controlPoint:CGPointMake(point.x + dsqx, point.y + dy + dsqy)];
    [path addCurveToPoint:CGPointMake(point.x - dx, point.y - dy)
            controlPoint1:CGPointMake(point.x - dx - dsqx, point.y + dy - dsqy)
            controlPoint2:CGPointMake(point.x - dx + dsqx, point.y - dy + dsqy)];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [self shadePath:path];
    [path stroke];
}

#define OVAL_WIDTH 0.12
#define OVAL_HEIGHT 0.4

- (void)drawOvalAtPoint:(CGPoint)point;
{
    CGFloat dx = self.bounds.size.width * OVAL_WIDTH / 2;
    CGFloat dy = self.bounds.size.height * OVAL_HEIGHT / 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x - dx, point.y - dy, 2 * dx, 2 * dy)
                                                    cornerRadius:dx];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [self shadePath:path];
    [path stroke];
}

#define SOLID_SHAPE 0
#define STRIPPED_SHAPE 1
#define OUTLINE_SHAPE 2

#define STRIPES_OFFSET 0.06
#define STRIPES_ANGLE 5

- (void)shadePath:(UIBezierPath *)path
{
    if (self.shading == SOLID_SHAPE) {
        [[self uiColor] setFill];
        [path fill];
    } else if (self.shading == STRIPPED_SHAPE) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        [path addClip];
        UIBezierPath *stripes = [[UIBezierPath alloc] init];
        CGPoint start = self.bounds.origin;
        CGPoint end = start;
        CGFloat dy = self.bounds.size.height * STRIPES_OFFSET;
        end.x += self.bounds.size.width;
        start.y += dy * STRIPES_ANGLE;
        for (int i = 0; i < 1 / STRIPES_OFFSET; i++) {
            [stripes moveToPoint:start];
            [stripes addLineToPoint:end];
            start.y += dy;
            end.y += dy;
        }
        stripes.lineWidth = self.bounds.size.width / 2 * SYMBOL_LINE_WIDTH;
        [stripes stroke];
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
    } else if (self.shading == OUTLINE_SHAPE) {
        [[UIColor clearColor] setFill];
        [path fill];
    }
}

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setSymbol:(NSUInteger)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setShading:(NSUInteger)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setColor:(NSUInteger)color
{
    _color = color;
    [self setNeedsDisplay];
}
@end
