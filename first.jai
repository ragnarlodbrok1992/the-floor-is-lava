#run build();

build :: () {
  w := compiler_create_workspace("Target Program");

  options := get_build_options();
  options.output_executable_name = "the-floor-is-lava";
  set_optimization(*options, .DEBUG);
  set_build_options(options, w);

  add_build_file(tprint("%/src/main.jai", #filepath), w);

  set_build_options_dc(.{do_output = false});
}

#import "Basic";
#import "Compiler";

