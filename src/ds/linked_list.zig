const std = @import("std");
const debug_print = std.debug.print;

const Node = struct {
    next: ?*Node,
    value: u32,
};

fn append_node(allocator: std.mem.Allocator, head: *Node, value: u32) !void {
    var temp_node = head;
    while (temp_node.next) |next_node| {
        temp_node = next_node;
    }
    var new_node = try allocator.create(Node);
    new_node.* = Node{
        .next = null,
        .value = value,
    };
    temp_node.next = new_node;
}

fn print_list(head: *Node) void {
    debug_print("{}\n", .{head.value});
    var temp_node = head.next;
    while (temp_node != null) {
        debug_print("{}\n", .{temp_node.?.value});
        temp_node = temp_node.?.next;
    }
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    var head = try allocator.create(Node);
    head.* = Node{
        .next = null,
        .value = 14,
    };
    try append_node(allocator, head, 15);
    try append_node(allocator, head, 16);
    try append_node(allocator, head, 17);
    print_list(head);
}
