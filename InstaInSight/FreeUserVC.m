//
//  FreeUserVC.m
//  InstaInSight
//
//  Created by Verma Mukesh on 17/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import "FreeUserVC.h"
#import "NewFollowerVC.h"
#import "NewFollowingVC.h"

@interface FreeUserVC ()

@end

@implementation FreeUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [lblName setText:[[[InstaUser sharedUserInstance] objInstaUser] username]];
    [lblFollowerCount setText:[NSString stringWithFormat:@"%li",[[[InstaUser sharedUserInstance] objInstaUser] followsCount]]];
    [lblFollowingCount setText:[NSString stringWithFormat:@"%li",[[[InstaUser sharedUserInstance] objInstaUser] followedByCount]]];
    
    [imgProfileView sd_setImageWithURL:[[[InstaUser sharedUserInstance] objInstaUser] profilePictureURL] placeholderImage:[UIImage imageNamed:@"profilePlaceHolder"]];
    [tblFreeUser setTableHeaderView:headerView];
    
    arrRowData=[[NSMutableArray alloc] initWithObjects:
        [NSDictionary dictionaryWithObjectsAndKeys:@"New Followers",@"title",@"NewFollowers",@"imgName", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"New Following",@"title",@"NewFollowers",@"imgName", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"Not Following back",@"title",@"NewFollowers",@"imgName", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"I am not Following back",@"title",@"NewFollowers",@"imgName", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"Likes Graph",@"title",@"NewFollowers",@"imgName", nil],
                
                nil];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [[imgProfileView layer] setCornerRadius:imgProfileView.frame.size.width/2];
    [imgProfileView setClipsToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrRowData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"featureCell"];
    NSDictionary *diccData=[arrRowData objectAtIndex:indexPath.row];
    [cell.imageView setImage:[UIImage imageNamed:[diccData objectForKey:@"imgName"]]];
    [cell.textLabel setText:[diccData objectForKey:@"title"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            NewFollowerVC *objScr=[self.storyboard instantiateViewControllerWithIdentifier:@"NewFollowerVC"];
            [self.navigationController pushViewController:objScr animated:YES];
        }
           
            break;
        case 1:
        {
            NewFollowerVC *objScr=[self.storyboard instantiateViewControllerWithIdentifier:@"NewFollowingVC"];
            [self.navigationController pushViewController:objScr animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
