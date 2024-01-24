#! /usr/bin/gawk -f

function get_win_list(record) {
    match(record, /Card\s+[0-9]+:\s+(.+) \|/, w_list)
    split(w_list[1], win_list);
    for (num in win_list)
        wlist[win_list[num]] = win_list[num];
}

function get_hold_list(record) {
    match(record, /\|\s+(.+)/, h_list);
    split(h_list[1], hold_list);
}

function print_list(list) {
    str = "";
    for (el in list) {
        str = (str " " list[el])
    }
    print str
}

BEGIN {
    total_point = 0;
}

{
    split("", wlist);

    get_win_list($0);
    
    get_hold_list($0);
    
    winners = 0;
    
    for (num in hold_list) {
        if (hold_list[num] in wlist) {
            winners += 1;
        }
    }
    
    if (winners > 0)
        total_point += (2 ^ (winners - 1));
}

END {
    print total_point;
}
