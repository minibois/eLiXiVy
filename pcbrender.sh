#!/bin/sh

###########
# Written by ebastler/Moritz Plattner in 2021.
# Shell script to use the tracespace-cli application and inkscape in order to create PNG renders of a gerber folder.
# It will prompt for a soldermask color (default = black),  silkscreen color (default = white) and resolution (default = 300dpi, well suited for keyboard-sized PCBs)

colorListSM=("black" "white" "red" "blue" "purple" "green" "custom")
colorRGBSM=("00,00,00" "255,255,255" "180,10,10" "00,00,128" "75,0,130" "0,66,0" "00,00,00")
colorAlphaSM=0.75

colorListSS=("white" "black" "custom")
colorRGBSS=("255,255,255" "00,00,00" "255,255,255")

# Config: color codes for various parts of the output.
shColText='\033[0m'           # Color of the text written in prompts
shColVar='\033[0;37m'         # Color of brackets around the prompt numbers
shColNumbers='\033[38;5;45m'  # Color of the prompt numbers
shColDefault='\033[0m'        # Resets the output color to the terminal default

# This function asks the user to enter a valid RGB color code, and re-prompts until the input meets all conditions
RGBinput()
{
    read -p 'You selected using a custom color. Enter the desired RGB values (example for red: 128,0,0): ' inputColor
    
    regexRGB="^(([0-1]?[0-9]?[0-9]?|2[0-4][0-9]|25[0-5]),){2}([0-1]?[0-9]?[0-9]?|2[0-4][0-9]|25[0-5]){1}$"
    until echo "$inputColor" | grep -qE "$regexRGB"
    do
        read -p 'Invalid color. Please use only 3 values between 0 and 255, separated by ",". Enter the desired RGB values (example for red: 128,0,0): ' inputColor
    done
    echo $inputColor
}

# This function prints a list of all entries of an array passed to it
OptionPrint()
{
    optionList=("$@")
    for (( i=0; i<${#optionList[@]}; i++))
    do
        printf '%b[%b%s%b]%b %s %b\n' $shColVar $shColNumbers $(($i+1)) $shColVar $shColText ${optionList[i]} $shColDefault
    done
    printf '\n'
}

# This function reads a user input (number) and checks if it is within the options of a given array
OptionChoice()
{
    optionList=("$@")
    read -p "Input: " colorChoice
    # Default to 1 if no choice is made
    colorChoice="${colorChoice:=1}"
    colorChoice=$(($colorChoice-1)) # Arrays begin at 0, the selector begins at 1 for easier use

    # Check if the color choice is within the list of options, otherwise default to 0
    if (( $colorChoice < 0 || $colorChoice > ${#optionList[@]}-1 ))
    then
        colorChoice=0
    fi
    echo $colorChoice
}

# Print the list of available soldermask colors to the shell and poll for user input
printf 'Choose a soldermask color (empty prompt = black). List of choices:\n'
OptionPrint ${colorListSM[@]}
colorChoiceSM=$(OptionChoice ${colorListSM[@]})

# If the choice is the last element in the array (custom), ask for RGB values to assign to the array element
# Perform a regex check to see if a valid RGB value has been used
if (( $colorChoiceSM == ${#colorListSM[@]}-1))
then
    colorRGBSM[$colorChoiceSM]=$(RGBinput)
fi

# print the list of available silkscreen colors to the shell and poll for user input
printf 'Choose a silkscreen color (empty prompt = white). List of choices:\n'
OptionPrint ${colorListSS[@]}
colorChoiceSS=$(OptionChoice ${colorListSS[@]})

# If the choice is the last element in the array (custom), ask for RGB values to assign to the array element
# Perform a regex check to see if a valid RGB value has been used
if (( $colorChoiceSS == ${#colorListSS[@]}-1))
then
    colorRGBSS[$colorChoiceSS]=$(RGBinput)
fi

# Ask for DPI
read -p "Choose the target DPI of the png. Default is 300, for small PCBs you should choose a higher value: " pngDPI
# Default to 300 if not set
pngDPI="${pngDPI:=300}"

printf 'Rendering images with color %s (R,G,B: %s, Alpha: %s) in %s dpi\n' ${colorListSM[$colorChoiceSM]} ${colorRGBSM[$colorChoiceSM]} $colorAlphaSM $pngDPI

rm *.png
# Call tracespace cli with color and alpha from variables
# The -L parameter specifies that only the complete PCB should be rendered
tracespace -L --quiet -b.color.sm="rgba(${colorRGBSM[$colorChoiceSM]},$colorAlphaSM)" -b.color.ss="rgb(${colorRGBSS[$colorChoiceSS]})" *
# Use find to get a list of all .svg, pass them as parameters to a subshell which calls inkscape
# The DPI are passed as the first parameter, filenames as second
find -name "*.svg" -exec sh -c 'tempVar=$1; inkscape $2 --export-dpi=$tempVar --export-png=${2%.svg}.png' _ $pngDPI {} \; 
rm *.svg

exit 0