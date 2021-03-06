//
//  OpenGLES_Ch3_2ViewController.m
//  OpenGLES_Ch3_2
//

#import "OpenGLES_Ch3_2ViewController.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "AGLKContext.h"
#import "AGLKTextureLoader.h"

@implementation OpenGLES_Ch3_2ViewController

@synthesize baseEffect;
@synthesize quadEffect;
@synthesize textEffect;
@synthesize switchEffect;


@synthesize vertexBuffer;
@synthesize quadVertexArray;


/////////////////////////////////////////////////////////////////
// This data type is used to store information for each vertex
typedef struct {
    GLKVector3  positionCoords;
    GLKVector2  textureCoords;
}
SceneVertex;

/////////////////////////////////////////////////////////////////
// Define vertex data for a triangle to use in example
static const SceneVertex vertices[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
    {{0.5f,  0.5f, 0.0f},  {1.0f, 1.0f}} // upper left corner
};

GLfloat quadVertices[12] =
{
    -1.0f, -0.4f, -0.1f,
    0.5f, -0.4f, -0.1f,
    -1.0f, 0.4f, -0.1f,
    0.5f, 0.4f, -0.1f
};


/////////////////////////////////////////////////////////////////
// Called when the view controller's view is loaded
// Perform initialization before the view is asked to draw
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Verify the type of view created automatically by the
    // Interface Builder storyboard
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    
    // Create an OpenGL ES 2.0 context and provide it to the
    // view
    view.context = [[AGLKContext alloc]
                    initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // Make the new context current
    [AGLKContext setCurrentContext:view.context];
    
    // Create a base effect that provides standard OpenGL ES 2.0
    // shading language programs and set constants to be used for
    // all subsequent rendering
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(
                                                   1.0f, // Red
                                                   1.0f, // Green
                                                   1.0f, // Blue
                                                   1.0f);// Alpha
    
    // Create a base effect that provides standard OpenGL ES 2.0
    // shading language programs and set constants to be used for
    // all subsequent rendering
    self.quadEffect = [[GLKBaseEffect alloc] init];
    self.quadEffect.useConstantColor = GL_TRUE;
    self.quadEffect.constantColor = GLKVector4Make(
                                                   0.0f, // Red
                                                   0.0f, // Green
                                                   0.0f, // Blue
                                                   0.2f);// Alpha
    
    
    // Create a base effect that provides standard OpenGL ES 2.0
    // shading language programs and set constants to be used for
    // all subsequent rendering
    self.textEffect = [[GLKBaseEffect alloc] init];
    self.textEffect.useConstantColor = GL_TRUE;
    self.textEffect.constantColor = GLKVector4Make(
                                                   1.0f, // Red
                                                   1.0f, // Green
                                                   1.0f, // Blue
                                                   1.0f);// Alpha
    
    // Create a base effect that provides standard OpenGL ES 2.0
    // shading language programs and set constants to be used for
    // all subsequent rendering
    self.switchEffect = [[GLKBaseEffect alloc] init];
    self.switchEffect.useConstantColor = GL_TRUE;
    self.switchEffect.constantColor = GLKVector4Make(
                                                     1.0f, // Red
                                                     0.0f, // Green
                                                     1.0f, // Blue
                                                     0.0f);// Alpha
    
    
    // Set the background color stored in the current context
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(
                                                              1.0f, // Red
                                                              1.0f, // Green
                                                              1.0f, // Blue
                                                              1.0f);// Alpha
    
    // Create vertex buffer containing vertices to draw
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                         initWithAttribStride:sizeof(SceneVertex)
                         numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
                         bytes:vertices
                         usage:GL_STATIC_DRAW];
    
    // Create vertex buffer containing vertices to draw
    self.quadVertexArray = [[AGLKVertexAttribArrayBuffer alloc]
                            initWithAttribStride:3 * sizeof(GLfloat)
                            numberOfVertices:4
                            bytes:quadVertices
                            usage:GL_STATIC_DRAW];
    
    // Setup texture
    CGImageRef imageRef =
    [[UIImage imageNamed:@"who.jpg"] CGImage];
    
    AGLKTextureInfo *textureInfo = [AGLKTextureLoader
                                    textureWithCGImage:imageRef
                                    options:nil
                                    error:NULL];
    
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
    
    // Setup texture
    imageRef =
    [[UIImage imageNamed:@"image.png"] CGImage];
    
    textureInfo = [AGLKTextureLoader
                                    textureWithCGImage:imageRef
                                    options:nil
                                    error:NULL];
    
    self.textEffect.texture2d0.name = textureInfo.name;
    self.textEffect.texture2d0.target = textureInfo.target;
    
    glEnable(GL_BLEND);
    glBlendFunc( GL_ONE, GL_ONE_MINUS_SRC_ALPHA );
}


