# Stratosphere FMC System Documentation
## Basic Information
The FMS used by the Stratosphere 777 is based on mSparks's Sparky744 FMS. The basic FMS code was kept and modified slightly for our use, and some pages were based on the 744 pages but converted for the 777.

## Modifying the FMS

### Creating basic page
Making FMS pages themselves is quite straightforward. To create a blank page, create a new lua file for it in the xtlua/scripts/B777.20.xt.fms/activepages folder. A blank page template can be found in the aircraft project files folder. In short, each page is a function that returns the data to display on the screen. The displayed data must be exactly 13 lines, and for best appearance on the 777's displays, should be 24 characters wide. Here is an example of a basic FMS page

```lua
fmsPages["PAGE_NAME"]=createPage("PAGE_NAME")
fmsPages["PAGE_NAME"].getPage=function(self,pgNo,fmsID)

    return { 
        "            MENU            ",
        "                            ",
        "<FMC    <ACT>        SELECT>",
        "                            ",
        "                     SELECT>",
        "                            ",
        "<SAT                        ",
        "                            ",
        "                            "
        "                            ",
        "<ACMS                       ",
        "                            ",
        "<CMC                 SELECT>"
    
    }
end
```

Replace all instances of `PAGE_NAME` with the name of your page. Make sure they identical!

# PUT DOFILE HERE

### Using multiple pages
Some pages may be multiple pages long. In order to use the NEXT PAGE and PREV PAGE CDU buttons, you need to do a few extra steps. In order to take advantage of more pages, simply use an `if..elseif` statement like so.
```lua
fmsPages["PAGE_NAME"]=createPage("PAGE_NAME")
fmsPages["PAGE_NAME"].getPage=function(self,pgNo,fmsID)
    if pgNo == 1 then
        return { 
            "            MENU            ",
            "                            ",
            "<FMC    <ACT>        SELECT>",
            "                            ",
            "                     SELECT>",
            "                            ",
            "<SAT                        ",
            "                            ",
            "                            ",
            "                            ",
            "<ACMS                       ",
            "                            ",
            "<CMC                 SELECT>"
        }
    elseif pgNo == 2 then
        return { 
            "WHATEVER IS ON SECOND PAGE  ",
            "                            ",
            "                            ",
            "                            ",
            "                            ",
            "                            ",
            "                            ",
            "                            ",
            "                            "
            "                            ",
            "                            ",
            "                            ",
            "                            "
        }
    end
end
```
Next, you need to define the number of pages you have. Do this by using this function at the end of your script:
```lua
fmsPages["PAGE_NAME"].getNumPages=function(self)
  return number_of_pages
end
```
Make sure `PAGE_NAME` is the same as before, and replace `number_of_pages` with the number of pages in integer format.

### Small text
Many FMC pages have both a large and small font present. The code above uses the large font. to Use the small font, use the code below. If on multiple pages, a `pgNo` if statement needs to be used on the small pages as well as the large ones. Note small pages are the same size as large ones but with a smaller font.

```lua
fmsPages["PAGE_NAME"].getSmallPage=function(self,pgNo,fmsID)
	return {
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		}
  end
```
Remember to make `PAGE_NAME` the same as on the large pages. 

### Making pages dynamic
Some pages have data that changes, or options that only appear in certian circumstances. This can be done by using variables to hold that line (or portion of a line), and setting those variables depending on the conditions. In the example below, the text on the page will change depending on whether the aircraft is on the ground. Note this is all inside the page function and `pgNo` if statement if present. These can also be used in the small page.

```lua
local line1 = ""

if simDR_onGround == 1 then
    line1 = "ON THE GROUND"
else
    line1 = "NOT ON GROUND"
end

return { 
    line1, -- will display either "ON THE GROUND" or "NOT ON GROUND"
    "                            ",
    "                            ",
    "                            ",
    "ONGROUND DATAREF: " .. simDR_onGround, -- this will display "ONGROUND DATAREF: 0" or 1.
    "                            ",
    "                            ",
    "                            ",
    "                            "
    "                            ",
    "                            ",
    "                            ",
    "                            "
}
```

Notice the comma placement.

### Using datarefs
But where did the dataref `simDR_onGround` come from? To access a dataref, it must be found by using the `find_dataref("dataref_name")` function to assign the dataref to a variable. Call this function in the designated area in `xtlua/scripts/B777.20.xt.fms/B777.20.xt.fms.lua`. For example, finding the onGround dataref looks like this:
```lua
simDR_onGround = find_dataref("sim/flightmodel/failures/onground_any")
```
I can then read/write (although in this case onGround is a read only dataref) the dataref using the variable I made, in this case `simDR_onGround`. The same process applies for custom datarefs made in other modules or plugins.

Creating datarefs is a bit tricker. This is done by calling the function `deferred_dataref("name", "type")`. The type can be either `number`, `string`, or `array[size]`.
For example:
```lua
my_dataref = deferred_dataref("Strato/777/my_dataref", "array[10]")
```
All created datarefs and commands must also be created in the init folder. i.e. the line above must not only be in `xtlua/scripts/B777.20.xt.fms/B777.20.xt.fms.lua` but it must ALSO be in `xtlua/init/scripts/B777.20.fms/B777.20.fms.lua`.

### Using line select keys

### Using commands

### Scratchpad entries