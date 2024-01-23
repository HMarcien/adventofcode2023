#! /usr/bin/gawk -f

function get_win_list(record) {
    match(record, /Card [0-9]+: (.+) \|/, w_list)
    split(w_list[1], win_list);
    for (num in win_list)
        wlist[win_list[num]] = win_list[num];
}

function get_hold_list(record) {
    match(record, /\| (.+)/, h_list);
    split(h_list[1], hold_list);
}

BEGIN {
    total_point = 0;
}

{
    split("", wlist);

    get_win_list($0);
    get_hold_list($0);
    record_match = 0;
    
    for (num in hold_list) {
        if (hold_list[num] in wlist) {
            record_match += 1;
        }
    }
    
    if (record_match > 0)
        total_point += (2 ^ (record_match - 1));
}

END {
    print total_point;
}
