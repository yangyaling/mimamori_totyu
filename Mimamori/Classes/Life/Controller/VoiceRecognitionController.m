//
//  VoiceRecognitionController.m
//  Mimamori2
//
//  Created by totyu2 on 2017/1/17.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "VoiceRecognitionController.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "RecordingStatus.h"

@interface VoiceRecognitionController ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextField *temperatureText;
@property (weak, nonatomic) IBOutlet UITextField *bloodpressureText;
@property (weak, nonatomic) IBOutlet UITextField *excretionText;
@property (weak, nonatomic) IBOutlet UITextField *eatText;
@property (weak, nonatomic) IBOutlet UITextView *otherText;
@property (weak, nonatomic) IBOutlet UIButton *SayButton;
@property (strong, nonatomic) IBOutlet UILabel *disname;


//初始化一个录音控制器
@property (strong, nonatomic) AVAudioRecorder * recorder;
@property (strong, nonatomic) AVAudioSession* audioSession;
@property (assign, nonatomic) int number;
@property (copy, nonatomic) NSURL *urlPlay;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, strong) NSDateFormatter *fmt;
@property (nonatomic,strong) AFHTTPSessionManager       *session;

@property (nonatomic, assign) BOOL                    isSave;

@end

@implementation VoiceRecognitionController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.isSave = YES;
    self.title = @"介護メモ入力";
    
    _session = [AFHTTPSessionManager manager];
    // 设置请求接口回来时支持什么类型的数组
    _session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
    
    self.disname.text = self.dispname;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完了" style:UIBarButtonItemStyleDone target:self action:@selector(overButton:)];
    
    [self audio];
    
    [_SayButton addTarget:self action:@selector(TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [_SayButton addTarget:self action:@selector(TouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    
    [_SayButton addTarget:self action:@selector(TouchDown:) forControlEvents:UIControlEventTouchDown];
    // Do any additional setup after loading the view, typically from a nib.
    _otherText.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
    _otherText.layer.borderWidth = 0.5;
    _otherText.layer.cornerRadius = 5;
    _otherText.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
    
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    _fmt = [[NSDateFormatter alloc] init];
    _fmt.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
    _timeLabel.text = [_fmt stringFromDate:[NSDate date]];
}


-(void)updateCareMemoInfo{
    
    NSString *url = NITUpdateCarememoInfo;
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setValue:[NITUserDefaults objectForKey:@"userid1"] forKey:@"userid1"];
    [parametersDict setValue:self.userid0 forKey:@"userid0"];
    [parametersDict setValue:[[NSDate date]needDateStatus:HaveHMSType] forKey:@"registdate"];
    
    NSMutableArray *allarr = [NSMutableArray new];
    NSMutableDictionary *dics = [NSMutableDictionary new];
    dics[@"temperature"] = self.temperatureText.text;
    dics[@"bloodpressure"] = self.bloodpressureText.text;
    dics[@"excretion"] = self.excretionText.text;
    dics[@"eat"] = self.eatText.text;
    dics[@"other"] = self.otherText.text;
    [allarr addObject:dics];
    NSError *parseError = nil;
    NSData  *json = [NSJSONSerialization dataWithJSONObject:allarr options: NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    [parametersDict setValue:str forKey:@"content"];
    
    
    [self.session POST:url parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        self.isSave = YES;
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            
            [MBProgressHUD  showSuccess:@"追加しました!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            NITLog(@"追加失败：%@",[responseObject objectForKey:@"code"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.isSave = YES;
        [MBProgressHUD hideHUDForView:self.view];
         NITLog(@"追加失败");
        [MBProgressHUD  showError:@"後ほど試してください"];
    }];
    
}

/**
 *  完了ボタンを押した
 */
- (void)overButton:(id)sender {
    
    if (!self.temperatureText.text.length) {
        [MBProgressHUD showError:@"体温を入力して下さい"];
        return;
    }
    if (!self.bloodpressureText.text.length) {
        [MBProgressHUD showError:@"血圧を入力して下さい"];
        return;
    }
    if (!self.excretionText.text.length) {
        [MBProgressHUD showError:@"排泄状況を入力して下さい"];
        return;
    }
    if (!self.eatText.text.length) {
        [MBProgressHUD showError:@"食事状況を入力して下さい"];
        return;
    }
    if (self.isSave) {
        self.isSave = NO;
        [self updateCareMemoInfo];
        [MBProgressHUD showMessage:@"" toView:self.view];
    }
}


-(void)getNowTime{
    
    _timeLabel.text = [_fmt stringFromDate:[NSDate date]];
}

-(void)TouchUpOutside:(UIButton*)sender{
    
    [self getrecorder:sender];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self removeTimer];
    [[RecordingStatus Status] hideRecordingStatus:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    
}


-(void)TouchUpInside:(UIButton*)sender{
    
    [self getrecorder:sender];
}

-(void)getrecorder:(UIButton*)sender{
    [[RecordingStatus Status]stopAnimate];
    NSLog(@"松开");
    sender.backgroundColor = [UIColor darkGrayColor];
    
    
    [_recorder stop];//停止录音
    [_session.operationQueue cancelAllOperations];
    
    // 2.设置非校验证书模式     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    _session.securityPolicy.allowInvalidCertificates = YES;
    [_session.securityPolicy setValidatesDomainName:NO];
    
    
    NSDictionary *parameter = @{@"uuid":@"d9f99b4b4d3290aa5a1d"};
    
    [_session POST:@"https://138.91.27.119/api/asr/senddata" parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileURL:_recorder.url name:@"file" fileName:@"sample.wav" mimeType:@"audio/x-wav" error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        float progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        NSLog(@"上传进度-----   %f",progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"senddata上传成功 %@",responseObject);
        NSDictionary *success = responseObject;
        NSDictionary *parameterTwo = @{@"uuid":@"d9f99b4b4d3290aa5a1d",@"id":[success valueForKey:@"id"],@"key":[success valueForKey:@"key"]};
        [_session POST:@"https://138.91.27.119/api/asr/recognize" parameters:parameterTwo constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            float progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            NSLog(@"上传进度-----   %f",progress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            [[RecordingStatus Status]stopAnimate];
            NSLog(@"recognize上传成功 %@",responseObject);
            
            NSDictionary *success = responseObject;
            
            if ([[success valueForKey:@"label"]isEqualToString:@"体温"]) {
                _temperatureText.text = [success valueForKey:@"speech"];
            }else if([[success valueForKey:@"label"]isEqualToString:@"血圧"]){
                _bloodpressureText.text = [success valueForKey:@"speech"];
            }else if([[success valueForKey:@"label"]isEqualToString:@"排泄"]){
                _excretionText.text = [success valueForKey:@"speech"];
            }else if([[success valueForKey:@"label"]isEqualToString:@"食事"]){
                _eatText.text = [success valueForKey:@"speech"];
            }else if([[success valueForKey:@"label"]isEqualToString:@"その他"]){
                _otherText.text = [success valueForKey:@"speech"];
            }
            
            
            [[RecordingStatus Status] hideRecordingStatus:[[success valueForKey:@"speech"]isEqualToString:@"NO SPEECH"] ? @"NO SPEECH" : @"成功！"];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"解析失败 %@",error);
            [[RecordingStatus Status] hideRecordingStatus:@"認識できませんでした、再入力下さい！！"];
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败 %@",error);
        [[RecordingStatus Status] hideRecordingStatus:@"認識できませんでした、再入力下さい！"];
    }];
}


-(void)TouchDown:(UIButton*)sender
{
    
    sender.backgroundColor = [UIColor colorWithRed:0.2 green:0.5 blue:0.9 alpha:1.0];
    
    [[RecordingStatus Status]commonInit];
    
    //创建录音文件，准备录音
    
    [_recorder prepareToRecord];
    
    [_recorder record];
    
    NSLog(@"按下");
}


- (void)audio{
    
    _audioSession= [AVAudioSession sharedInstance];
    
    [_audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    
    [_audioSession setActive:YES error:nil];
    
    //录音设置
    NSMutableDictionary*recordSetting = [[NSMutableDictionary alloc]init];
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:16000]forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:1]forKey:AVNumberOfChannelsKey];
    [recordSetting setValue:[NSNumber numberWithInt:16]forKey:AVLinearPCMBitDepthKey];
    
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    
    NSString*strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)lastObject];
    
    _urlPlay= [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sample.wav", strUrl]];
    
    NSError*error;
    
    //初始化
    
    _recorder= [[AVAudioRecorder alloc]initWithURL:_urlPlay settings:recordSetting error:&error];
    
    //开启音量检测
    _recorder.meteringEnabled=YES;
    
}

//移除定时器
-(void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

-(NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(getNowTime)
                                                userInfo:nil
                                                 repeats:YES];
    }
    return _timer;
}

@end
