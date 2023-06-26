# Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES.  All rights reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

# empty
import imgui

def imgui_power(power):
    """ imgui forward backward compatibility
        v 1.4 # AttributeError: module 'imgui' has no attribute 'SLIDER_FLAGS_LOGARITHMIC'
        v 2.0 # AssertionError: power parameter obsoleted in ImGui 1.78, use imgui.SLIDER_FLAGS_LOGARITHMIC instead
    """
    if imgui.__version__ >= "2.0":
        return {"flags": imgui.SLIDER_FLAGS_LOGARITHMIC}
    return {"power": power}
def imgui_set_scroll_here():
    """ imgui forward backward compatibility
        v 2.0 # imgui 2.0 deprecates set_scroll_here
        # https://pyimgui.readthedocs.io/en/latest/reference/imgui.core.html
    """
    if imgui.__version__ >= "2.0":
        imgui.core.set_item_default_focus()
    else:
        imgui.set_scroll_here()
