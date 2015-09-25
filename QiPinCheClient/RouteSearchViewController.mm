//
//  RouteSearchViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/3.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "RouteSearchViewController.h"
#import "UIImage+Rotate.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface RouteAnnotation : BMKPointAnnotation
{
	int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
	int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end


@implementation RouteSearchViewController

- (NSString*)getMyBundlePath1:(NSString *)filename
{
	
	NSBundle * libBundle = MYBUNDLE ;
	if (libBundle && filename) {
		NSString *s = [[libBundle resourcePath] stringByAppendingPathComponent:filename];
		return s;
	}
	return nil ;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    index = 0;
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    float y = self.naviBar.frame.origin.y + self.naviBar.frame.size.height;
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, y, UISCREEN_WIDTH,  UISCREEN_HEIGHT - y)];
    float lat, lng;
    NSArray *array = ApplicationDelegate.route;
    if ([array count] == 4)
    {
        _routesearch = [[BMKRouteSearch alloc]init];
        
        start = [[BMKPlanNode alloc]init];
        lat = [self getLatOrLngByString:[array[0] objectForKey:@"lat"]];
        lng = [self getLatOrLngByString:[array[0] objectForKey:@"lng"]];
        start.pt = CLLocationCoordinate2DMake(lat, lng);
        
        RouteAnnotation* item1 = [[RouteAnnotation alloc]init];
        item1.coordinate = start.pt;
        item1.title = [array[0] objectForKey:@"name"];;
        item1.type = 0;
        [_mapView addAnnotation:item1];
        
        
        lat = [self getLatOrLngByString:[array[1] objectForKey:@"lat"]];
        lng = [self getLatOrLngByString:[array[1] objectForKey:@"lng"]];
        end = [[BMKPlanNode alloc]init];
        end.pt = CLLocationCoordinate2DMake(lat, lng);
        RouteAnnotation *item2 = [[RouteAnnotation alloc] init];
        item2.coordinate = end.pt;
        item2.title = [array[1] objectForKey:@"name"];
        item2.type = 0;
        [_mapView addAnnotation:item2];
        
        BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
        drivingRouteSearchOption.from = start;
        drivingRouteSearchOption.to = end;
        BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
        if(flag)
        {
            NSLog(@"car检索发送成功");
        }
        else
        {
            NSLog(@"car检索发送失败");
        }
        
        
        _routesearch1 = [[BMKRouteSearch alloc] init];
        
        start1 = [[BMKPlanNode alloc] init];
        end1 = [[BMKPlanNode alloc] init];
        start1.pt = CLLocationCoordinate2DMake(lat, lng);
        
        lat = [self getLatOrLngByString:[array[2] objectForKey:@"lat"]];
        lng = [self getLatOrLngByString:[array[2] objectForKey:@"lng"]];
        end1.pt = CLLocationCoordinate2DMake(lat, lng);
        RouteAnnotation *item3 = [[RouteAnnotation alloc] init];
        item3.coordinate = end1.pt;
        item3.title = [array[2] objectForKey:@"name"];
        item3.type = 1;
        [_mapView addAnnotation:item3];
        
        
        drivingRouteSearchOption.from = start1;
        drivingRouteSearchOption.to = end1;
        flag = [_routesearch1 drivingSearch:drivingRouteSearchOption];
        if(flag)
        {
            NSLog(@"car检索发送成功");
        }
        else
        {
            NSLog(@"car检索发送失败");
        }
        
        _routesearch2 = [[BMKRouteSearch alloc] init];
        
        start2 = [[BMKPlanNode alloc] init];
        end2 = [[BMKPlanNode alloc] init];
        start2.pt = CLLocationCoordinate2DMake(lat, lng);
        
        lat = [self getLatOrLngByString:[array[3] objectForKey:@"lat"]];
        lng = [self getLatOrLngByString:[array[3] objectForKey:@"lng"]];
        end2.pt = CLLocationCoordinate2DMake(lat, lng);
        RouteAnnotation *item4 = [[RouteAnnotation alloc] init];
        item4.coordinate = end2.pt;
        item4.title = [array[3] objectForKey:@"name"];
        item4.type = 1;
        [_mapView addAnnotation:item4];
        
        drivingRouteSearchOption.from = start2;
        drivingRouteSearchOption.to = end2;
        flag = [_routesearch2 drivingSearch:drivingRouteSearchOption];
        if(flag)
        {
            NSLog(@"car检索发送成功");
        }
        else
        {
            NSLog(@"car检索发送失败");
        }
    }
    
    [self.view addSubview:_mapView];
}



