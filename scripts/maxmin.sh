#!/bin/sh
#set -x

read -p "Enter the numbers to find out min and max value separated by 'space' : " number

for i in ${number[@]}
do
   echo ""
   echo "The entered number are :" $i
   echo ""
done

echo ${number[@]}
SERIES=${number[@]}
echo $SERIES

number1=(`echo $SERIES`) 

#If we want to enter number manually
#arrayName=(1 2 3 4 5 6 7)

# Finding out min & Max
max=${number1[0]}
min=${number1[0]}

# Loop through all elements in the array
for i in "${number1[@]}"
do
    # Update max if applicable
    if [[ "$i" -gt "$max" ]]; then
        max="$i"
    fi

    # Update min if applicable
    if [[ "$i" -lt "$min" ]]; then
        min="$i"
    fi
done

# Output results:
echo "Max Value is: $max"
echo "Min Value is: $min"
