#  Tabbar Animation Exploration

I am going to breakdown each indivudal step for creating a custom tabbar with a foldout subitem menu on clicking a button.

This effect is inspired by the follow dribble.
![Tabbar Exploration](https://cdn.dribbble.com/users/1405777/screenshots/5315582/video.gif "loop gif of the tabbar animation")
[Tabbar Exploration](https://dribbble.com/shots/5315582-Tabbar-Exploration) by Vlad Fedoseyev

Not only is this effect beautiful, this is also wonderful UX. Its bold "Plus" button directs the user to the next step in your apps Journey.

What stood out personally  for me about this effect was the discussion by the author in the feedback thread.

> ### 📝 **_TLDR:_**
> user1: good luck getting a development team to do it
> author: I can do it in couple of hours no biggy

![Developer responses](ReadmeImages/screenshot-developer-response.png "picture of developer responding to user comment")

I thought to myself;

> "Can you? other than the curved tabbar, I won't have a clue where to start..."

Not to be deterred by something as trivial as "I don't know how" I sought to figure out how to achieve the exact same tabbar in a swiftUI app. The original dribble shows a media focus app, I wanted to explore WWDC21 on device AI Training so I've created an app based on the concept around building AI Modules on device that could later be exported to xcode.

## Tabbar Exploration Breakdown
If we stare at the animation long enough we can easily breakdown the individual components and animations. 

1) The default tabbar has been replaced by a custom view, even in UIKit, the path rendering would have been a custom layer to achieve the 'dip' in the tabbar.
2) There is a second submenu that appears on click of the 'plus' button
3) There placement is equally displaced, the inner most icons have matching center Y points, and the outer icons Y center matches.
4) The main tabbar disappears when the second tabbar is to appear
5) The buttons of the second menu scale to full size during their interpolation to their positions.
6) Icons of the second buttons are not visible until the end of the animation, this gives the appearance of fluidity as the second tabbar 'bursts' into view
7) The plus button rotates clockwise
8) the plus button moves passed its original start position during its return and the moves to its start position
9) the plus button rotates the same amount for each animation(?)
10) The curve path is in the tabbar's center.
11) The curve path has its center point animated(?)
12) The curve path slightly goes pass its end point slightly before the animation ends

Now that we have the quintessential steps needed to recreate this afformentioned tabbar, lets first create the core componets and views that represent our app.
 
## Tabbar Walkthrough

### Creating a custom tabbar


## Animation Walkthrough
// We will write a custom Tab bar using two sources of truth, 
//
// ![Tabbar Exploration](https://cdn.dribbble.com/users/1405777/screenshots/5315582/video.gif)
// Kavsoft Curved Tabbar
// https://kavsoft.dev/SwiftUI_2.0/Native_Curved_Tabbar

// 1. First define a Home view, this is view containing a default TabView
// 2. Define your TabItems
// 3. Now hide them!

// 1. Create a HomeView with it's main content being a TabView.

//Animation Breakdown

when creating the animation for the new button, I had two states of the button to animate, the first being the offsetY and the rotation of the image. where I was able to animate the rotation quite easily as a views rotation angle is animatable by default. swiftUI will animate from one angle to the next for you. Ther problem surfaces when I wanted to animate the offset, changing the offset didn't work.

// Remaining Steps
- 1. Full write up for talk
