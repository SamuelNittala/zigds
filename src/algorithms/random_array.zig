const std = @import("std");
const dp = std.debug.print;

// get a random int | float | boolean
pub fn generateRandomValue(comptime T: type) !T {
    var prng = std.rand.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.os.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    const rand = prng.random();
    switch (@typeInfo(T)) {
        .ComptimeInt, .Int => {
            return rand.int(T);
        },
        .ComptimeFloat, .Float => {
            return rand.float(T);
        },
        .Bool => {
            return rand.boolean();
        },
        else => @compileError("type not supported"),
    }
}

pub fn Array(comptime T: type) type {
    return struct {
        const Self = @This();
        array: []T = undefined,
        pub fn randomize(self: *Self, allocator: *const std.mem.Allocator, size: usize) ![]T {
            self.array = try allocator.alloc(T, size);
            errdefer allocator.free(self.array);
            for (0..size) |i| {
                self.array[i] = try generateRandomValue(T);
            }
            return self.array;
        }
        pub fn getMinFromArray(self: *Self) T {
            const array = self.array;
            var current_min = array[0];
            var i: usize = 1;
            while (i < array.len) {
                if (array[i] < current_min) {
                    current_min = array[i];
                }
                i += 1;
            }
            return current_min;
        }
        pub fn getMaxFromArray(self: *Self) T {
            const array = self.array;
            var current_max = array[0];
            var i: usize = 1;
            while (i < array.len) {
                if (array[i] > current_max) {
                    current_max = array[i];
                }
                i += 1;
            }
            return current_max;
        }
    };
}

const RANDOM_INT_ARRAY = Array(i8);
const RANDOM_FLOAT_ARRAY = Array(f32);
const RANDOM_BOOL_ARRAY = Array(bool);

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var random_array_one = RANDOM_INT_ARRAY{};
    var int_arry = try random_array_one.randomize(&allocator, 10);
    defer allocator.free(int_arry);

    var random_array_two = RANDOM_INT_ARRAY{};
    var int_arry_two = try random_array_two.randomize(&allocator, 10);
    defer allocator.free(int_arry_two);

    dp("{any}\n{any}\n", .{ random_array_one.getMinFromArray(), random_array_two.getMaxFromArray() });
}
