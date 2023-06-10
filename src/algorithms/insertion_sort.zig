const std = @import("std");
const debug_print = std.debug.print;

pub fn insertion_sort(comptime T: type, arr: []T) []T {
    const n = arr.len;
    var i: usize = 1;
    while (i < n) {
        var j = i;
        while (j > 0 and arr[j] < arr[j - 1]) {
            const temp = arr[j];
            arr[j] = arr[j - 1];
            arr[j - 1] = temp;
            j -= 1;
        }
        i += 1;
    }
    return arr;
}

test "it should sort the array" {
    var arr = [_]i8{ 4, 1, 6, 21, 3 };
    const sorted_arr = [_]i8{ 1, 3, 4, 6, 21 };
    const new_arr = insertion_sort(i8, &arr);
    for (0..arr.len) |i| {
        try std.testing.expect(new_arr[i] == sorted_arr[i]);
    }
}
