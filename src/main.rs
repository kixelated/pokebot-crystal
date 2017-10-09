mod emulator;
extern crate sdl2;

fn main() {
    let sdl_context = sdl2::init().unwrap();
    let video_subsystem = sdl_context.video().unwrap();

    let window = video_subsystem.window("Pokemon Rust", 320, 288).build().unwrap();

    let mut canvas = window.into_canvas().software().build().unwrap();
    let texture_creator = canvas.texture_creator();

    let mut texture = texture_creator.create_texture_streaming(sdl2::pixels::PixelFormatEnum::ARGB8888, 160, 144).unwrap();

    let emu = emulator::new();
    emu.load("rom/crystal.gbc").unwrap();

    let mut video: [u8; 160*144*4] = [0; 160*144*4];
    let mut audio: [u8; (35112+2064)*4] = [0; (35112+2064)*4];

    loop {
        emu.run(&mut video, &mut audio);

        texture.update(None, &video, 160*4).unwrap();
        canvas.copy(&texture, None, None).unwrap();
        canvas.present();
    }
}
