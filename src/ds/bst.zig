const std = @import("std");
const x = std.SinglyLinkedList(i32);
const dp = std.debug.print;

pub fn BinarySearchTree(comptime T: type) type {
    return struct {
        const Self = @This();

        pub const Node = struct {
            left: ?*Node = null,
            right: ?*Node = null,
            data: T,

            pub fn _inorder(node: ?*Node) void {
                if (node) |valid_node| {
                    _inorder(valid_node.left);
                    dp("{}\n", .{valid_node.data});
                    _inorder(valid_node.right);
                }
            }

            pub fn _postOrder(node: ?*Node) void {
                if (node) |valid_node| {
                    _postOrder(valid_node.left);
                    _postOrder(valid_node.right);
                    dp("{}\n", .{valid_node.data});
                }
            }

            pub fn _preOrder(node: ?*Node) void {
                if (node) |valid_node| {
                    dp("{}\n", .{valid_node.data});
                    _preOrder(valid_node.left);
                    _preOrder(valid_node.right);
                }
            }
        };
        root: ?*Node = null,
        pub fn insertNode(bst: *Self, new_node: *Node) void {
            const new_val = new_node.data;
            var root_node = bst.root;
            if (root_node) |*rn| {
                // loop invariant
                // 1. at depth i, all the values at (i+1) left sub tree must be less than or equal to node value or a null node.
                // 2. at depth i, all the values at (i+1) right sub tree must be greater than node value or a null node
                while (rn.*.left != null and rn.*.right != null) {
                    if (new_val <= rn.*.data) {
                        if (rn.*.left) |rn_left| {
                            // depth += 1
                            rn.* = rn_left;
                        }
                    } else {
                        if (rn.*.right) |rn_right| {
                            // depth += 1
                            rn.* = rn_right;
                        }
                    }
                }
                if (rn.*.left == null) {
                    rn.*.left = new_node;
                } else {
                    rn.*.right = new_node;
                }
            } else {
                bst.root = new_node;
            }
        }
        pub fn inorder(bst: *Self) void {
            if (bst.root) |rn| {
                dp("{s}\n", .{"inorder called"});
                rn._inorder();
            }
        }
        pub fn postOrder(bst: *Self) void {
            if (bst.root) |rn| {
                dp("{s}\n", .{"post-order called"});
                rn._postOrder();
            }
        }
        pub fn preOrder(bst: *Self) void {
            if (bst.root) |rn| {
                dp("{s}\n", .{"pre-order called"});
                rn._preOrder();
            }
        }
    };
}

const i32_bst = BinarySearchTree(i32);

pub fn main() !void {
    var bst = i32_bst{};

    var head = i32_bst.Node{ .left = null, .right = null, .data = 14 };
    var one = i32_bst.Node{ .left = null, .right = null, .data = 4 };
    var two = i32_bst.Node{ .left = null, .right = null, .data = 24 };
    var three = i32_bst.Node{ .left = null, .right = null, .data = 2 };

    bst.insertNode(&head);
    bst.insertNode(&one);
    bst.insertNode(&two);
    bst.insertNode(&three);

    bst.inorder();
    bst.postOrder();
    bst.preOrder();
}
