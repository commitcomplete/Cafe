# Cafe! (2022/08/29 ~ 2022/09/01)

  <img src = "https://user-images.githubusercontent.com/72395020/188737151-4ed91cd8-5a1c-4870-9e10-e3b312c4b24d.png" width = "25%">

## Having fun with Big-Face Filter

[App store link](https://apps.apple.com/kr/app/big-face/id1642758195)

Big-Face is a Face Filter.
Automatically recognize faces and make it bigger.  
Also offers a lot of color filters and distort filters.

## Features

- Automatical face recognition
- Making face bigger
- Color filters - red, yellow, green, blue, purple
- Distort filters - Mosaic, Crystal, Convex1, Convex2, Circle
- Overlap filters between color filters and distort filters
- Capture Image

## ScreenShots
 <img src = "https://user-images.githubusercontent.com/72395020/188734836-22086a2f-333e-4e66-9675-479ecddf43d8.png" width = "19%"> <img src = "https://user-images.githubusercontent.com/72395020/188734884-a04d6dea-545c-4860-a2ea-6d28c73fc8b0.png" width = "19%"> <img src = "https://user-images.githubusercontent.com/72395020/188734914-05a5639e-6bdf-4f40-bab1-34840ffd08d6.png" width = "19%"> <img src = "https://user-images.githubusercontent.com/72395020/188736205-206852e2-0e70-4068-b748-1cc7dc849aca.png" width = "19%"> <img src = "https://user-images.githubusercontent.com/72395020/188736325-97533c2c-0e74-4448-865d-b739ace460dd.png" width = "19%">


## Tech

Big-Face takes reference from Apple Developer Documents to work properly:

- [UIKit] - Build interface
- [ARKit] - Face recognition
- [CoreImage] - CoreImageFilters
- [CoreImage.CIFilterBuiltins] - To use CoreImageFilters easily
- [AVFoundation] - To make capture sound and save view in album



## Problems

When first using color filters or distort filters, the size of filters adjust to square, which is not shape of real face.

There are two probable reasons.
1. The sequence of filters
-> Color filter or distort filter should be precede big face filter but it is not.
-> Change the sequence
2. The size of filters 
-> In the case of big face filter, size adjust to real face. but the others is not.(remain default - square)
-> Adjust the filter size
