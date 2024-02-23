# kawase blur in both single and dual filter flavors

citations:
- https://web.archive.org/web/20190324074351/https://genderi.org/frame-buffer-postprocessing-effects-in-double-s-t-e-a-l-wreckl.html
- https://www.intel.com/content/www/us/en/developer/articles/technical/an-investigation-of-fast-real-time-gpu-based-image-blur-algorithms.html
- https://community.arm.com/cfs-file/__key/communityserver-blogs-components-weblogfiles/00-00-00-20-66/siggraph2015_2D00_mmg_2D00_marius_2D00_notes.pdf

## what is a kawase blur, my dude?
kawase blur is an efficient way to fake a gaussian blur by sneakin' a grip of texture samples over hardware texture filtering (gpu tex filter in gml). in gamemaker terms this means its a very fast blur that gives results that are close enough to a real gaussian filter that anyone who notices that its not gaussian probably has robotoeyes or is a jraphics programmer. its a very fast, bandwidth efficient filter for when you want to do a bloom or a depth of field or hide your face during a crime and cannot afford a full blown blur.

originally the method was developed by masaki kawase and [presented](https://web.archive.org/web/20190324074351/https://genderi.org/frame-buffer-postprocessing-effects-in-double-s-t-e-a-l-wreckl.html) in a 2003 GDC talk and the dual filtering method was [introduced](https://community.arm.com/cfs-file/__key/communityserver-blogs-components-weblogfiles/00-00-00-20-66/siggraph2015_2D00_mmg_2D00_marius_2D00_notes.pdf) at siggraph 2015 by a homie named marius bjørge

## how does it work
all blurring works the same way: the current pixel's color is based on the average value of the colors of its neighboring pixels. to average that color, we usually go "okay the pixel to the right is red and the pixel to the left is black, red + black is red because black is zero, divided by two because we sampled two pixels gives us a final result of half red. effectively meaning that the curren pixel's color maths around town like this: 1 + 0 / 2 = 0.5. that process of getting the average color is what blurs the image, and there are a few ways to choose the neighbors. you might choose them in a radial pattern, in a straight up box, or in a gaussian window. a lot of the time you will do this multiple times to make things extra fuzzy. each of these methods have their own pros and cons.

so there is the kawase blur! its method of getting the average color begins by turning on hardware filtering, which does a tiny bit of blurring the source texture. then for each pixel, the corners of four neighboring pixels are sampled. since the sample is taken in the corner, and hardware filtering is enabled, this is the same as sampling four pixels in one [spot](https://en.wikipedia.org/wiki/Four_Corners). by using this trick, the blur is made by turning the color of the current pixel into the average color its sixteen neighbors. by doing this across multiple passes, which is called ping-ponging, you can spread the blur out to make it nice and blurry without blocky artifacts. i made this gif to illustrate how it works:

![how this works](https://github.com/attic-stuff/single-and-dual-kawase-blur-for-gamemaker/blob/master/kawaseblur.gif)

it begins with a single pixel in a grid of pixels. the red square is our current pixel, and the eggshell squares are all the other pixels. in the first pass, the color at each blue dot is sampled, and since it is in the corner of each neighbor then the color of the red pixel becomes the average color of every pixel within the yellow area. then we move to the second pass, which samples four groups of pixels a little further out. so now the color of our red pixel is the average color of everything in yellow. on a third pass we move further out again, adding even more colors to our red pixel.