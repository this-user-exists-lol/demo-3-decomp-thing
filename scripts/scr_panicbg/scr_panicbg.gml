var layers;
function scr_panicbg_start() //scr_panicbg_start
{
    if ((!variable_global_exists("panicbg_surface")) || (!surface_exists(global.panicbg_surface)))
        global.panicbg_surface = surface_create((camera_get_view_width(view_camera[0]) + 128), (camera_get_view_height(view_camera[0]) + 128))
    if (event_type == 8 && event_number == 0)
    {
        surface_set_target(global.panicbg_surface)
        draw_clear_alpha(c_black, 0)
        var _cam_x = camera_get_view_x(view_camera[0])
        var _cam_y = camera_get_view_y(view_camera[0])
        var a = layer_get_all()
        for (var i = 0; i < array_length(a); i++)
        {
            var back_id = layer_background_get_id_fixed(layer_get_name(a[i]))
            if (back_id != -1 && (!layer_get_depth(a[i])) <= 0 && layer_get_visible(a[i]))
            {
                layer_x(a[i], (layer_get_x(a[i]) - _cam_x + 64))
                layer_y(a[i], (layer_get_y(a[i]) - _cam_y + 64))
            }
        }
    }
}

function scr_panicbg_end() //scr_panicbg_end
{
    if (event_type == 8 && event_number == 0)
    {
        gpu_set_blendenable(false)
        gpu_set_colorwriteenable(0, 0, 0, 1)
        draw_rectangle(-192, -192, (camera_get_view_width(view_camera[0]) + 192), (camera_get_view_height(view_camera[0]) + 192), 0)
        gpu_set_blendenable(true)
        gpu_set_colorwriteenable(1, 1, 1, 1)
        surface_reset_target()
        shader_set(shd_panicbg)
        var panic_id = shader_get_uniform(shd_panicbg, "panic")
        shader_set_uniform_f(panic_id, (global.wave / global.maxwave))
        var time_id = shader_get_uniform(shd_panicbg, "time")
        shader_set_uniform_f(time_id, (current_time / 1000))
        draw_surface_ext(global.panicbg_surface, (camera_get_view_x(view_camera[0]) - 64), (camera_get_view_y(view_camera[0]) - 64), 1, 1, camera_get_view_angle(view_camera[0]), -1, 1)
        shader_reset()
    }
}

function scr_panicbg_init() //scr_panicbg_init
{
    var layernum = 0
    var a = layer_get_all()
    for (var i = 0; i < array_length(a); i++)
    {
        var back_id = layer_background_get_id_fixed(layer_get_name(a[i]))
        if (back_id != -1 && (!layer_get_depth(a[i])) <= 0 && layer_get_visible(a[i]))
            layers[layernum++] = a[i]
    }
    if (!layernum)
        return;
    var _f = function(argument0, argument1) //anon_scr_panicbg_init_gml_GlobalScript_scr_panicbg_4907_scr_panicbg_init_gml_GlobalScript_scr_panicbg
    {
        return (-((layer_get_depth(argument0) - layer_get_depth(argument1))));
    }

    array_sort(layers, _f)
    var bottom_id = layers[0]
    var top_id = layers[(layernum - 1)]
    layer_script_begin(bottom_id, scr_panicbg_start)
    layer_script_end(top_id, scr_panicbg_end)
}

