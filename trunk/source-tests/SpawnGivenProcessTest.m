// sys
#import <SenTestingKit/SenTestingKit.h>


@interface ProcessIdentifier : NSObject
{
  @public
  pid_t _pid;
}

@end

@implementation ProcessIdentifier
@end



@interface SpawnGivenProcessTest : SenTestCase {
  NSString* _fullPathOfSlow;
}

- (NSString*)fullPathOfSlow;
- (NSString*)parentPathOfSlow;

@end


@implementation SpawnGivenProcessTest

- (void)setUp {
}

- (void)tearDown {
}

- (void)testSpawnProcess {
#if 0
  NSLog(@"full path to slow (%@)", [self fullPathOfSlow]);
  
  
//  NSString* spawn = @"sh -c 'while true; do echo \"busy looping...\"; done'";
  
  NSString* spawn = @"sleep 20";
  
  NSTask* task = [NSTask new];
  [task setLaunchPath: [self fullPathOfSlow]];
  [task setArguments:[NSArray arrayWithObjects:spawn, nil]];
  [task launch];
  int tpid = [task processIdentifier];
  NSLog(@"pid (%d)", tpid);

  NSPipe* pi = [NSPipe pipe];
  NSFileHandle* fh = [pi fileHandleForReading];

  NSTask* ps = [NSTask new];
  [ps setLaunchPath:@"/bin/ps"];
  [ps setArguments:[NSArray arrayWithObjects:@"-c"/*, @"ps -e", @"-e", @"-o pid,ppid,args=CMD"*/, nil]];
  [ps setStandardOutput:pi];
  [ps launch];
  [ps waitUntilExit];
  
  NSData* da = [fh readDataToEndOfFile];

  NSString* out = [[NSString alloc] initWithBytes:[da bytes] length: [da length]
                                         encoding:NSUTF8StringEncoding];
  NSLog(@"%@", out);

  NSScanner* s = [NSScanner scannerWithString:out];
  [s scanString:@"PID" intoString:NULL];
  [s scanString:@"PPID" intoString:NULL];
  [s scanString:@"CMD" intoString:NULL];
  
  int pid;
  int ppid;
  NSString* str;
  
  BOOL foundChildProcess = NO;
  int pidChildProcess = 0;
  while ([s isAtEnd] == NO) {
    
    [s scanInt:&pid];
    [s scanInt:&ppid];
    [s scanUpToCharactersFromSet: [NSCharacterSet newlineCharacterSet] intoString:&str];
    
    NSLog(@"pid(%d) ppid(%d) cmd(%@)", pid, ppid, @"dummy"/*str*/);
    
    if (tpid ==ppid) {
      foundChildProcess = YES;
      pidChildProcess = pid;
    }
  }

  STAssertTrue (foundChildProcess, @"");

  // cleanup
  
  if (foundChildProcess) {
    NSString* kargs = [NSString stringWithFormat:@"kill -9 %d", pidChildProcess];
    NSTask* kill = [NSTask new];
    [kill setLaunchPath:@"/bin/sh"];
    [kill setArguments:[NSArray arrayWithObjects:@"-c", kargs, nil]];
    [kill launch];
    [kill waitUntilExit];  
  }
  
  NSString* kargs = [NSString stringWithFormat:@"kill -9 %d", tpid];
  NSTask* kill = [NSTask new];
  [kill setLaunchPath:@"/bin/sh"];
  [kill setArguments:[NSArray arrayWithObjects:@"-c", kargs, nil]];
  [kill launch];
  [kill waitUntilExit];  

  
  [task waitUntilExit];
#endif
}

- (NSString*)fullPathOfSlow {
  return [NSString pathWithComponents:
          [NSArray arrayWithObjects:[self parentPathOfSlow],@"slow",nil]];
}

- (NSString*)parentPathOfSlow {
  return [[[NSProcessInfo processInfo] environment] objectForKey:@"SLOW_PATH"];
}

@end


