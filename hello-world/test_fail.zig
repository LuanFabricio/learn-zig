const std = @import("std");
const expect = std.testing.expect;

test "Always fails" {
    try expect(false);
}
