#! /opt/homebrew/bin/gawk -f

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
    print sum;

    # Jour 3 - Partie 2

    # print total;
}
