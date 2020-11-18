//
//  HBDrawingBoard.m
//  DemoAntiAliasing
//
//  Created by 伍宏彬 on 15/11/2.
//  Copyright (c) 2015年 HB. All rights reserved.
//

#import "HBDrawingBoard.h"
#import "UIView+WHB.h"
#import "UIColor+help.h"
#import "HBDrawPoint.h"
#import "MJExtension.h"
#import "ZXCustomWindow.h"
#import "NSFileManager+Helper.h"

@interface HBDrawingBoard()
{
    UIColor *_lastColor;
    CGFloat _lastLineWidth;
    
    CGFloat _lineWidth;
    UIColor *_lineColor;

}

@property (nonatomic, strong) NSMutableArray *paths;

@property (nonatomic, strong) NSMutableArray *tempPoints;

@property (nonatomic, strong) NSMutableArray *tempPath;

@property (nonatomic, strong) UIImageView *drawImage;

@property (nonatomic, strong) HBDrawView *drawView;

@property (nonatomic, strong) UIImage *editImage;

@property (nonatomic, strong) NSMutableArray *tempReloadPaths;// 测试用

@end
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

#define PenWidth 4 // 画笔宽度
#define EraserWidth 8 // 橡皮擦宽度

#define ThumbnailPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"HBThumbnail"]

@implementation HBDrawingBoard

- (instancetype)initWithFrame:(CGRect)frame settingBoard:(HBDrawSettingBoard *)settingBoard image:(UIImage *)image slider:(UISlider *)slider
{
    self = [super initWithFrame:frame];
    if (self) {
        self.editImage = image;
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.backImage];
        
        [self addSubview:self.drawImage];

        [self.drawImage addSubview:self.drawView];
        self.settingBoard = settingBoard;
        [self setSettingBoardGetSettingtype];
        // 背景图片，画笔颜色，画笔宽度
        self.backImage.image = image;
        _lineColor = [UIColor redColor];
        _lineWidth = PenWidth;
        
        [self setThisFrame];
        self.paths = [[NSMutableArray alloc] init];
        self.tempPath = [[NSMutableArray alloc] init];
        self.tempPoints = [[NSMutableArray alloc] init];
        
        _slider = slider;
        if(self.imageHeight > Screen_Height){
            _slider.hidden = NO;
        }
        // 转屏通知
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    }
    return self;
}

#pragma mark - Public_Methd
// 布局绘画view
-(void)setThisFrame{
    [self getImageSize];
    // 重新设置位置
    CGRect temp = self.frame;
    // 距顶部70（工具栏高度）
    temp.origin.y = 70;
    temp.size.width = (int)Screen_Width;
    temp.size.height = (int)self.imageHeight;
    // ppt类型的附件，高度小于屏幕高度很多，居中显示
    if(self.imageHeight < Screen_Height){
        temp.origin.y = (Screen_Height - temp.size.height)/2;
    }
    self.frame = temp;
    temp.origin.y = 0;
    self.backImage.frame = temp;
    self.drawImage.frame = temp;
    
    self.drawView.frame = temp;
    CGRect settingTemp = self.settingBoard.frame;
    settingTemp.size.width = (int)Screen_Width;
    self.settingBoard.frame = settingTemp;
    self.slider.value = 0;
    
    if(self.imageHeight > Screen_Height){
        _slider.hidden = NO;
    }
}

- (void)didChangeRotate:(NSNotification*)notice {
    NSLog(@"批注页切换横竖屏");
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
        || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
        NSLog(@"竖屏");
    } else {
        NSLog(@"横屏");
        [self setThisFrame];
    }
    
}

- (void)getImageSize
{
    CGSize imageSize = self.editImage.size;
    if (imageSize.width != 0)
    {
        self.imageHeight = imageSize.height / imageSize.width * Screen_Width;
    }
}

- (UIViewController *)currentVC{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}

