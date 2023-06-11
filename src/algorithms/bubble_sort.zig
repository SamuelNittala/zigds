const std = @import("std");
const debug_print = std.debug.print;

pub fn bubble_sort(comptime T: type, arr: []T) []T {
    const n = arr.len;
    for (0..n - 1) |i| {
        for (0..n - i - 1) |j| {
            if (arr[j] > arr[j + 1]) {
                const temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
    return arr;
}

test "it should sort the array" {
    var arr = [_]i8{ 5, 4, 3, 2, 1 };
    const sorted_arr = [_]i8{ 1, 2, 3, 4, 5 };
    const new_arr = bubble_sort(i8, &arr);
    for (0..arr.len) |i| {
        try std.testing.expect(new_arr[i] == sorted_arr[i]);
    }
}
