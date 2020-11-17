

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnullability-completeness"
#pragma clang diagnostic ignored "-Wstrict-prototypes"


#import <Foundation/Foundation.h>

@class RDMTCellData;
@class ImageData;
@interface RDMTCellData:NSObject
@property size_t DataType;
@property NSString* HeadImgBase64;
@property ImageData* Image;
@property NSString* TitleText;
@property NSString* SecondTitleText;
@property bool CanDel;
@end

@interface ImageData:NSObject
@property NSString* ImageUrl;
@property double ImageWidth;
@property double ImageHeight;
@end

NSArray<RDMTCellData*>* GetListData__NotAllowInMainThread();



#pragma clang diagnostic pop
