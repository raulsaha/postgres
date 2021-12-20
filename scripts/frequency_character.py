def print_nth_string(s) :
  
    i = 0
    while( i < len(s) - 1) :

        # Counting occurrences of s[i]
        count = 1

        while s[i] == s[i + 1] :

            i += 1
            count += 1

            if i + 1 == len(s):
                break

        print(str(s[i]) + str(count), end = "")
        
        i += 1

    print()

# Main Code
if __name__ == "__main__" :

    #function 
    print_nth_string("500055")
