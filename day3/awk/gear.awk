#! /usr/bin/gawk -f

function current_line_total_adjacent(pattern, target) {
    total = 0;
    while (match(target, pattern, arr)) {
        total += arr[1];
        target = substr(target, RSTART + RLENGTH);
    }
    return total;
}

function dot_replacement(string_length) {
    str = "";
    for (i = 0; i < string_length; i++) {
        str = str ".";
    }
    return str
}

function reverse_chaine(chaine) {
    result = "";
    while (length(chaine) != 0) {
        result = (substr(chaine, 0, 1) result);
        chaine = substr(chaine, 2);
    }
    return result;
}

function nb_other_left(chaine, position) {
    chaine = reverse_chaine(substr(chaine, 1, position));
    match(chaine, /([0-9]+)/, numbers);
    return reverse_chaine(numbers[1]);
}

function is_number(symbol) {
    match(symbol, /[0-9]+/);
    return RSTART;
}

function nb_other_right(chaine, position) {
    match(substr(chaine, position), /([0-9]+)/, numbers);

    return numbers[1];
}

function nb_left(chaine, sym, position) {
    if (is_number(sym)) {
        chaine = reverse_chaine(substr(chaine, 1, position));
        match(chaine, /([0-9]+)/, numbers);
        return reverse_chaine(numbers[1]);
    }
    return "";
}

function nb_rigth(chaine, sym, position) {
    if (is_number(sym)) {
        match(substr(chaine, position), /([0-9]+)/, numbers);
        return numbers[1];
    }
    return "";
}

function alength(arr) {
    nb = 0;
    for (el in arr){
        nb++;
    }
    return nb;
}

BEGIN {
    sum = total_ratio = 0;
}

{
    
    current = $0
    lines[NR] = $0;

    sum += current_line_total_adjacent(@/([0-9]+)[^0-9\.]+/, current);
    sum += current_line_total_adjacent(@/[^0-9\.]+([0-9]+)/, current);

}

END {
    # Jour 3 - Partie 1
    for (i in lines) {
        current = lines[i];
        previous = lines[i - 1];
        next_line = lines[i + 1];
        while(match(current, /([0-9]+)/, numbers)) {
            sub(numbers[1], dot_replacement(RLENGTH), current);
            top_adjacent = substr(previous, (RSTART - 1), (RLENGTH + 2));
            bottom_adjacent = substr(next_line, (RSTART - 1), (RLENGTH + 2));
            if (match(top_adjacent, /[^0-9\.]+/) || (match(bottom_adjacent, /[^0-9\.]+/))) {
                sum += numbers[1];
            }
         }
    }
    print "Sum of part numbers: " sum;

    # Jour 3 - Partie 2
    for (i in lines) {
        current = lines[i];
        previous_line = lines[i - 1];
        next_line = lines[i + 1];
        
        while(match(current, /\*/, symbols)) {
            sub("*", dot_replacement(RLENGTH), current);
            split("", numbers_ratio);

            star_start = RSTART;

            if(!is_number(substr(previous_line, star_start + 1, 1)) &&
               is_number(substr(previous_line, star_start - 1, 1))) {
                numbers_ratio["lt"] = nb_other_left(previous_line, star_start + 1);
            }

            if(is_number(substr(previous_line, star_start + 1, 1)) &&
               is_number(substr(previous_line, star_start - 1, 1))) {
                numbers_ratio["mt"] = nb_other_right(previous_line, star_start - 2);
            }
            
            if(!is_number(substr(previous_line, star_start - 1, 1)) &&
            is_number(substr(previous_line, star_start + 1, 1))) {
                numbers_ratio["rt"] = nb_other_right(previous_line, star_start - 1);
            }
            
            if(!is_number(substr(next_line, star_start + 1, 1)) &&
               is_number(substr(next_line, star_start - 1, 1))) {
                numbers_ratio["lb"] = nb_other_left(next_line, star_start + 1);
            }

            if(is_number(substr(next_line, star_start + 1, 1)) &&
               is_number(substr(next_line, star_start - 1, 1))) {
                numbers_ratio["mb"] = nb_other_right(next_line, star_start - 2);
            }
            
            if(!is_number(substr(next_line, star_start - 1, 1)) &&
            is_number(substr(next_line, star_start + 1,  1))) {
                numbers_ratio["rb"] = nb_other_right(next_line, star_start - 1);
            }
            
            pre_sym = substr(current, star_start - 1, 1);
            if(is_number(pre_sym)) {
                numbers_ratio["l"] = nb_left(current, pre_sym, star_start);
            }

            next_sym = substr(current, star_start + 1, 1);
            if(is_number(next_sym)) {
                numbers_ratio["r"] = nb_rigth(current, next_sym, star_start);
            }
            g_ratio = 1;
            if (alength(numbers_ratio) == 2) {
                for (el in numbers_ratio) {
                    g_ratio *= numbers_ratio[el];
                }
                total_ratio += g_ratio
            }
        }
    }
    print "Sum of gears ratio: " total_ratio;
}
