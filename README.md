# Description
BabyModel is a model class to help create model class easily. Normally, MVC pattern ask us to create a signal structure for Model-View-Controller that don't let Model-View have strong coupling. But, hooking up the signal structure through KVO is a little bit.... not so convenient. Therefore, that comes with this BabyModel for easy to use.

# What We Have
### OBModel
OBModel is a basic class that help you create your own model subclass with desired properties.  

### OBCollection
OBCollection subclassed from OBModel and provides collection changes monitoring.

### KVO Behind the Scene
Yes. They are all backed up by KVO behind the scene. 

# How to Use
### Make a Subclass
```objc
// Create your own model class
@interface VGModel : OBModel
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *backgroundImage;
@end
```
```objc
// Start monitor property change in your viewcontroller or elsewhere
VGModel *aModel = [[VGModel alloc] init];
aModel.title = @"Bob";
aModel.backgroundImage = [UIImage imageNamed:@"green.png"];
    
[aModel addObserver:self forProperty:@"title" withEvent:^(NSString * _Nonnull propertyName, NSDictionary * _Nonnull changes) {
    NSLog(@"Change property: %@, changes: %@", propertyName, changes);
}];
    
[aModel addObserver:self forProperty:@"backgroundImage" withEvent:^(NSString * _Nonnull propertyName, NSDictionary * _Nonnull changes) {
    NSLog(@"I got the images: %@", changes);
}];
    
self.testModel = aModel;
```