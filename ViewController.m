//
//  ViewController.m
//  AutoLayoutSample
//
//  Created by neolix on 14-9-16.
//  Copyright (c) 2014年 Neolix. All rights reserved.
//加swift群一起探讨,群号:106413331

#import "ViewController.h"

@interface ViewController (){
    BOOL _bExpand;
}
@property (nonatomic, strong) NSMutableArray * imageViewList;
@property (nonatomic, strong) NSArray * animationContraints;
@property (nonatomic, strong) NSArray * animationContainerContraints;

@property (weak, nonatomic) IBOutlet UIButton *animationButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIView * containerView;
@property (nonatomic, assign) CGFloat topYPos;
@property (nonatomic, assign) CGFloat maxHeight;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.scrollView addSubview:self.containerView];
    self.imageViewList = [NSMutableArray array];
    for (int i = 0; i < 5; ++i) {
        UIImageView *imageView = [UIImageView new];
        imageView.frame = CGRectMake(0, 0, 20, 40);
        [self.imageViewList addObject:imageView];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        imageView.backgroundColor = [UIColor colorWithWhite:0 + 0.2 * i alpha:1.0];
        [self.containerView insertSubview:imageView aboveSubview:_animationButton];
    }
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.alwaysBounceHorizontal = YES;
}

- (IBAction)click:(id)sender {
    [self.containerView layoutIfNeeded];
    if (!_bExpand) {
        _bExpand = YES;
        [UIView animateWithDuration:.6f animations:^{
            [self.containerView removeConstraints:_animationContraints];
            [self.scrollView removeConstraints:_animationContainerContraints];
            int animationIndex = 2;
            NSString * language = @"V:|";
            NSMutableArray * keys = [NSMutableArray array];
            for (int i = 0; i < self.imageViewList.count; i++) {
                NSString * key = [@"imageView" stringByAppendingString:[@(i) stringValue]];
                
                NSString * value = [NSString stringWithFormat:@"-0-[%@(50)]",key];
                if (i == 0) {
                    value = [NSString stringWithFormat:@"-(-%d)-[%@(50)]",50 * animationIndex ,key];
                }
                if (i == animationIndex) {
                    value = [NSString stringWithFormat:@"-0-[%@(%f)]",key,self.maxHeight];
                }
                language = [language stringByAppendingString:value];
                [keys addObject:key];
            }
            NSDictionary * dic = [NSDictionary dictionaryWithObjects:self.imageViewList forKeys:keys];
            self.animationContraints = [NSLayoutConstraint constraintsWithVisualFormat:language options:0 metrics:nil views:dic];
            [self.containerView addConstraints:self.animationContraints];
            self.animationContainerContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_containerView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_containerView)];
            [self.scrollView addConstraints:self.animationContainerContraints];
            [self.containerView layoutIfNeeded];
        }];
    }else{
        [self.containerView layoutIfNeeded];
        [UIView animateWithDuration:.6f animations:^{
            [self.containerView removeConstraints:self.animationContraints];
            [self.scrollView removeConstraints:self.animationContainerContraints];
            [self reset];
            [self.containerView layoutIfNeeded];
        }];
        _bExpand = NO;
    }
}


- (void)reset{
    NSString *language = @"V:|";
    NSMutableArray *keys = [NSMutableArray array];
    for (int i = 0; i < self.imageViewList.count; ++i) {
        NSString *key = [@"imageView" stringByAppendingString:[@(i) stringValue]];
        NSString *value = [NSString stringWithFormat:@"-0-[%@(50)]", key];
        language = [language stringByAppendingString:value];
        [keys addObject:key];
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:self.imageViewList forKeys:keys];
    
    self.animationContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:language
                                            options:0
                                            metrics:nil
                                              views:dic];
    
    [self.containerView addConstraints:self.animationContraints];
    
    NSString *lan = [NSString stringWithFormat:@"V:|-(%f)-[_containerView]", self.topYPos];
    
    self.animationContainerContraints = [NSLayoutConstraint constraintsWithVisualFormat:lan
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_containerView)];
    
    [self.scrollView addConstraints:
     self.animationContainerContraints
     ];

}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_containerView(320)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_containerView)]];
    for (int i = 0 ; i < self.imageViewList.count; i ++ ) {
        NSString * key = [@"imageView" stringByAppendingString:[@(i) stringValue]];
        NSString * hVFL = [NSString stringWithFormat:@"H:|-0-[%@]-0-|",key];
        NSDictionary  * dictionary = @{key : self.imageViewList[i]};
        NSArray * list = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:0 metrics:nil views:dictionary];
        
        [self.containerView addConstraints:list];
    }
    [self reset];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.scrollView removeConstraints:self.animationContainerContraints];
    self.topYPos = self.scrollView.frame.size.height - 50 * self.imageViewList.count;
    self.maxHeight = self.scrollView.bounds.size.height;
    NSString * lan = [NSString stringWithFormat:@"V:|-(%f)-[_containerView]",self.topYPos];
    self.animationContainerContraints = [NSLayoutConstraint constraintsWithVisualFormat:lan options:0 metrics:nil views:NSDictionaryOfVariableBindings(_containerView)];
    
    [self.scrollView addConstraints:self.animationContainerContraints];
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
