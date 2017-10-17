use emulator;
use gfx;

pub struct Game {
    window: gfx::Window,
    emu: emulator::Emulator,
}

impl Game {
    pub fn new() -> Game {
        let window = gfx::Window::new();
        let emu = emulator::Emulator::new();
        Game { window, emu }
    }

    pub fn load(&mut self, file: &str) -> Result<(), emulator::LoadError> {
        self.emu.load(file)
    }

    pub fn advance(&mut self) {
        let (video, audio) = self.emu.advance();
        self.window.present(video, audio);
    }

    pub fn press(&mut self, button: emulator::Button) {
        // TODO don't reset set_input in handle_events
        self.window.handle_events(&mut self.emu).unwrap();

        let input = self.emu.get_input() | button as u32;
        self.emu.set_input(input);
        self.advance();

        self.window.handle_events(&mut self.emu).unwrap();
        self.advance();
    }
}