/////////////////////////////////////////////////////////////////
// GLKView delegate method: Called by the view controller's view
// whenever Cocoa Touch asks the view controller's view to
// draw itself. (In this case, render into a frame buffer that
// shares memory with a Core Animation Layer)
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    
    // Clear back frame buffer (erase previous drawing)
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                           numberOfCoordinates:3
                                  attribOffset:offsetof(SceneVertex, positionCoords)
                                  shouldEnable:YES];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
                           numberOfCoordinates:2
                                  attribOffset:offsetof(SceneVertex, textureCoords)
                                  shouldEnable:YES];
    
    
    GLKMatrix4 modelviewMatrix =
    GLKMatrix4Multiply(GLKMatrix4MakeTranslation(0.0f, 0.0f, 0),
                       GLKMatrix4MakeRotation(0.0f, 0, 0, 1));
    modelviewMatrix = GLKMatrix4Multiply(GLKMatrix4MakeScale(2 + self.timeSinceFirstResume * 0.02, 2 + self.timeSinceFirstResume * 0.01, 1),
                                         modelviewMatrix);
    self.baseEffect.transform.modelviewMatrix = modelviewMatrix;
    
    if(self.timeSinceFirstResume > 9) {
        float alpha = self.timeSinceFirstResume - 9.0f;
        alpha *= 0.8f;
        
        if(alpha >= 1) {
            alpha = 1.0f;
        }
        
        self.baseEffect.constantColor = GLKVector4Make(
                                                       1.0f, // Red
                                                       1.0f, // Green
                                                       1.0f, // Blue
                                                       1.0f - alpha);// Alpha
    }
    
    
    float moving = -6.0f + self.timeSinceFirstResume * 1.5;
    
    if(moving >= 0) {
        moving = 0.0f;
    }

    
    // Draw triangles using the first three vertices in the
    // currently bound vertex buffer
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLE_STRIP
                        startVertexIndex:0
                        numberOfVertices:4];
    
    self.switchEffect.transform.modelviewMatrix = modelviewMatrix;
    
    
    if(moving == 0.0f && self.timeSinceFirstResume > 10) {
        float alpha = self.timeSinceFirstResume - 10.0f;
        
        alpha *= 0.8f;
        
        if(alpha >= 1) {
            alpha = 1.0f;
        }
        
        self.switchEffect.constantColor = GLKVector4Make(
                                                         1.0f, // Red
                                                         0.0f, // Green
                                                         1.0f, // Blue
                                                         alpha);// Alpha
        [self.switchEffect prepareToDraw];
        
        [self.vertexBuffer drawArrayWithMode:GL_TRIANGLE_STRIP
                            startVertexIndex:0
                            numberOfVertices:4];

    }

    
    
    
    
    [self.quadEffect prepareToDraw];
    
    [self.quadVertexArray prepareToDrawWithAttrib:GLKVertexAttribPosition
                       numberOfCoordinates:3
                       attribOffset:0
                       shouldEnable:YES];
    
    if(self.timeSinceFirstResume > 12) {
        float alpha = self.timeSinceFirstResume - 12.0f;
        alpha *= 0.4f;
        
        if(alpha >= 0.2) {
            alpha = 0.2f;
        }
        
        self.quadEffect.constantColor = GLKVector4Make(
                                                       0.0f, // Red
                                                       0.0f, // Green
                                                       0.0f, // Blue
                                                       0.2f - alpha);// Alpha
    }
    
    modelviewMatrix =
    GLKMatrix4Multiply(GLKMatrix4MakeTranslation(moving, 0.0f, 0),
                       GLKMatrix4MakeRotation(0.0f, 0, 0, 1));
    
    self.quadEffect.transform.modelviewMatrix = modelviewMatrix;
    
    // Draw triangles using the first three vertices in the
    // currently bound vertex buffer
    [self.quadVertexArray drawArrayWithMode:GL_TRIANGLE_STRIP
                          startVertexIndex:0
                          numberOfVertices:4];
    
    [self.textEffect prepareToDraw];
    
    [self.quadVertexArray prepareToDrawWithAttrib:GLKVertexAttribPosition
                              numberOfCoordinates:3
                                     attribOffset:0
                                     shouldEnable:YES];
    
    
    
    self.textEffect.transform.modelviewMatrix = modelviewMatrix;
    
    // Draw triangles using the first three vertices in the
    // currently bound vertex buffer
    [self.quadVertexArray drawArrayWithMode:GL_TRIANGLE_STRIP
                           startVertexIndex:0
                           numberOfVertices:4];
    
    

    
}


/////////////////////////////////////////////////////////////////
// Called when the view controller's view has been unloaded
// Perform clean-up that is possible when you know the view
// controller's view won't be asked to draw again soon.
- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Make the view's context current
    GLKView *view = (GLKView *)self.view;
    [AGLKContext setCurrentContext:view.context];
    
    // Delete buffers that aren't needed when view is unloaded
    self.vertexBuffer = nil;
    
    // Stop using the context created in -viewDidLoad
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}

@end