- (BOOL)drawWithPoints:(HBDrawModel *)model{

    self.userInteractionEnabled = NO;
    
    //比值
    CGFloat xPix = ([UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale);
    CGFloat yPix = ([UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale);
    CGFloat xp = model.width.floatValue / xPix;
    CGFloat yp = model.height.floatValue / yPix;
    
    HBDrawPoint *point = [model.pointList firstObject];
    
    HBPath *path = [HBPath pathToPoint:CGPointMake(point.x.floatValue * xp , point.y.floatValue * yp) pathWidth:model.paintSize.floatValue isEraser:model.isEraser.boolValue];
    path.pathColor = [UIColor colorWithHexString:model.paintColor];
    
    [self.paths addObject:path];
    
    NSMutableArray *marray = [model.pointList mutableCopy];
    
    [marray removeObjectAtIndex:0];

    [marray enumerateObjectsUsingBlock:^(HBDrawPoint *point, NSUInteger idx, BOOL *stop) {
        
        [path pathLineToPoint:CGPointMake(point.x.floatValue * xp , point.y.floatValue * yp) WithType:HBDrawingShapeCurve];
        
        [self.drawView setBrush:path];
        
    }];
    
    self.userInteractionEnabled = YES;
    return YES;
}
+ (HBDrawModel *)objectWith:(NSDictionary *)dic
{
    return [HBDrawModel objectWithKeyValues:dic];
}

// 工具栏按钮对应方法
-(void)setSettingBoardGetSettingtype{
    [_settingBoard getSettingType:^(setType type) {
        switch (type) {
            case setTypePen:
            {
                self.ise = NO;
                self.lineColor = [UIColor whiteColor];
                self.shapType = HBDrawingShapeCurve;
                self.lineWidth = 1.5;
            }
                break;
            case setTypeCamera:
            {
                if ([self.delegate respondsToSelector:@selector(drawBoard:action:)]) {
                    [self.delegate drawBoard:self action:actionOpenCamera];
                }

            }
                break;
            case setTypeAlbum:
            {
                if ([self.delegate respondsToSelector:@selector(drawBoard:action:)]) {
                    [self.delegate drawBoard:self action:actionOpenAlbum];
                }
            }
                break;
            case setTypeSave:
            {
                // 保存
//                UIImage *image = [self screenshot:self];
                self.tempReloadPaths = [[NSMutableArray alloc] init];
                for (HBPath *path in self.paths) {
                    [self.tempReloadPaths addObject:path];
                }
            }
                break;
            case setTypeEraser:
            {
                if (!self.ise) {
                    //保存上次绘制状态
                    self->_lastColor = self->_lineColor;
//                    _lastLineWidth = _lineWidth;
                    self->_lineWidth = EraserWidth;
                    
                    //设置橡皮擦属性
                    self->_lineColor = [UIColor clearColor];
                    
                    self.ise = YES;
                }else{
                    self.ise = NO;
                    self.shapType = HBDrawingShapeCurve;
                    self->_lineColor = self->_lastColor;
//                    _lineWidth = _lastLineWidth;
                    self->_lineWidth = PenWidth;
                }
                
            }
                break;
            case setTypeBack:
            {
                if (self.paths.count == 0) {
                    
                    return;
                }
                if (self.paths.count == 1) {
                    
                    NSLog(@"已经最后一张了，不能撤退了");
                    return;
                }

                HBPath *lastpath = [self.paths lastObject];
                
                [self.tempPath addObject:lastpath];
                
                [self.paths removeLastObject];
                
                HBPath *path = [self.paths lastObject];
                
                UIImage *getImage = [NSFileManager hb_getImageFileName:[ThumbnailPath stringByAppendingPathComponent:path.imagePath]];
                self.drawImage.image = getImage;
            }
                break;
            case setTyperegeneration:
            {
                
                if (self.tempPath.count == 0) {
                    NSLog(@"已经最新一张了，不能回滚了");
                    return;
                }

                HBPath *lastpath = [self.tempPath lastObject];
                
                [self.paths addObject:lastpath];
                
                [self.tempPath removeLastObject];
                
                HBPath *path = [self.paths lastObject];
                
                UIImage *getImage = [NSFileManager hb_getImageFileName:[ThumbnailPath stringByAppendingPathComponent:path.imagePath]];
                self.drawImage.image = getImage;
                
            }
                break;
            case setTypeClearAll:
            {
                [self.paths removeAllObjects];
                [self.tempPath removeAllObjects];
                [self.tempPoints removeAllObjects];
                
                [NSFileManager deleteFile:ThumbnailPath];
                
                self.drawImage.image = nil;
            }
                break;
            case setTypeJiexi:
            {
                [self.paths removeAllObjects];
                [self.tempPath removeAllObjects];
                [self.tempPoints removeAllObjects];
                
                [NSFileManager deleteFile:ThumbnailPath];
                
                self.drawImage.image = nil;
                for (HBPath *path in self.tempReloadPaths) {
                    [self.drawView setBrush:path];
                    UIImage *image = [self screenshot:self];
                    
                    self.drawImage.image = image;
                    // 是否是橡皮擦
                    if(path.isEraser){
                        [self setEraseBrush:path];
                    }else{
                        [self.drawView setBrush:nil];
                    }
                    NSData *imageData = UIImagePNGRepresentation(image);//UIImageJPEGRepresentation(image, 0.4);
                    
                    NSString *filePath = [ThumbnailPath stringByAppendingPathComponent:path.imagePath];

                    BOOL isSave = [NSFileManager hb_saveData:imageData filePath:filePath];
                }
                self.paths = [[NSMutableArray alloc] initWithArray:self.tempReloadPaths];
                
            }
                break;
            default:
                break;
        }
    }];
}

#pragma mark - CustomMethd
- (CGPoint)getTouchSet:(NSSet *)touches{
    UITouch *touch = [touches anyObject];
     return [touch locationInView:self];
}

-(CGSize)imageSizeAfterAspectFit:(UIImageView*)imageView
{
    float imageRatio = imageView.image.size.width / imageView.image.size.height;
    float viewRatio = imageView.frame.size.width / imageView.frame.size.height;
    if(imageRatio < viewRatio)
    {
        float scale = imageView.frame.size.height / imageView.image.size.height;
        float width = scale * imageView.image.size.width;
        return CGSizeMake(width, imageView.frame.size.height);
    }
    else
    {
        float scale = imageView.frame.size.width / imageView.image.size.width;
        float height = scale * imageView.image.size.height;
        return CGSizeMake(imageView.frame.size.width, height);
    }
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [self getTouchSet:touches];

    HBPath *path = [HBPath pathToPoint:point pathWidth:_lineWidth isEraser:self.ise];

    path.pathColor = _lineColor;
    
    path.imagePath = [NSString stringWithFormat:@"%@.png",[self getTimeString]];
    
    [self.paths addObject:path];

    [self.tempPoints addObject:[HBDrawPoint drawPoint:point]];
    
    if ([self.delegate respondsToSelector:@selector(drawBoard:drawingStatus:model:)]) {
        [self.delegate drawBoard:self drawingStatus:HBDrawingStatusBegin model:nil];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [self getTouchSet:touches];

    HBPath *path = [self.paths lastObject];
    
    [path pathLineToPoint:point WithType:self.shapType];
    
    if (self.ise) {
        [self setEraseBrush:path];
    }else{
        [self.drawView setBrush:path];
    }
    
    [self.tempPoints addObject:[HBDrawPoint drawPoint:point]];
    
    if ([self.delegate respondsToSelector:@selector(drawBoard:drawingStatus:model:)]) {
        [self.delegate drawBoard:self drawingStatus:HBDrawingStatusMove model:nil];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
    
    HBPath *path = [self.paths lastObject];
    
    UIImage *image = [self screenshot:self];
    
    self.drawImage.image = image;
    
    [self.drawView setBrush:nil];
    
    NSData *imageData = UIImagePNGRepresentation(image);//UIImageJPEGRepresentation(image, 0.4);
    
    NSString *filePath = [ThumbnailPath stringByAppendingPathComponent:path.imagePath];

    BOOL isSave = [NSFileManager hb_saveData:imageData filePath:filePath];
    
    if (isSave) {
        
        NSLog(@"%@", [NSString stringWithFormat:@"保存成功: %@",filePath]);
    }
    HBDrawModel *model = [[HBDrawModel alloc] init];
    model.paintColor = [_lineColor toColorString];
    model.paintSize = @(_lineWidth);
    model.isEraser = [NSNumber numberWithBool:path.isEraser];
    model.pointList = self.tempPoints;
    model.shapType = [NSNumber numberWithInteger:self.shapType];
    
    if ([self.delegate respondsToSelector:@selector(drawBoard:drawingStatus:model:)]) {
        [self.delegate drawBoard:self drawingStatus:HBDrawingStatusEnd model:model];
    }

    //清空
    [self.tempPoints removeAllObjects];
}
- (void)setEraseBrush:(HBPath *)path{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0);
    
    [self.drawImage.image drawInRect:self.bounds];
    
    [[UIColor clearColor] set];
    
    path.bezierPath.lineWidth = _lineWidth;
    
    [path.bezierPath strokeWithBlendMode:kCGBlendModeClear alpha:1.0];
    
    [path.bezierPath stroke];
    
    self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}
- (UIImage *)screenshot:(UIView *)shotView{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [shotView.layer renderInContext:context];
    
    UIImage *getImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return getImage;
}
- (NSString *)getTimeString{
    NSDateFormatter  *dateformatter = nil;
    if (!dateformatter) {
        dateformatter = [[NSDateFormatter alloc] init];
    }
    
    [dateformatter setDateFormat:@"YYYYMMddHHmmssSSS"];
    
    return [dateformatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
}
- (void)showSettingBoard
{
//    [self.drawWindow showWithAnimationTime:0.25];
}
- (void)hideSettingBoard
{
//    [self.drawWindow hideWithAnimationTime:0.25];
}
#pragma mark - Lazying
- (NSMutableArray *)paths{
    if (!_paths) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}
- (NSMutableArray *)tempPoints{
    if (!_tempPoints) {
        _tempPoints = [NSMutableArray array];
    }
    return _tempPoints;
}
- (NSMutableArray *)tempPath{
    if (!_tempPath) {
        _tempPath = [NSMutableArray array];
    }
    return _tempPath;
}
- (void)setShapType:(HBDrawingShapeType)shapType{
    if (self.ise) {
        return;
    }
    _shapType = shapType;
}

- (void)setLineColor:(UIColor *)lineColor
{
    if (self.ise) {
        
        _lastColor = lineColor;
        
        return;
    }
    
    _lineColor = lineColor;
}
- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    _lastLineWidth = lineWidth;
}
- (UIImageView *)backImage
{
    if (!_backImage) {
        _backImage = [[UIImageView alloc] initWithFrame:self.frame];
//        _backImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _backImage;
}
- (UIImageView *)drawImage
{
    if (!_drawImage) {
        _drawImage = [[UIImageView alloc] initWithFrame:self.frame];
//        _drawImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _drawImage;
}
- (HBDrawView *)drawView{
    if (!_drawView) {
        _drawView = [HBDrawView new];
        _drawView.backgroundColor = [UIColor clearColor];
        _drawView.frame = self.frame;
        
    }
    return _drawView;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ImageBoardNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SendColorAndWidthNotification object:nil];
}
@end

#pragma mark - HBPath
@interface HBPath()

@property (nonatomic, assign) CGPoint beginPoint;
@property (nonatomic, assign) CGFloat pathWidth;

@end

@implementation HBPath

+ (instancetype)pathToPoint:(CGPoint)beginPoint pathWidth:(CGFloat)pathWidth isEraser:(BOOL)isEraser
{
    HBPath *path = [[HBPath alloc] init];
    path.beginPoint = beginPoint;
    path.pathWidth = pathWidth;
    path.isEraser = isEraser;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth = pathWidth;
    bezierPath.lineCapStyle = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    [bezierPath moveToPoint:beginPoint];
    path.bezierPath = bezierPath;
    
    return path;
}
//HBDrawingShapeCurve = 0,//曲线
//HBDrawingShapeLine,//直线
//HBDrawingShapeEllipse,//椭圆
//HBDrawingShapeRect,//矩形
- (void)pathLineToPoint:(CGPoint)movePoint WithType:(HBDrawingShapeType)shapeType
{
    //判断绘图类型
    _shapType = shapeType;
    switch (shapeType) {
        case HBDrawingShapeCurve:
        {
            [self.bezierPath addLineToPoint:movePoint];
        }
            break;
        case HBDrawingShapeLine:
        {
            self.bezierPath = [UIBezierPath bezierPath];
            self.bezierPath.lineCapStyle = kCGLineCapRound;
            self.bezierPath.lineJoinStyle = kCGLineJoinRound;
            self.bezierPath.lineWidth = self.pathWidth;
            [self.bezierPath moveToPoint:self.beginPoint];
            [self.bezierPath addLineToPoint:movePoint];
        }
            break;
        case HBDrawingShapeEllipse:
        {
            self.bezierPath = [UIBezierPath bezierPathWithRect:[self getRectWithStartPoint:self.beginPoint endPoint:movePoint]];
            self.bezierPath.lineCapStyle = kCGLineCapRound;
            self.bezierPath.lineJoinStyle = kCGLineJoinRound;
            self.bezierPath.lineWidth = self.pathWidth;
        }
            break;
        case HBDrawingShapeRect:
        {
            self.bezierPath = [UIBezierPath bezierPathWithOvalInRect:[self getRectWithStartPoint:self.beginPoint endPoint:movePoint]];
            self.bezierPath.lineCapStyle = kCGLineCapRound;
            self.bezierPath.lineJoinStyle = kCGLineJoinRound;
            self.bezierPath.lineWidth = self.pathWidth;
        }
            break;
        default:
            break;
    }
//    self.shape.path = self.bezierPath.CGPath;
}

- (CGRect)getRectWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    CGPoint orignal = startPoint;
    if (startPoint.x > endPoint.x) {
        orignal = endPoint;
    }
    CGFloat width = fabs(startPoint.x - endPoint.x);
    CGFloat height = fabs(startPoint.y - endPoint.y);
    return CGRectMake(orignal.x , orignal.y , width, height);
}

@end

@implementation HBDrawView

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (void)setBrush:(HBPath *)path
{
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
    
    shapeLayer.strokeColor = path.pathColor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineWidth = path.bezierPath.lineWidth;
    ((CAShapeLayer *)self.layer).path = path.bezierPath.CGPath;
    
    
}


@end
