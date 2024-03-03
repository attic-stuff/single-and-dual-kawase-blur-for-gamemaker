# kawase blur in both single and dual filter flavors

## what is a kawase blur, my dude?
kawase blur is an efficient way to ~~fake~~ approximate a gaussian blur by sneakin' a grip of texture samples over hardware texture filtering (gpu tex filter in gml). in gamemaker terms this means its a very fast blur that gives results that are close enough to a real gaussian filter that anyone who notices that its not gaussian probably has robotoeyes or is a top notch jraphics programmer. its a very fast, bandwidth efficient filter for when you want to do a bloom or a depth of field or hide your face during a crime and cannot afford a full blown blur.

originally the method was developed by masaki kawase and [presented](https://web.archive.org/web/20190324074351/https://genderi.org/frame-buffer-postprocessing-effects-in-double-s-t-e-a-l-wreckl.html) in a 2003 GDC talk, and the dual filtering method was [introduced](https://community.arm.com/cfs-file/__key/communityserver-blogs-components-weblogfiles/00-00-00-20-66/siggraph2015_2D00_mmg_2D00_marius_2D00_notes.pdf) at siggraph 2015 by a homie named marius bjørge.

## how does it work
most blurring works the same way: the current pixel's color is based on the average value of the colors of its neighboring pixels. to average that color, we usually go "okay the pixel to the right is red and the pixel to the left is black, red + black is red because black is zero, divided by two because we sampled two pixels gives us a final result of half red. effectively meaning that the current pixel's color maths out like this: (1 + 0) / 2 = 0.5. that process of getting the average color is what blurs the image, and there are a few ways to choose the neighbors. you might choose them in a radial pattern, in a straight up box, or in a gaussian window. a lot of the time you will do this multiple times to make things extra fuzzy. each of these methods have their own pros and cons and costs.

so there is the kawase blur! its method of getting the average color begins by turning on hardware filtering, then for each pixel, the corners of four neighboring pixels are sampled. since the sample is taken in the corner, and hardware filtering is enabled, this is the same as sampling four pixels in one [spot](https://en.wikipedia.org/wiki/Four_Corners). by using this trick, the blur is made by turning the color of the current pixel into the average color of its sixteen neighbors. by doing this across multiple passes, which is called ping-ponging, you can spread the blur out to make it nice and blurry without artifacts. i made this gif to illustrate how it works:

![how this works](https://github.com/attic-stuff/single-and-dual-kawase-blur-for-gamemaker/blob/master/kawaseblur.gif)

it begins with a single pixel in a grid of pixels. the red square is our current pixel, and the eggshell squares are all the other pixels. in the first pass, the color at each blue dot is sampled, and since it is in the corner of each neighbor then the color of the red pixel becomes the average color of every pixel within the yellow area. then we move to the second pass, which samples four groups of pixels a little further out. so now the color of our red pixel is the average color of everything in yellow. on a third pass we move our samples further out again, adding even more colors to our red pixel. each pass adds its average colors to the current pixel.

# what is a dual filter?
the regular kawase blur is done as a classic ping pong: it applies the blur to each pass without altering the resolution of the samples. the dual filter is a little bit different in that it downsamples the resolution of the where the samples are made over each pass, and then does an equal number of passes where the samples are made on the already blurred stuff but at upscaled resolutions. this basically means that the dual filter breaks the picture down while blurring it, then puts it back together while making it bigger. this gives us results pretty results even cheaper than the single filter!

# which should i use?
while this repo contains an example of and code for both single and dual filter blurs, you will generally want to use the dual filter in pretty much all occasions as it is the most efficient one to work with. trying to find good, constant smudge distances for the single filter is also kind of a pain and will give you different results based on the size of whats being blurred and all that.

# how do i use the dual filter?
there is an example yyp included here for you to take a look at, that sort of walks you through setting it up. everything works as pinging and ponging. to set it up you will need to initialize a stack of surfaces using the function ``kawase_dual_filter_create_stack(n)`` where n is how many passes you wish the blur to make. this doesnt need to be an even number, the function is smart enough to know how to do an equal number of upscales as downscales, hooray! the 0th index of the array should hold the contents you wish to blur; this can be the app surface, another surface, or you can make it into a surface and draw stuff to it directly like the example. you will need to begin the process with ``kawase_dual_filter_begin``, process the blur with ``kawase_dual_filter_process``, and draw it with ``kawase_dual_filter_render``. don't forget to call the clean function to remove surfaces from vram before you end up with a leak. there is an example of how to blur the entire application surface included as well, you just need to change the home room to that room.

# dual filter functions
| kawase_dual_filter_create_stack(passes)                      |
| :----------------------------------------------------------- |
| this is a helper function to create a stack with the correct number of indices for a dual filter kawase blur. it returns an array. index 0 is what your content will be on. |
| **passes**: the number of passes this blur will make         |

| kawase_dual_filter_begin(stack, [spread])                    |
| :----------------------------------------------------------- |
| begins the blurring process by doing the first downsample    |
| **stack**: the stack of surfaces to be blurred.<br />**spread**: the smudge factor of the blur. for a tasteful blur just leave this as 1, for a nightmare crank it up to like 4 or 5. |

| kawase_dual_filter_process(stack, [spread])                  |
| :----------------------------------------------------------- |
| does the rest of the blurring                                |
| **stack**: the stack of surfaces to be blurred.<br />**spread**: the smudge factor of the blur. for a tasteful blur just leave this as 1, for a nightmare crank it up to like 4 or 5. |

| kawase_dual_filter_render(stack, x, y)                       |
| :----------------------------------------------------------- |
| draws the final, blurred surface at the same resolution as the content surface. |
| **stack**: the stack of surfaces to be blurred.<br />**x**: the x position to draw the final surface.<br />**y**: the y position to draw the final surface. |

| kawase_dual_filter_clean(stack)                              |
| :----------------------------------------------------------- |
| surfaces are dynamic and we want them gone before they memory leak all over the place. |
| **stack**: the stack of surfaces to be yeeted.               |



# license
go nuts just leave me out of it. you can use the gml and the shader code in any project you want, without attribution, but please try to link to kawase and bjørge. you may not use the artwork for font in this project for anything ever.