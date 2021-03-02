#import "platform.h"
#import "view.h"

#import <Cocoa/Cocoa.h>

@interface AppView : NSView <NSWindowDelegate>
{
	//TODO: Temp - Delete
	NSFont *_font;
	View *_view;
}
@end

@implementation AppView

	- (instancetype) initWithFrame:(NSRect)frameRect {
		[super initWithFrame:frameRect];
		_font = [NSFont fontWithName:@"Menlo" size:13];
		return self;
	}

	- (void) onCreate {
		if (_view == NULL)
			return;

		_view->onCreate(_view->data);
	}

    //Accept window events
    - (BOOL) acceptsFirstResponder {
        return YES;
    }

    - (void) windowWillClose:(NSNotification *)notification {
		//TODO: Free memory correctly
		_view->onViewDestroy(_view->data);
        [NSApp terminate:self];
    } 

    - (void) dealloc {  
	    [super dealloc];
    }  

	//TODO: Move to View for rendering!!!
	//TODO: Allow for specific redraws
	- (void) drawRect:(NSRect)rectToRedraw {
		if (_view == NULL)
			return;

		_view->onDraw(_view->data);
 	}

	//Events
	- (void) windowDidResize:(NSNotification*) notification {
		
	}

	- (void) mouseMoved:(NSEvent*) event {

	}

	- (void) mouseDragged: (NSEvent*) event {

	}

	- (void) scrollWheel: (NSEvent*) event  {

	}

	- (void) mouseDown: (NSEvent*) event {

	}

	- (void) mouseUp: (NSEvent*) event {
		NSPoint loc = [event locationInWindow];

		ViewEvent ve = {
			.eventKind = MOUSE_UP_EVENT,

			.mouseX = loc.x,
			.mouseY = loc.y 
		};

		_view->onViewEvent(_view->data, ve);
		[self setNeedsDisplay:YES];
	}

	- (void) rightMouseDown: (NSEvent*) event {

	}

	- (void) rightMouseUp: (NSEvent*) event {

	}

	- (void) otherMouseDown: (NSEvent*) event {

	}

	- (void) otherMouseUp: (NSEvent*) event {

	}

	- (void) mouseEntered: (NSEvent*)event {

	}

	- (void) mouseExited: (NSEvent*)event {

	}

	- (void) keyDown: (NSEvent*) event {
		NSString *chars = event.charactersIgnoringModifiers;
    	unichar aChar = [chars characterAtIndex: 0];

		ViewEvent ve = {
			.eventKind = KEY_DOWN_EVENT,
			.code = aChar
		};

		_view->onViewEvent(_view->data, ve);
		[self setNeedsDisplay:YES];
	}

	- (void) keyUp: (NSEvent*) event {

	}

	- (void) setView: (View *) view {
		if (view != NULL)
			_view = view;
	}
@end

//Entry point for the Cocoa application.
int platformRun(WindowOpt *winOptions, View *view) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSApp = [NSApplication sharedApplication];

    //Create Cocoa window.
    NSRect frame = NSMakeRect(0, 0, winOptions->width, winOptions->height);
    NSUInteger style = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable | NSWindowStyleMaskMiniaturizable; 
    NSRect screenRect = [[NSScreen mainScreen] frame];
	NSRect viewRect = NSMakeRect(0, 0, winOptions->width, winOptions->height); 
	NSRect windowRect = NSMakeRect(NSMidX(screenRect) - NSMidX(viewRect),
								 NSMidY(screenRect) - NSMidY(viewRect),
								 viewRect.size.width, 
								 viewRect.size.height);

	NSWindow * window = [[NSWindow alloc] initWithContentRect:windowRect 
						styleMask:style 
						backing:NSBackingStoreBuffered 
						defer:NO]; 

	//Window controller 
	NSWindowController * windowController = [[NSWindowController alloc] initWithWindow:window]; 
	[windowController autorelease];

    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];

    //Create menu bar - we require this as from Snow Leopard this is not given to us.
	id menubar = [[NSMenu new] autorelease];
	id appMenuItem = [[NSMenuItem new] autorelease];
	[menubar addItem:appMenuItem];
	[NSApp setMainMenu:menubar];

	id appMenu = [[NSMenu new] autorelease];
	id quitTitle = [@"Quit " stringByAppendingString:[NSString stringWithCString:winOptions->title encoding:NSASCIIStringEncoding]];
	id quitMenuItem = [[[NSMenuItem alloc] initWithTitle:quitTitle
		                                   action:@selector(terminate:) 
                                           keyEquivalent:@"q"] autorelease];
	[appMenu addItem:quitMenuItem];
	[appMenuItem setSubmenu:appMenu];

    //Create app delegate to handle system events
	AppView* appView = [[[AppView alloc] initWithFrame:frame] autorelease];
	[appView setView:view];
	[appView onCreate];
	[window setAcceptsMouseMovedEvents:YES];
	[window setContentView:appView];
	[window setDelegate:appView];

	[window setContentView:appView];
	[window makeFirstResponder:appView];

	//Set app title
	[window setTitle:[NSString stringWithCString:winOptions->title encoding:NSASCIIStringEncoding]];

	//Add fullscreen button
	[window setCollectionBehavior: NSWindowCollectionBehaviorFullScreenPrimary];

	//Show window and run event loop 
	[window orderFrontRegardless];

	[[NSApp mainWindow] makeKeyWindow];
    [NSApp run];
    //We reach here when the application is closed
    [pool drain];
    return(EXIT_SUCCESS);
}