const std = @import("std");

const expect = std.testing.expect;

const Window = opaque {};
const Button = opaque {};

extern fn show_window(*Window) callconv(.C) void;

test "opaque" {
    const main_window: *Window = undefined;
    show_window(main_window);

    // const ok_button: *Button = undefined;
    // show_window(ok_button);
}

const WindowD = opaque {
    fn show(self: *WindowD) void {
        show_windowD(self);
    }
};

extern fn show_windowD(*WindowD) callconv(.C) void;

test "opaque with declarations" {
    const main_window: *WindowD = undefined;
    main_window.show();
}