- (float) getLatOrLngByString:(NSString*) string {
    return [string floatValue];
}

-(void)viewWillAppear:(BOOL)animated {
    //[_mapView viewWillAppear];
    [super viewWillAppear:YES];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _routesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _routesearch1.delegate = self;
    _routesearch2.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _routesearch.delegate = nil; // 不用时，置nil
    _routesearch1.delegate = nil;
    _routesearch2.delegate = nil;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    if (_routesearch != nil) {
        _routesearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}



- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
	BMKAnnotationView* view = nil;
	switch (routeAnnotation.type) {
		case 0:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 1:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 2:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 3:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 4:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
			
		}
			break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
        }
            break;
		default:
			break;
	}
	
	return view;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
	if ([annotation isKindOfClass:[RouteAnnotation class]]) {
		return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
	}
	return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
	return nil;
}

- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSUInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i == 0){
                NSString *name = [self getSourceName:plan.starting.location];
                if (name != nil) {
                    RouteAnnotation* item = [[RouteAnnotation alloc]init];
                    item.coordinate = plan.starting.location;
                    item.title = name;
                    item.type = 0;
                    [_mapView addAnnotation:item]; // 添加起点标注
                }
                
            } else if(i == size - 1){
                NSString *name = [self getDestinationName:plan.terminal.location];
                if (name != nil) {
                    RouteAnnotation* item = [[RouteAnnotation alloc]init];
                    item.coordinate = plan.terminal.location;
                    item.title = name;
                    item.type = 1;
                    [_mapView addAnnotation:item]; // 添加起点标注
                }
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
    
    index ++;
}



-(IBAction)textFiledReturnEditing:(id)sender {
    [sender resignFirstResponder];
}


//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (NSString*) getSourceName:(CLLocationCoordinate2D) location {
    NSArray *array = ApplicationDelegate.route;
    if (fabs(location.latitude - [[array[0] objectForKey:@"lat"] doubleValue]) <= 0.0001 && fabs(location.longitude - [[array[0] objectForKey:@"lng"] doubleValue]) <= 0.0001) {
        return [array[0] objectForKey:@"name"];
    }
    
    if (fabs(location.latitude - [[array[1] objectForKey:@"lat"] doubleValue]) < 0.0001 && fabs(location.longitude - [[array[1] objectForKey:@"lng"] doubleValue]) < 0.0001) {
        return [array[1] objectForKey:@"name"];
    }
    
    return nil;
}

- (NSString*) getDestinationName:(CLLocationCoordinate2D) location {
    NSArray *array = ApplicationDelegate.route;
    if (fabs(location.latitude - [[array[2] objectForKey:@"lat"] doubleValue]) <= 0.0001 && fabs(location.longitude - [[array[2] objectForKey:@"lng"] doubleValue]) <= 0.0001) {
        return [array[2] objectForKey:@"name"];
    }
    
    if (fabs(location.latitude - [[array[3] objectForKey:@"lat"] doubleValue]) <= 0.0001 && fabs(location.longitude - [[array[3] objectForKey:@"lng"] doubleValue]) <= 0.0001) {
        return [array[3] objectForKey:@"name"];

    }
    
    return nil;
}
@end
