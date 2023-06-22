const std = @import("std");
const debug_print = std.debug.print;

//algo for moving n disks from start to end
//1. move top (n-1) disks from start to via-pole
//2. move nth disk from start to end
//3. move (n-1) disks from via-pole to end

// base-case:
//    -disk_count = 0

pub fn move_disk(disk_num: i32, start: i32, end: i32) void {
    debug_print("move disk-{} from {} to {}\n", .{ disk_num, start, end });
}

// move [count] number of disks from start-pole to end-pole
// using the via-pole

pub fn hanoi(start: i32, via: i32, end: i32, count: i32) void {
    if (count == 0) {
        return;
    }
    hanoi(start, end, via, count - 1);
    move_disk(count, start, end);
    hanoi(via, start, end, count - 1);
}

pub fn main() !void {
    hanoi(1, 2, 3, 11);
}
