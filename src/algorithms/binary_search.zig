const std = @import("std");
const debug_print = std.debug.print;

pub fn binary_search(comptime T: type, array: []const T, key: T, left: usize, right: usize) bool {
    if (right >= left) {
        var mid = left + (right - left) / 2;
        var mid_value = array[mid];
        if (mid_value == key) {
            return true;
        }
        if (mid_value > key) {
            return binary_search(T, array, key, left, mid - 1);
        }
        return binary_search(T, array, key, mid + 1, right);
    }
    return false;
}

test "should return true if element is present in the array" {
    const arr = [_]u32{ 2, 4, 23, 44, 55 };
    const result = binary_search(u32, &arr, 55, 0, arr.len - 1);
    try std.testing.expect(result == true);
}

test "should return false if element is not present in the array" {
    const arr = [_]u32{ 2, 4, 23, 44, 55 };
    const result = binary_search(u32, &arr, 65, 0, arr.len - 1);
    try std.testing.expect(result == false);
}

test "should return true for the element at the end of the array" {
    const arr = [_]u32{ 2, 4, 23, 44, 55 };
    const end_ele = arr[arr.len - 1];
    const result = binary_search(u32, &arr, end_ele, 0, arr.len - 1);
    try std.testing.expect(result == true);
}

test "should return true for a character present in a sorted string" {
    const test_str = "abcdef";
    const char: []const u8 = "d";
    const result = binary_search(@TypeOf(test_str[0]), test_str, char[0], 0, test_str.len - 1);
    try std.testing.expect(result == true);
}
