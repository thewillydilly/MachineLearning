Welcome to the manual worm identifier(MLP5SetDev)

This program will load images from your "WormData" file and then extract subimages for you to classify.
Before each set of data the master image will be shown, make sure your coursor is in the command window of matlab and press enter.
You will now be shown a series of images and be prompted in the command window to enter how many worms are in the image. This should be an integer.
Type the number in the command window and press enter. The program will continue in this manner until all sets are complete (with some exceptions).
This process should take between 2 to 3 hours. After you are done please send the results (Images folder and maptX.mat) back to me and I will concatonate the results.
Happy Identifying.

Scott Watkins
214-641-8384
scott.watkins@ttu.edu

Exception cases:
Sometimes at the end of a set the program will need to check if you have entered the correct value as it cannot go back after moving forward from this spot. In this case type 'y' to continue. If you have made a mistake type 'n' and the image will be shown again for your input as well as asking for conformation again.

If you missclassify an image DO NOT PANIC. If you entered nothing or an invalid character the program will automatically revert to the image that was not classified and ask for your answer. If you entered an incorrect valid number (decimals are accepted in this version though I should fix this) DO NOT PANIC, enter 'r' into the next prompt asking for the number of worms and press enter. This will revert you to the last image you were shown for you to reclassify it. In the new prompt type the correct value and press enter.

NOTE:
Images shown to you will be magnified by 800% to make it easier to clasify.

I suggest moving the matlab program to one side of the screen and alowing the image figures to generate on the other side of the screen.