const std = @import("std");
const dpp = std.debug.print;

pub fn create2DArray(allocator: *const std.mem.Allocator, row_len: usize, column_len: usize, fill: i32) ![][]i32 {
    const array = try allocator.alloc([]i32, row_len);
    for (0..row_len) |i| {
        const column = try allocator.alloc(i32, column_len);
        for (0..column_len) |ind| {
            column[ind] = fill;
        }
        array[i] = column;
    }
    return array;
}

pub fn maxProfit(index: usize, dp_arr: *const [][]i32, prices: [6]i32, fee: i32, buy_flag: i32) !i32 {
    if (index == prices.len) return 0;
    var dp = dp_arr.*;
    if (dp[index][@intCast(usize, buy_flag)] != -1) return dp[index][@intCast(usize, buy_flag)];
    if (@intCast(usize, buy_flag) == 1) {
        const buy = -prices[index] - fee + try maxProfit(index + 1, dp_arr, prices, fee, 0);
        const dont_buy = try maxProfit(index + 1, dp_arr, prices, fee, 1);
        if (buy > dont_buy) {
            dp[index][@intCast(usize, buy_flag)] = buy;
        } else {
            dp[index][@intCast(usize, buy_flag)] = dont_buy;
        }
    } else {
        const sell = prices[index] + try maxProfit(index + 1, dp_arr, prices, fee, 1);
        const dont_sell = try maxProfit(index + 1, dp_arr, prices, fee, 0);
        if (sell > dont_sell) {
            dp[index][@intCast(usize, buy_flag)] = sell;
        } else {
            dp[index][@intCast(usize, buy_flag)] = dont_sell;
        }
    }
    return dp[index][@intCast(usize, buy_flag)];
}

pub fn maxProfitTabulation(allocator: *const std.mem.Allocator, prices: [6]i32, fee: i32) !i32 {
    const dp = try create2DArray(allocator, prices.len + 1, 2, 0);
    var ind = prices.len - 1;
    while (ind >= 0) {
        for (0..2) |buy_flag| {
            const buy_flag_usize = @intCast(usize, buy_flag);
            if (buy_flag_usize == 1) {
                const buy = -prices[ind] - fee + dp[ind + 1][0];
                const dont_buy = dp[ind + 1][1];
                dp[ind][buy_flag_usize] = std.math.max(buy, dont_buy);
            } else {
                const sell = prices[ind] + dp[ind + 1][1];
                const dont_sell = dp[ind + 1][0];
                dp[ind][buy_flag_usize] = std.math.max(sell, dont_sell);
            }
        }
        if (ind == 0) break;
        ind -= 1;
    }
    return dp[0][1];
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const dp_arr = try create2DArray(&allocator, 6, 2, -1);
    const prices = [_]i32{ 1, 3, 2, 8, 4, 9 };
    const res = try maxProfit(0, &dp_arr, prices, 2, 1);
    _ = res;
    const res_tab = try maxProfitTabulation(&allocator, prices, 2);
    dpp("{}\n", .{res_tab});
}
