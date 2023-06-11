const std = @import("std");

fn merge(comptime T: type, arr: []T, left: usize, mid: usize, right: usize) !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const temp = try allocator.alloc(T, arr.len);

    var i = left;
    var j = mid;
    var k = left;

    while (i < mid and j < right) {
        if (arr[i] <= arr[j]) {
            temp[k] = arr[i];
            i += 1;
        } else {
            temp[k] = arr[j];
            j += 1;
        }
        k += 1;
    }

    while (i < mid) {
        temp[k] = arr[i];
        i += 1;
        k += 1;
    }

    while (j < right) {
        temp[k] = arr[j];
        j += 1;
        k += 1;
    }

    for (left..right) |ix| {
        arr[ix] = temp[ix];
    }
}

fn mergeSort(comptime T: type, arr: []T, left: usize, right: usize) !void {
    if (right - left > 1) {
        const mid = left + (right - left) / 2;
        try mergeSort(T, arr, left, mid);
        try mergeSort(T, arr, mid, right);
        try merge(T, arr, left, mid, right);
    }
}

pub fn main() !void {
    var arr = [_]i32{ 9, 7, 5, 11, 12, 2, 14, 3, 10, 6 };
    try mergeSort(i32, arr[0..], 0, arr.len);
    for (arr) |val| {
        std.debug.print("{} ", .{val});
    }
}
