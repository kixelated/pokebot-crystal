mod emulator;
mod game;
mod gfx;

fn main() {
    let mut game = game::Game::new();

    game.load("rom/crystal.gbc").unwrap();

    loop {
        game.press(emulator::Button::Start);
    }
}
