// Basic top level imports
#import "Basic";
#import "GL";
#import "Window_Creation";
#import "Input";
#import "String";

// Named imports
Simp :: #import "Simp";
GetRect :: #import "GetRect";

// Local imports
#load "shaders.jai";
#load "camera.jai";
#load "text.jai";

// Shaders links
VERTEX_SHADER_PATH   : string = "../shaders/default.vert";
FRAGMENT_SHADER_PATH : string = "../shaders/default.frag";

// Engine consts
WINDOW_TITLE_BAR : string = "The Floor Is Lava";
WINDOW_WIDTH := 1024;
WINDOW_HEIGHT := 768;

// Engine variables
ENGINE_SHOULD_QUIT := false;
MAIN_ENGINE_WINDOW : *void;

handle_events :: (event: Event) {
  GetRect.getrect_handle_event(event);

  if event.type == {
    case .QUIT;
      ENGINE_SHOULD_QUIT = true;
    case .KEYBOARD;
      if event.key_pressed {
        if event.key_code == .ESCAPE {
          ENGINE_SHOULD_QUIT = true;
        }
      }
  }
}

main :: () {
  // Start - finish messages
  print("the-floor-is-lava project\n");
  defer print("finishing with success!\n");

  // Set Windows DPI aware stuff
  #if OS == .WINDOWS {
    win32 :: #import "Windows";
    win32.SetProcessDPIAware();
  }

  // Initializing Simp
  MAIN_ENGINE_WINDOW = create_window(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE_BAR);
  Simp.set_render_target(MAIN_ENGINE_WINDOW);

  // Initializing GetRect
  GetRect.ui_init();

  // Setting render dimensions
  // simp_window_width, simp_window_height := Simp.get_render_dimensions(MAIN_ENGINE_WINDOW);
  // Setup shaders paths in runtime
  vertex_builder, fragment_builder: String_Builder;

  init_string_builder(*vertex_builder);
  init_string_builder(*fragment_builder);

  print_to_builder(*vertex_builder, "%%", #filepath, VERTEX_SHADER_PATH);
  print_to_builder(*fragment_builder, "%%", #filepath, FRAGMENT_SHADER_PATH);

  vertex_path := builder_to_string(*vertex_builder);
  fragment_path := builder_to_string(*fragment_builder);

  shaders_program := load_shaders(vertex_path, fragment_path);
  print("%\n", #filepath);
  print("VSP: %\n", vertex_path);
  print("FSP: %\n", fragment_path);
  print("Shaders program: %\n", shaders_program);

  // Setup simp stuff for getting rect?
  Simp.set_render_target(MAIN_ENGINE_WINDOW);

  // Main loop
  while !ENGINE_SHOULD_QUIT {

    update_window_events();

    for events_this_frame {
      handle_events(it);
    }

    // Clearing screen
    Simp.clear_render_target(.15, .08, .08, 1);
    Simp.set_shader_for_color();

    // Updating UI
    // update_and_render_ui();

    // Swapping buffers
    Simp.swap_buffers(MAIN_ENGINE_WINDOW);
  }
}
