//
//  OpenGLES_Ch3_2ViewController.h
//  OpenGLES_Ch3_2
//

#import <GLKit/GLKit.h>

@class AGLKVertexAttribArrayBuffer;


@interface OpenGLES_Ch3_2ViewController : GLKViewController
{
}

@property (strong, nonatomic) GLKBaseEffect
*baseEffect;
@property (strong, nonatomic) GLKBaseEffect
*quadEffect;

@property (strong, nonatomic) AGLKVertexAttribArrayBuffer
*vertexBuffer;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer
*quadVertexArray;

@end
