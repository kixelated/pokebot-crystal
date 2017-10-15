mod emulator;
mod gfx;

fn main() {
    let mut emu = emulator::new();
    emu.load("rom/crystal.gbc").unwrap();

    let mut window = gfx::Window::new();

    loop {
        let quit = window.run(&mut emu);
        if quit { return }
    }
}
